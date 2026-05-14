//
//  MoveNetOverlayController.swift
//  RepTally
//
//  Created by Samuel Duggan on 05/02/2025.
//

import UIKit
import CoreML
import CoreVideo
import Accelerate
import VideoToolbox
/*
 The TensorFlow2 version of MoveNet Lightning was converted to a CoreML readable .mlpackage so that the inference could be made directly using the Core ML API
 
 Due to the TensorFlow2 version taking an input of type Int32, the conversion was unable to attach an image input type (coremltools expects the input to be Float32) and unfortunately
 converting the model to take a Float32 input seemed to corrupt the model. Thus, the model had to resort to taking an MLMultiArray as an input
 which meant that the CVPixelBuffer created from the camera had to be converted to an MLMultiArray. This process is described below.
 */

class MoveNetOverlayController: UIViewController, PoseEstimator{
    var name = "MoveNet Lightning"
    var pointNameToLocationMapping: [String : CGPoint] = [:]
    let skeletonMapping: [(String, String)] = [
        ("nose","left_eye"),
        ("nose","right_eye"),
        ("left_eye","left_ear"),
        ("right_eye","right_ear"),
        ("left_shoulder","right_shoulder"),
        ("left_shoulder","left_elbow"),
        ("left_elbow","left_wrist"),
        ("right_shoulder","right_elbow"),
        ("right_elbow","right_wrist"),
        ("right_hip","left_hip"),
        ("left_shoulder","left_hip"),
        ("right_shoulder","right_hip"),
        ("left_hip","left_knee"),
        ("right_hip","right_knee"),
        ("left_knee","left_ankle"),
        ("right_knee","right_ankle")
    ]
    let outputOrder: [String] = [
        "nose",
        "left_eye",
        "right_eye",
        "left_ear",
        "right_ear",
        "left_shoulder",
        "right_shoulder",
        "left_elbow",
        "right_elbow",
        "left_wrist",
        "right_wrist",
        "left_hip",
        "right_hip",
        "left_knee",
        "right_knee",
        "left_ankle",
        "right_ankle"
    ]
    var refreshCounter = 0
    
    var cameraManagerModel: CameraManagerModel?
    let overlayView = UIView()
    let context = CIContext()
    var moveNet: movenetfinal?

    override func viewDidLoad() {
        do{
            let config = MLModelConfiguration()
            config.computeUnits = .all
            moveNet = try movenetfinal(configuration: config)
        }
        catch{
            print("error loading movenet \(error)")
            moveNet = nil
        }
        
    }
    
    //Handles prediction and output processing
    func detectBody(in image: CVPixelBuffer) {
        let preprocessingStartTime = Date()
        
        guard let bgraBuffer = convertToBGRA(image),
              let scaledImage = resizePixelBuffer(bgraBuffer, width: 192, height: 192) else {
            print("Failed to preprocess pixel buffer")
            return
        }
        
        //print("MoveNet Preprocessing time: \( Date().timeIntervalSince(preprocessingStartTime))")
        do {
            if !pointNameToLocationMapping.isEmpty{
                pointNameToLocationMapping.removeAll()
            }
            let inferenceStartTime = Date()
            let prediction = try moveNet?.prediction(input_image: scaledImage)
            
            //print("MoveNet inference time: \( Date().timeIntervalSince(inferenceStartTime))")
            let output = prediction?.IdentityShapedArray
            
            let postprocessingStartTime = Date()
            //look at each keypoint location and confidence
            for i in 0..<outputOrder.count {
                let yResult: Float = output![0,0,i,0].scalar!
                let xResult: Float = output![0,0,i,1].scalar!
                let confidence: Float = output![0,0,i,2].scalar!
                print(confidence)
                //scale points to screen and map to name when confidence above threshold
                if confidence >= 0.3{
                    let actualX = CGFloat(1 - xResult) * CGFloat(view.bounds.width)
                    let actualY = CGFloat(yResult) * CGFloat(view.bounds.height)
                    let pointOnScreen = CGPoint(x: actualX, y: actualY)
                    pointNameToLocationMapping[outputOrder[i]] = pointOnScreen
                }
            }
            //print("MoveNet postprocessing time: \( Date().timeIntervalSince(postprocessingStartTime))")
            DispatchQueue.main.async{
                self.cameraManagerModel?.isBodyDetected = !self.pointNameToLocationMapping.isEmpty
            }
            
            if self.cameraManagerModel!.isDisplaySkeleton{
                drawPoints()
                drawLines()
            }
        }
        catch{
            print("movenet prediction failed: \(error)")
            cameraManagerModel?.isBodyDetected = false
        }
    }
    
    func convertToBGRA(_ pixelBuffer: CVPixelBuffer) -> CVPixelBuffer? {
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let context = CIContext()

        var outputBuffer: CVPixelBuffer?
        let attrs: [CFString: Any] = [
            kCVPixelBufferCGImageCompatibilityKey: true,
            kCVPixelBufferCGBitmapContextCompatibilityKey: true,
            kCVPixelBufferPixelFormatTypeKey: kCVPixelFormatType_32BGRA
        ]

        CVPixelBufferCreate(
            kCFAllocatorDefault,
            CVPixelBufferGetWidth(pixelBuffer),
            CVPixelBufferGetHeight(pixelBuffer),
            kCVPixelFormatType_32BGRA,
            attrs as CFDictionary,
            &outputBuffer
        )

        guard let buffer = outputBuffer else { return nil }
        context.render(ciImage, to: buffer)
        return buffer
    }

    func resizePixelBuffer(
        _ srcPixelBuffer: CVPixelBuffer,
        width: Int,
        height: Int
    ) -> CVPixelBuffer? {
        
        CVPixelBufferLockBaseAddress(srcPixelBuffer, .readOnly)
        defer { CVPixelBufferUnlockBaseAddress(srcPixelBuffer, .readOnly) }
        
        guard let srcBaseAddress = CVPixelBufferGetBaseAddress(srcPixelBuffer) else {
            return nil
        }
        
        let srcWidth = CVPixelBufferGetWidth(srcPixelBuffer)
        let srcHeight = CVPixelBufferGetHeight(srcPixelBuffer)
        let srcBytesPerRow = CVPixelBufferGetBytesPerRow(srcPixelBuffer)
        
        var srcBuffer = vImage_Buffer(
            data: srcBaseAddress,
            height: vImagePixelCount(srcHeight),
            width: vImagePixelCount(srcWidth),
            rowBytes: srcBytesPerRow
        )
        
        // Create destination pixel buffer
        var dstPixelBuffer: CVPixelBuffer?
        let attrs = [
            kCVPixelBufferCGImageCompatibilityKey: true,
            kCVPixelBufferCGBitmapContextCompatibilityKey: true
        ] as CFDictionary
        
        CVPixelBufferCreate(
            kCFAllocatorDefault,
            width,
            height,
            CVPixelBufferGetPixelFormatType(srcPixelBuffer),
            attrs,
            &dstPixelBuffer
        )
        
        guard let dst = dstPixelBuffer else { return nil }
        
        CVPixelBufferLockBaseAddress(dst, [])
        defer { CVPixelBufferUnlockBaseAddress(dst, []) }
        
        guard let dstBaseAddress = CVPixelBufferGetBaseAddress(dst) else {
            return nil
        }
        
        var dstBuffer = vImage_Buffer(
            data: dstBaseAddress,
            height: vImagePixelCount(height),
            width: vImagePixelCount(width),
            rowBytes: CVPixelBufferGetBytesPerRow(dst)
        )
        
        // Scale
        let error = vImageScale_ARGB8888(
            &srcBuffer,
            &dstBuffer,
            nil,
            vImage_Flags(kvImageHighQualityResampling)
        )
        
        if error != kvImageNoError {
            return nil
        }
        
        return dst
    }

}



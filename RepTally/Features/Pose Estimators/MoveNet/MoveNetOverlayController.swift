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
    var moveNet: movenetLightningFull?

    override func viewDidLoad() {
        do{
            let config = MLModelConfiguration()
            config.computeUnits = .all
            moveNet = try movenetLightningFull(configuration: config)
        }
        catch{
            print("error loading movenet \(error)")
            moveNet = nil
        }
        
    }
    
    //Handles prediction and output processing
    func detectBody(in image: CVPixelBuffer) {
        refreshCounter += 1
        if refreshCounter != 3 {
            return
        }
        else {
            refreshCounter = 0
        }
        let preprocessingStartTime = Date()
        guard let inputArray = convertResizePixelBufferAsMultiArray(image, width: 192, height: 192)else {
            print("failed to convert pixel buffer to multiarray")
            return
        }
        print("MoveNet Preprocessing time: \( Date().timeIntervalSince(preprocessingStartTime))")
        do {
            if !pointNameToLocationMapping.isEmpty{
                pointNameToLocationMapping.removeAll()
            }
            let inferenceStartTime = Date()
            let prediction = try moveNet?.prediction(input: inputArray)
            print("MoveNet inference time: \( Date().timeIntervalSince(inferenceStartTime))")
            let output = prediction?.IdentityShapedArray
            
            let postprocessingStartTime = Date()
            //look at each keypoint location and confidence
            for i in 0..<outputOrder.count {
                let yResult: Float = output![0,0,i,0].scalar!
                let xResult: Float = output![0,0,i,1].scalar!
                let confidence: Float = output![0,0,i,2].scalar!
                
                //scale points to screen and map to name when confidence above threshold
                if confidence >= 0.2 {
                    let actualX = CGFloat(1 - xResult) * CGFloat(view.bounds.width)
                    let actualY = CGFloat(yResult) * CGFloat(view.bounds.height)
                    let pointOnScreen = CGPoint(x: actualX, y: actualY)
                    pointNameToLocationMapping[outputOrder[i]] = pointOnScreen
                }
            }
            print("MoveNet inference time: \( Date().timeIntervalSince(postprocessingStartTime))")
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
    
    
    
    /*
     Converts and resizes the CVPixelBuffer from the camera output to a MLMultiArray of type Int32 to be readable by the model.
     
     Apple (n.d.) describes CVPixelBuffer to be 'an image buffer that holds pixels in main memory' meaning it would be possible to iterate over the pixels as they are stored in memory and append them to a corresponding MLMultiArray of the same shape. (converting them into Int32)
     
     hxo (2017) overviews a method to efficiently resize the CVPixelBuffer using the same principle by utilising accelerate and vImage buffer
     
     CVPixelBuffer has an API allowing the inspection of the pixels as they are stored in memory which makes this possible
     https://developer.apple.com/documentation/corevideo/cvpixelbuffer-q2e
     */
    internal func convertResizePixelBufferAsMultiArray(_ pixelBuffer: CVPixelBuffer, width: Int, height: Int) -> MLMultiArray? {
        
        //code adapted from Swift Package Index (n.d) and Apple (n.d.)  https://swiftpackageindex.com/computer-graphics-tools/core-video-tools/main/documentation/corevideotools/workingwithcvpixelbuffer
        //The documentation mentions that pixel buffers must be locked to read only when inspecting it to ensure safe access in memory.
        CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
        defer { CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly) }
        
        guard let srcBaseAddress = CVPixelBufferGetBaseAddress(pixelBuffer) else {
            print("Unable to get base address from source pixel buffer")
            return nil
        }
        
        let srcWidth = CVPixelBufferGetWidth(pixelBuffer)
        let srcHeight = CVPixelBufferGetHeight(pixelBuffer)
        let srcBytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer)
        //end of adapted code
        
        //code adapted from hxo (2017) & Stoneage (2017) https://developer.apple.com/forums/thread/90801
        //allocate memory for the resulting vImage buffer (resized CVPixelBuffer)
        let destBytesPerRow = width * 4
        guard let destData = malloc(height * destBytesPerRow) else {
            print("Unable to allocate memory for destination buffer")
            return nil
        }
        
        //create vImage buffer for the source (original dimensions)
        var srcBuffer = vImage_Buffer(data: srcBaseAddress,
                                      height: vImagePixelCount(srcHeight),
                                      width: vImagePixelCount(srcWidth),
                                      rowBytes: srcBytesPerRow)
        
        //create vImage buffer for the result (desired dimensions)
        var destBuffer = vImage_Buffer(data: destData,
                                       height: vImagePixelCount(height),
                                       width: vImagePixelCount(width),
                                       rowBytes: destBytesPerRow)
        
        //scale the source buffer to the destination buffer
        let error = vImageScale_ARGB8888(&srcBuffer, &destBuffer, nil, vImage_Flags(0))
        if error != kvImageNoError {
            print("vImageScale_ARGB8888 error:", error)
            free(destData)
            return nil
        }
        //end of adapted code
        
        //Create an MLMultiArray, the same shape as the expected input of the model.
        let shape: [NSNumber] = [1, NSNumber(value: height), NSNumber(value: width), 3]
        guard let multiArray = try? MLMultiArray(shape: shape, dataType: .int32) else {
            print("Failed to create MLMultiArray.")
            free(destData)
            return nil
        }
        
        //code adapted from Alvarez (2018) ** https://stackoverflow.com/questions/51537698/how-can-i-read-individual-pixels-from-a-cvpixelbuffer
        //Converts the pointer to the destination buffer to UInt8 instead of a raw memory address
        //(this will assist in iterating through the pixels in memory)
        let destPtr = destBuffer.data.assumingMemoryBound(to: UInt8.self)
        
        //Iterate over each pixel based on the location of the first pixel using Alvarez's method
        /*
        The pixel buffer is in the format kCVPixelFormatType_32BGRA, providing the information necessary to obtain the
         correct information.
         
         y*bytesPerRow moves the pointer to the current row
         x*4 moves the pointer to the current pixel in the row because each pixel has 4 bytes of data (32 bits)
         index 0 from the selected address correlates to the blue channel
         index 1 correlates to the green channel
         index 2 correlates to the red channel
         index 3 correlates to the alpha channel, hence it being ignored
         */
        for y in 0..<height {
            for x in 0..<width {
                let pixelAddress = destPtr + (y * destBuffer.rowBytes) + (x * 4)
                let b = Int32(pixelAddress[0])
                let g = Int32(pixelAddress[1])
                let r = Int32(pixelAddress[2])
                
                //place the values in the corresponding places in the MLMultiArray as Int32
                multiArray[[0, NSNumber(value: y), NSNumber(value: x), 0]] = NSNumber(value: r)
                multiArray[[0, NSNumber(value: y), NSNumber(value: x), 1]] = NSNumber(value: g)
                multiArray[[0, NSNumber(value: y), NSNumber(value: x), 2]] = NSNumber(value: b)
            }
        }
        //end of adapted code
        free(destData)
        return multiArray
    }

    
    
}



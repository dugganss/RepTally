//
//  MoveNetOverlayController.swift
//  RepTally
//
//  Created by Samuel Duggan on 05/02/2025.
//

import UIKit
import CoreML
/*
 The TensorFlow2 version of MoveNet Thunder was converted to a CoreML readable .mlpackage so that the inference could be made directly using the CoreMl API
 
 Due to MoveNet taking an input of type Int32, the conversion was unable to attach an image input type (CoreML expects the input to be Float32) and unfortunately
 converting the model to take a Float32 input seemed to cause the model to become confused. Thus, the model had to resort to taking an MLMultiArray as an input
 which meant that the CVPixelBuffer created from the camera had to be converted to an MLMultiArray. This process is described below.
 */

class MoveNetOverlayController: UIViewController, PoseEstimator{
    var pointNameToLocationMapping: [String : CGPoint] = [:] //this should get populated in detectBody after results are fetched
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
    var output: [String: [Float?]] = [:]
    var points: [CGPoint] = []
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
    
    var cameraManagerModel: CameraManagerModel?
    let overlayView = UIView()
    
    var moveNet: movenetLightningFull? {
        do{
            let config = MLModelConfiguration()
            return try movenetLightningFull(configuration: config)
        }
        catch{
            print("error loading movenet \(error)")
            return nil
        }
    }
    
    func detectBody(in image: CVPixelBuffer) {
        guard let inputArray = multiArrayFromPixelBuffer(image, width: 192, height: 192)else {
            print("failed to convert pixel buffer to multiarray")
            return
        }
        
        do {
            points.removeAll()
            let prediction = try moveNet?.prediction(input: inputArray)
            
            let output = prediction?.Identity
            //extracts the keypoints and confidence scores to a list
            
            
            for i in 0..<outputOrder.count {
                // Construct multi-dimensional indices.
                let yIndex: [NSNumber] = [0, 0, NSNumber(value: i), 0]  // y coordinate
                let xIndex: [NSNumber] = [0, 0, NSNumber(value: i), 1]  // x coordinate
                let confidenceIndex: [NSNumber] = [0, 0, NSNumber(value: i), 2]  // confidence
                
                // Retrieve values from the MLMultiArray. These are stored as NSNumber.
                guard let yNumber = output![yIndex] as? NSNumber,
                      let xNumber = output![xIndex] as? NSNumber,
                      let confidenceNumber = output![confidenceIndex] as? NSNumber else {
                    print("Error accessing multiarray values for joint \(outputOrder[i])")
                    continue
                }
                
                let y = yNumber.floatValue
                let x = xNumber.floatValue
                let confidence = confidenceNumber.floatValue
                
                // Filter out keypoints with confidence less than threshold.
                if confidence >= 0.3 {
                    // Multiply normalized coordinates (assumed to be 0-1) by original dimensions.
                    let actualX = CGFloat(1 - x) * CGFloat(view.bounds.width)
                    let actualY = CGFloat(y) * CGFloat(view.bounds.width)
                    points.append(CGPoint(x: actualX, y: actualY))
                }
                
                
            }
            drawPoints()
            
            /*
            var i: Int = -1
            for name in outputOrder {
                i += 1
                var values: [Float?] = []
                for j in 0..<3 {
                    values.append(shapedArrayOutput?[0, 0, i, j].scalar)
                }
                output[name] = values
            }
            for a in output{
                print(a)
            }
             */
        }
        catch{
            print("movenet prediction failed: \(error)")
        }
    }
    
    internal func drawPoints(){
        DispatchQueue.main.async{
            //remove previously drawn points
            self.view.subviews.forEach{ $0.removeFromSuperview()}
            if !self.points.isEmpty{
                //draw a square at every point within view
                self.points.forEach{ point in
                    let pointView = UIView()
                    pointView.frame = CGRect(x: point.x
                                             - 2.5, y: point.y - 2.5, width: 5, height: 5)
                    pointView.backgroundColor = .red
                    self.view.addSubview(pointView)
                }
            }
        }
        
    }
    
    func resizePixelBuffer(_ pixelBuffer: CVPixelBuffer, width: Int, height: Int) -> CVPixelBuffer? {
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let scaleX = CGFloat(width) / CGFloat(CVPixelBufferGetWidth(pixelBuffer))
        let scaleY = CGFloat(height) / CGFloat(CVPixelBufferGetHeight(pixelBuffer))
        let resizedImage = ciImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
        
        //code adapted from MLBoy (2020)https://rockyshikoku.medium.com/ciimage-to-cvpixelbuffer-93b0a639ab32
        var resizedPixelBuffer: CVPixelBuffer?
        let attrs: [CFString: Any] = [
            kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue as Any,
            kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue as Any
        ]
        CVPixelBufferCreate(kCFAllocatorDefault,
                                     width,
                                     height,
                                     CVPixelBufferGetPixelFormatType(pixelBuffer),
                                     attrs as CFDictionary,
                                     &resizedPixelBuffer)
        
        let context = CIContext()
        if let resizedPixelBuffer = resizedPixelBuffer {
            context.render(resizedImage, to: resizedPixelBuffer)
            return resizedPixelBuffer
        }
        //end of adapted code
        
        return nil
    }

    /*
     Converts the CVPixelBuffer from the camera output to a MLMultiArray of type Int32 to be readable by the model.
     
     Apple (n.d.) describes CVPixelBuffer to be 'an image buffer that holds pixels in main memory' meaning it would be
     possible to iterate over the pixels as they are stored in memory and append them to a corresponding MLMultiArray
     of the same shape. (converting them into Int32)
     
     CVPixelBuffer has an API allowing the inspection of the pixels as they are stored in memory which makes this possible
     https://developer.apple.com/documentation/corevideo/cvpixelbuffer-q2e
     */
    func multiArrayFromPixelBuffer(_ pixelBuffer: CVPixelBuffer, width: Int, height: Int) -> MLMultiArray? {
        //Resize the pixel buffer to match the shape of the expected input of the model.
        guard let resizedBuffer = resizePixelBuffer(pixelBuffer, width: width, height: height) else {
            print("Failed to resize pixel buffer.")
            return nil
        }
        
        //Create an MLMultiArray, the same shape as the expected input of the model.
        let shape: [NSNumber] = [1, NSNumber(value: height), NSNumber(value: width), 3]
        guard let multiArray = try? MLMultiArray(shape: shape, dataType: .int32) else {
            print("Failed to create MLMultiArray.")
            return nil
        }
        
        //code adapted from Swift Package Index (n.d) and Apple (n.d.) * https://swiftpackageindex.com/computer-graphics-tools/core-video-tools/main/documentation/corevideotools/workingwithcvpixelbuffer
        //The documentation mentions that pixel buffers must be locked to read only when inspecting it to ensure safe access in memory.
        CVPixelBufferLockBaseAddress(resizedBuffer, .readOnly)
        defer { CVPixelBufferUnlockBaseAddress(resizedBuffer, .readOnly) }
        
        guard let baseAddress = CVPixelBufferGetBaseAddress(resizedBuffer) else {
            print("Unable to access pixel buffer base address.")
            return nil
        }
        
        //code adapted from Alvarez (2018) ** https://stackoverflow.com/questions/51537698/how-can-i-read-individual-pixels-from-a-cvpixelbuffer
        let bytesPerRow = CVPixelBufferGetBytesPerRow(resizedBuffer)
        let widthResized = CVPixelBufferGetWidth(resizedBuffer)
        let heightResized = CVPixelBufferGetHeight(resizedBuffer)
        // end of adapted code *
        
        //Converts the baseAddress pointer to UInt8 instead of raw memory address
        //(this will assist in iterating through the pixels in memory)
        let bufferPointer = baseAddress.assumingMemoryBound(to: UInt8.self)
        
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
        for y in 0..<heightResized {
            for x in 0..<widthResized {
                let pixelAddress = bufferPointer + (y * bytesPerRow) + (x * 4)
                let b = Int32(pixelAddress[0])
                let g = Int32(pixelAddress[1])
                let r = Int32(pixelAddress[2])
                
                //place the values in the corresponding places in the MLMultiArray as Int32
                multiArray[[0, NSNumber(value: y), NSNumber(value: x), 0]] = NSNumber(value: r)
                multiArray[[0, NSNumber(value: y), NSNumber(value: x), 1]] = NSNumber(value: g)
                multiArray[[0, NSNumber(value: y), NSNumber(value: x), 2]] = NSNumber(value: b)
            }
        }
        //end of adapted code **
        return multiArray
    }
}

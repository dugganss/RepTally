//
//  PoseNetOverlayController.swift
//  RepTally
//
//  Created by Samuel Duggan on 16/04/2025.
//

import UIKit
import VideoToolbox
import CoreML

class PoseNetOverlayController: UIViewController, PoseEstimator {
    var cameraManagerModel: CameraManagerModel?
    
    var overlayView = UIView()
    
    var pointNameToLocationMapping: [String : CGPoint] = [:]
    
    var oldMapping: [String : CGPoint] = [:]
    
    var heatmapScores: [String : Double] = [:]
    
    var skeletonMapping: [(String, String)] = [
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
    
    var name = "PoseNet"
    
    var poseNet: PoseNetMobileNet075S16FP16? {
        do{
            let config = MLModelConfiguration()
            return try PoseNetMobileNet075S16FP16(configuration: config)
        }
        catch{
            print("error loading poseNet \(error)")
            return nil
        }
    }
    
    func detectBody(in image: CVPixelBuffer) {
        //code adapted from Apple (n.d.) https://developer.apple.com/documentation/coreml/detecting-human-body-poses-in-an-image
        //Apple provided a sample project implementing PoseNet, the model has been configured to accept an image input (automatic preprocessing)
        guard CVPixelBufferLockBaseAddress(image, .readOnly) == kCVReturnSuccess else {
            return
        }
        
        var cgImage: CGImage?
        
        VTCreateCGImageFromCVPixelBuffer(image, options: nil, imageOut: &cgImage)
        CVPixelBufferUnlockBaseAddress(image, .readOnly)
        
        do{
            let input = try PoseNetMobileNet075S16FP16Input(imageWith: cgImage!)
            guard let prediction = try? self.poseNet?.prediction(input: input) else{
                print("poseNet prediction failed")
                return
            }
            //end of adapted code
            
            applyKeypointDefinitionPostProcessing(to: prediction)
            
            applyAccuracyPostProcessing()
            
            DispatchQueue.main.async{
                self.cameraManagerModel?.isBodyDetected = !self.pointNameToLocationMapping.isEmpty
            }
            
            if self.cameraManagerModel!.isDisplaySkeleton{
                drawPoints()
                drawLines()
            }
        }
        catch{
            print("error when adding posenet input: \(error)")
            cameraManagerModel?.isBodyDetected = false
        }
    }
    
    internal func applyKeypointDefinitionPostProcessing(to prediction: PoseNetMobileNet075S16FP16Output){
        /*
         PoseNet's output consists of multiple MLShapedArrays (outlined in the generated PoseNetMobileNet075S16FO16Output class)
         
         The heatmap array consists of a heatmap grid for each respective keypoint in the shape [17,33,33] where the 33x33 heatmap is a majorly scaled down array representing the input image. This means finding the point with the highest confidence and using its location in the array allows the calculation of where it would be in the image.
         
         the offset array consists of offsets for each x and y coordinate for each keypoint in the shape [34,33,33]. the first 17 refer to the height, with the following 17 refering to the width. so the correlating x to an y coordinate is found at (n + number of joints).
         
         Applying these values together should allow for pixel level accuracy of keypoints.
         */
        let heatMapShapedArray = prediction.heatmapShapedArray
        let offsetShapedArray = prediction.offsetsShapedArray
        
        //Find the point with the highest confidence for each point in the heatmaps
        for i in 0..<outputOrder.count {
            var heatmapMax: Double = -Double.infinity
            var bestWidth = 0
            var bestHeight = 0
            var pointOffset: CGVector? = nil
            
            for height in 0..<33{
                for width in 0..<33{
                    guard var currentConfidence = heatMapShapedArray[i,height,width].scalar else {
                        continue
                    }
                    if currentConfidence > heatmapMax {
                        heatmapMax = currentConfidence
                        bestHeight = height
                        bestWidth = width
                    }
                }
            }
            // code adapted from Apple (2024) (PoseBuilder)
            //Find the offset for the optimal point in the heatmap and ignore the value if it doesn't exist
            guard let offsetY = offsetShapedArray[i,bestHeight,bestWidth].scalar,
                  var offsetX = offsetShapedArray[i + outputOrder.count, bestHeight, bestWidth].scalar else {
                pointNameToLocationMapping.removeValue(forKey: outputOrder[i])
                continue
            }
            offsetX = 1 - offsetX
            
            pointOffset = CGVector(dx: CGFloat(offsetX), dy: CGFloat(offsetY))
            // end of adapted code
            
            heatmapScores[outputOrder[i]] = heatmapMax
            
            //scale the approximate values to the screen and apply the correlated offset when the confidence if above the threshold, also link it to it named target.
            if heatmapMax >= 0.3 {
                let coarseX = CGFloat(bestWidth) * (CGFloat(view.bounds.width) / 33.0)
                let coarseY = CGFloat(bestHeight) * (CGFloat(view.bounds.height) / 33.0)
                //code adapted from Apple (2024) (PoseBuilder)
                var position = CGPoint(x: coarseX, y: coarseY)
                position += pointOffset!
                //end of adapted code
                position.x = view.bounds.width - position.x
                pointNameToLocationMapping[outputOrder[i]] = position
            }
            else{
                pointNameToLocationMapping.removeValue(forKey: outputOrder[i])
            }
        }
    }
    
    internal func applyAccuracyPostProcessing() {
        //The raw result happened to be fairly inaccurate so further post processing was undertaken
        
        //swap left and right shoulders if PoseNet hallucinates that they are on opposite sides
        if let left = pointNameToLocationMapping["left_shoulder"], let right = pointNameToLocationMapping["right_shoulder"], left.x > right.x {
            if heatmapScores["left_shoulder"]! < heatmapScores["right_shoulder"]! {
                let temp: CGPoint = pointNameToLocationMapping["left_shoulder"]!
                pointNameToLocationMapping["left_shoulder"] = pointNameToLocationMapping["right_shoulder"]
                pointNameToLocationMapping["right_shoulder"] = temp
            }
        }
        
        //swap left and right hips if PoseNet hallucinates that they are on opposite sides
        if let left = pointNameToLocationMapping["left_hip"], let right = pointNameToLocationMapping["right_hip"], left.x > right.x {
            if heatmapScores["right_hip"]! < heatmapScores["left_hip"]! {
                let temp: CGPoint = pointNameToLocationMapping["left_hip"]!
                pointNameToLocationMapping["left_hip"] = pointNameToLocationMapping["right_hip"]
                pointNameToLocationMapping["right_hip"] = temp
            }
        }
        
        //Apply single exponential smoothing from the previous prediction to prevent jitter and sudden changes in prediction (minor false positives)
        var smoothedPoints: [String: CGPoint] = [:]
        let a: CGFloat = 0.4
        for (joint, point) in pointNameToLocationMapping {
            if let oldP = oldMapping[joint] {
                //formula adapted from GeeksForGeeks (2024) https://www.geeksforgeeks.org/exponential-smoothing-forecast-formula/
                let x = oldP.x * (1 - a) + point.x * a
                let y = oldP.y * (1 - a) + point.y * a
                //end of adapted formula
                smoothedPoints[joint] = CGPoint(x: x, y: y)
            } else {
                smoothedPoints[joint] = point
            }
        }
        pointNameToLocationMapping = smoothedPoints
        oldMapping = smoothedPoints
    }
    
    internal func drawPoints(){
        DispatchQueue.main.async{
            //remove previously drawn points and lines
            self.view.subviews.forEach{ $0.removeFromSuperview()}
            if !self.pointNameToLocationMapping.isEmpty{
                //draw a square at every point within view
                for (_, point) in self.pointNameToLocationMapping{
                    let pointView = UIView()
                    pointView.frame = CGRect(x: point.x, y: point.y, width: 5, height: 5)
                    pointView.backgroundColor = .red
                    self.view.addSubview(pointView)
                }
            }
        }
    }
    
    internal func drawLines(){
        DispatchQueue.main.async{
            //iterates through the skeletonMapping array which defines which points (by name) should be connected to each other
            for connection in self.skeletonMapping{
                //checks both the points exist
                if self.pointNameToLocationMapping.keys.contains(connection.0) && self.pointNameToLocationMapping.keys.contains(connection.1){
                    //draws BezierPath between the two point's locations using LineDrawingView
                    let lineView = LineDrawingView(frame: self.view.bounds)
                    lineView.backgroundColor = .clear
                    guard let startPoint = self.pointNameToLocationMapping[connection.0] else {
                        return
                    }
                    guard let endPoint = self.pointNameToLocationMapping[connection.1] else {
                        return
                    }
                    lineView.startPoint = startPoint
                    lineView.endPoint = endPoint
                    self.view.addSubview(lineView)
                }
            }
        }
    }
}

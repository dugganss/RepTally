//
//  VisionOverlayController.swift
//  RepTally
//
//  Created by Samuel Duggan on 02/12/2024.
//
/*
 This module overlays another view (preferably an image or camera feed) and is capable
 of making a pose estimation request to Vision and draw keypoints and connections
 between the keypoints.
*/
 
import UIKit
import Vision

class VisionOverlayController : UIViewController, PoseEstimator{
    var name = "Vision"
    var cameraManagerModel: CameraManagerModel?
    let overlayView = UIView()
    var pointNameToLocationMapping : [String: CGPoint] = [:]
    let skeletonMapping = [
        ("root", "neck_1_joint"),
        ("neck_1_joint", "head_joint"),
        ("head_joint", "left_eye_joint"),
        ("head_joint", "right_eye_joint"),
        ("head_joint", "left_ear_joint"),
        ("head_joint", "right_ear_joint"),
        ("neck_1_joint", "left_shoulder_1_joint"),
        ("neck_1_joint", "right_shoulder_1_joint"),
        ("left_shoulder_1_joint", "left_forearm_joint"),
        ("left_forearm_joint", "left_hand_joint"),
        ("right_shoulder_1_joint", "right_forearm_joint"),
        ("right_forearm_joint", "right_hand_joint"),
        ("root", "left_upLeg_joint"),
        ("left_upLeg_joint", "left_leg_joint"),
        ("left_leg_joint", "left_foot_joint"),
        ("root", "right_upLeg_joint"),
        ("right_upLeg_joint", "right_leg_joint"),
        ("right_leg_joint", "right_foot_joint"),
    ]
    
    internal func mapPointToOverlay(at point: CGPoint, in image: CVPixelBuffer) -> CGPoint {
        let overlayWidth = CGFloat(view.bounds.width)
        let overlayHeight = CGFloat(view.bounds.height)
        
        let x = point.x * overlayWidth
        let y = (1 - point.y) * overlayHeight
        return CGPoint(x: x, y: y)
    }
    
    func detectBody(in image: CVPixelBuffer){
        //code adapted from Tustanowski (2023) and Ajwani (2019) https://medium.com/@kamil.tustanowski/detecting-body-pose-using-vision-framework-caba5435796a
        //https://medium.com/onfido-tech/live-face-tracking-on-ios-using-vision-framework-adf8a1799233
        let bodyPoseRequest = VNDetectHumanBodyPoseRequest(completionHandler: { (request: VNRequest, error: Error?) in
            DispatchQueue.main.async{
                guard let results = request.results as? [VNHumanBodyPoseObservation]
                else{
                    print("Not detecting any people")
                    self.cameraManagerModel?.isBodyDetected = false
                    return
                }
                
                let postProcessingStartTime = Date()
                
                self.cameraManagerModel?.isBodyDetected = !results.isEmpty
                let normalisedPoints = results.flatMap{ result in
                    result.availableJointNames
                        .compactMap{jointName in
                            try? result.recognizedPoint(jointName)}
                        .filter { $0.confidence > 0.1}
                }
                
                //set the map between keypoint names and location
                for point in normalisedPoints{
                    self.pointNameToLocationMapping[point.identifier.rawValue] = self.mapPointToOverlay(at: point.location, in: image)
                }
                
                print("vision postprocessing time: \(Date().timeIntervalSince(postProcessingStartTime))")
                
                //Empties line connections to be drawn if there is no one in the frame
                if normalisedPoints.isEmpty{
                    self.pointNameToLocationMapping.removeAll()
                }
                
                if self.cameraManagerModel!.isDisplaySkeleton{
                    self.drawPoints()
                    self.drawLines()
                }
            }
        })
        
        let requestHandler = VNImageRequestHandler(cvPixelBuffer: image, orientation: .upMirrored , options: [:])
        do{
            let inferenceStartTime = Date()
            try requestHandler.perform([bodyPoseRequest])
            print("vision inference time: \(Date().timeIntervalSince(inferenceStartTime))")
        } catch{
            print("Can't make request due to \(error)")
            cameraManagerModel?.isBodyDetected = false
        }
        //end of adapted code
        
        
    }
}

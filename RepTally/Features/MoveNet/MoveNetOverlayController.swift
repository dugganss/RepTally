//
//  MoveNetOverlayController.swift
//  RepTally
//
//  Created by Samuel Duggan on 05/02/2025.
//

import UIKit
import TensorFlowLite
/*
 TODO: implement movenet, will have to do image preprocessing, also implement methods that draw to the overlayView like in VisionOverlayController
 */

class MoveNetOverlayController: UIViewController, PoseEstimator{
    var pointNameToLocationMapping: [String : CGPoint] = [:] //this should get populated in detectBody after results are fetched
    let skeletonMapping: [(String, String)] = [("","")] //need to find out the names of the keypoints and link them together
    var cameraManagerModel: CameraManagerModel?
    let overlayView = UIView()
    
    func detectBody(in image: CVPixelBuffer) {
        print("needs definition")
    }
    
}

//
//  PoseEstimator.swift
//  RepTally
//
//  Created by Samuel Duggan on 05/02/2025.
//

import UIKit

protocol PoseEstimator: UIViewController {
    // Contains flags to control whether the skeleton is being displayed
    var cameraManagerModel: CameraManagerModel? {get set}
    // The view used to draw the skeleton - set up automatically
    var overlayView: UIView {get}
    // The joints (by name) associated to the point in the view that it is located
    var pointNameToLocationMapping : [String: CGPoint] {get set}
    // The joints that should be connected together (based on name of joint)
    var skeletonMapping : [(String, String)] {get}
    // The name of the model being used
    var name: String {get}
    // The model inference should be contained here
    func detectBody(in image: CVPixelBuffer)
}

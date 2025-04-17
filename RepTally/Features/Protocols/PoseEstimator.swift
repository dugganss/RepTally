//
//  PoseEstimator.swift
//  RepTally
//
//  Created by Samuel Duggan on 05/02/2025.
//

import UIKit

protocol PoseEstimator: UIViewController {
    var cameraManagerModel: CameraManagerModel? {get set}
    var overlayView: UIView {get}
    var pointNameToLocationMapping : [String: CGPoint] {get set}
    var skeletonMapping : [(String, String)] {get}
    var name: String {get}
    func detectBody(in image: CVPixelBuffer)
    
}

//
//  PoseEstimator.swift
//  RepTally
//
//  Created by Samuel Duggan on 05/02/2025.
//

import UIKit

protocol PoseEstimator: UIViewController {
    var cameraManagerModel: CameraManagerModel? {get set}
    func detectBody(in image: CVPixelBuffer)
    func setupOverlayView(in frame: CGRect)
}

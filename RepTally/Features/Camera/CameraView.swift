//
//  CameraView.swift
//  RepTally
//
//  Created by Samuel Duggan on 13/01/2025.
//

import SwiftUI

/*
 This view is a SwiftUI compatible cast of the CameraViewController so that the camera can be
 displayed in the rest of the SwiftUI app. This is because the camera is only accessible through
 UIKit.
 */

struct CameraView: UIViewControllerRepresentable {
    var cameraManagerModel: CameraManagerModel
    var poseEstimator: PoseEstimator
    private let cameraViewController = CameraViewController()
    
    func makeUIViewController(context: Context) -> some UIViewController {
        cameraViewController.cameraManagerModel = cameraManagerModel
        cameraViewController.poseEstimator = poseEstimator
        return cameraViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {} // added for conformance
}

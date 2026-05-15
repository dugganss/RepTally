//
//  CameraInfoModel.swift
//  RepTally
//
//  Created by Samuel Duggan on 03/02/2025.
//

import Combine
/*
 This module is used to view and control certain aspects of the CameraViewController through the CameraView and modules that conform to PoseEstimator.
 By implementing ObservableObject, and using the @Published property wrapper, whenever the state of this module's properties are changed, any views that use this module's properties will be forced to update.
 
 It essentially acts as a communication bridge between the SwiftUI views and the classes that manage the camera and pose estimation processing.
 (Meaning the views can affect the behaviour of those modules and vice versa)
 
 */
//code adapted from Hudson (2021)
class CameraManagerModel: ObservableObject{
    @Published var isBodyDetected: Bool = false
    @Published var isDisplayCameraFeed: Bool = true
    @Published var isDisplaySkeleton: Bool = true
}
//end of adapted code

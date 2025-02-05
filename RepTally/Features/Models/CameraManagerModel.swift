//
//  CameraInfoModel.swift
//  RepTally
//
//  Created by Samuel Duggan on 03/02/2025.
//

import Combine
/*
 This module is used to fetch and control certain aspects of the VisionOverlayController and CameraViewController through the CameraView.
 By implementing ObservableObject, and using the @Published property wrapper, whenever the state of this module's properties are changed
 in VisionOverlayController or CameraViewController, any views that use this module's properties will be forced to update.
 
 It essentially acts as a communication bridge between the SwiftUI views and the classes that manage the camera and pose estimation processing.
 (Meaning the views can affect the behaviour of those modules and vice versa)
 
 For example, isBodyDetected is used to update FrameCheckView when a body is detected in VisionOverlayController so that it
 can be determined whether to move on to the next screen.
 */
//code adapted from Hudson (2021) https://www.hackingwithswift.com/quick-start/swiftui/how-to-use-observedobject-to-manage-state-from-external-objects
class CameraManagerModel: ObservableObject{
    @Published var isBodyDetected: Bool = false
    @Published var isDisplayCameraFeed: Bool = true
    @Published var isDisplaySkeleton: Bool = true
}
//end of adapted code

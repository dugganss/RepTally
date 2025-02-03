//
//  CameraInfoModel.swift
//  RepTally
//
//  Created by Samuel Duggan on 03/02/2025.
//

import Combine
/*
 This module is used to fetch information from the OverlayViewController as it detects a person in the camera feed.
 By implementing ObservableObject, and using the @Published property wrapper, whenever the state of this module's
 properties are changed, any views that implement CameraInfoModel will be forced to update.
 
 For example, this is used to update FrameCheckView when a body is detected in OverlayViewController so that it can
 be determined whether to move on to the next screen.
 */
//code adapted from Hudson (2021) https://www.hackingwithswift.com/quick-start/swiftui/how-to-use-observedobject-to-manage-state-from-external-objects
class CameraInfoModel: ObservableObject{
    @Published var isBodyDetected: Bool = false
}
//end of adapted code

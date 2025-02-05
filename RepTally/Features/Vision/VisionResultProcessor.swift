//
//  VisionResultProcessor.swift
//  RepTally
//
//  Created by Samuel Duggan on 05/02/2025.
//
import Combine

/*
 What do you want this module to do:
 - be callable in a view to directly retrieve information about the pose
 - calculate the angles between all the joints
 
 overall:
 - you want a MoveNetOverlayController to do the exact same thing that the VisionOverlayController does
 - perhaps make CameraViewController more generic so that it will work with both overlays just fine
 - you then want a MoveNetResultProcessor which does the exact same thing that this module does but for MoveNet's
 output... ultimately in the end, you want them both to produce the same output so there can be a single module to
 determine whether the action has been complete
 
 this idea has been refined in your book
 */

class VisionResultProcessor: ObservableObject{
    
}

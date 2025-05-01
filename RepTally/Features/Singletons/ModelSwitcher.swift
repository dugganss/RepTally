//
//  ModelSwitcher.swift
//  RepTally
//
//  Created by Samuel Duggan on 16/04/2025.
//
import Combine

/*
 Globally maintains the current model selected, making them easily hot swappable
 */

class ModelSwitcher : ObservableObject {
    static let shared = ModelSwitcher()
    
    private let moveNet = MoveNetOverlayController()
    private let vision = VisionOverlayController()
    private let poseNet = PoseNetOverlayController()
    @Published var currentModel: PoseEstimator
    let options = ["Vision", "MoveNet Lightning", "PoseNet"]
    
    private init() {
        self.currentModel = vision
    }
    
    func setModel(to model: String){
        switch(model){
        case "MoveNet Lightning":
            currentModel = moveNet
        case "Vision":
            currentModel = vision
        case "PoseNet":
            currentModel = poseNet
        default:
            print("Invalid option chosen when setting Model")
        }
    }
    
}

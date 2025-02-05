//
//  PoseEstimatorExtension.swift
//  RepTally
//
//  Created by Samuel Duggan on 05/02/2025.
//
import UIKit

extension PoseEstimator {
    func setupOverlayView(in frame: CGRect){
        DispatchQueue.main.async{
            self.view.frame = frame
            self.view.backgroundColor = .clear
            self.view.addSubview(self.overlayView)
        }
    }
}

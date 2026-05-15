//
//  PoseEstimatorExtension.swift
//  RepTally
//
//  Created by Samuel Duggan on 05/02/2025.
//
import UIKit

extension PoseEstimator {
    // Sets up view for skeleton to be drawn on.
    func setupOverlayView(in frame: CGRect){
        DispatchQueue.main.async{
            self.view.frame = frame
            self.view.backgroundColor = .clear
            self.view.addSubview(self.overlayView)
        }
    }
    
    // Draws the points at the coordinates extracted from the model inference
    internal func drawPoints(){
        DispatchQueue.main.async{
            //remove previously drawn points and lines
            self.view.subviews.forEach{ $0.removeFromSuperview()}
            if !self.pointNameToLocationMapping.isEmpty{
                //draw a square at every point within view
                for (_, point) in self.pointNameToLocationMapping{
                    let pointView = UIView()
                    pointView.frame = CGRect(x: point.x
                                             - 2.5, y: point.y - 2.5, width: 5, height: 5)
                    pointView.backgroundColor = .red
                    self.view.addSubview(pointView)
                }
            }
        }
    }
    
    // Draws lines between points depending on the layout of the skeleton mapping
    internal func drawLines(){
        DispatchQueue.main.async{
            //iterates through the skeletonMapping array which defines which points (by name) should be connected to each other
            for connection in self.skeletonMapping{
                //checks both the points exist
                if self.pointNameToLocationMapping.keys.contains(connection.0) && self.pointNameToLocationMapping.keys.contains(connection.1){
                    //draws BezierPath between the two point's locations using LineDrawingView
                    let lineView = LineDrawingView(frame: self.view.bounds)
                    lineView.backgroundColor = .clear
                    guard let startPoint = self.pointNameToLocationMapping[connection.0] else {
                        return
                    }
                    guard let endPoint = self.pointNameToLocationMapping[connection.1] else {
                        return
                    }
                    lineView.startPoint = startPoint
                    lineView.endPoint = endPoint
                    self.view.addSubview(lineView)
                }
            }
        }
    }
}

//
//  ProgressBar.swift
//  RepTally
//
//  Created by Samuel Duggan on 07/03/2025.
//

import SwiftUI
//code adapted from Apple (n.d.) Scrumdinger tutorial
//https://developer.apple.com/tutorials/app-dev-training/drawing-the-timer-view
struct ProgressBar: Shape {
    let rep: Int
    let totalReps: Int
    
    private var degreesPerRep: Double {
        360.0 / Double(totalReps)
    }
    
    private var startAngle: Angle {
        Angle(degrees: degreesPerRep * Double(rep) + 1.0)
    }
    
    private var endAngle: Angle {
        Angle(degrees: startAngle.degrees + degreesPerRep - 1.0)
    }
    
    func path(in rect: CGRect) -> Path {
        let diameter = min(rect.size.width, rect.size.height) - 24.0
        let radius = diameter / 2.0
        let center = CGPoint(x: rect.midX, y: rect.midY)
        return Path { path in
            path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
            
        }
    }
}
//end of adapted code

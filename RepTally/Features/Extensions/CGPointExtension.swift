//
//  CGPointExtension.swift
//  RepTally
//
//  Created by Samuel Duggan on 17/04/2025.
//
import CoreGraphics

extension CGPoint {
    
    //addition operator between cgpoint and cgvector
    //code adapted from Apple (2024) (PoseFinder project)
    static func += (lhs: inout CGPoint, _ rhs: CGVector) {
        lhs.x += rhs.dx
        lhs.y += rhs.dy
    }
}

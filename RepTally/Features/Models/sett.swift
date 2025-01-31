//
//  Set.swift
//  RepTally
//
//  Created by Samuel Duggan on 13/01/2025.
//
import SwiftUI


//temporary model for set from before persisting data on the device
struct sett: Identifiable {
    var id: Int
    var workout: String = ""
    var reps: Int = 0
    var repeats: Int = 0
}

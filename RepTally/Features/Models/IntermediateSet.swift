//
//  IntermediateSet.swift
//  RepTally
//
//  Created by Samuel Duggan on 13/01/2025.
//
import SwiftUI

//This module is to represent an individual set, used when starting a new session to represent a set
//before it is persisted to the device as a SetData.
struct IntermediateSet: Identifiable {
    var id: Int
    var workout: String = ""
    var reps: Int = 0
    var repeats: Int = 0
}

//
//  Exercise.swift
//  RepTally
//
//  Created by Samuel Duggan on 18/04/2025.
//

enum Exercise: CaseIterable, CustomStringConvertible {
    case squat
    case situp
    case bicepcurl
    
    var description: String {
        switch self {
        case .squat: "Squat"
        case .situp: "Sit Up"
        case .bicepcurl: "Bicep Curl"
        }
    }
}

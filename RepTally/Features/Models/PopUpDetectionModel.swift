//
//  PopUpDetectionModel.swift
//  RepTally
//
//  Created by Samuel Duggan on 04/02/2025.
//

import Combine

/*
 This module is an observable object that uses isPopUpShowing
 as a flag to prevent UI operations from occuring whilst a popup is showing
*/
class PopUpDetectionModel: ObservableObject{
    @Published var isPopUpShowing = true
}

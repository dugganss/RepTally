//
//  ReturnButton.swift
//  RepTally
//
//  Created by Samuel Duggan on 13/01/2025.
//

import SwiftUI

struct ReturnButton:View {
    //code adapted from Ashish (2019)
    @Environment(\.presentationMode) var presentationMode : Binding<PresentationMode>
    var body: some View {
        Button(action: {self.presentationMode.wrappedValue.dismiss()}){
            //end of adapted code
            Image(systemName:"arrow.backward")
                .foregroundStyle(.safeBlack)
                .font(.title2)
                .padding(40)
                .padding(.top,20)
                .padding(.leading,-20)
        }
    }
}


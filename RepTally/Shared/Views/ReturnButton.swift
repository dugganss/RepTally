//
//  ReturnButton.swift
//  RepTally
//
//  Created by Samuel Duggan on 13/01/2025.
//

import SwiftUI

struct ReturnButton:View {
    var body: some View {
        Button(action: {}){
            Image(systemName:"arrow.backward")
                .foregroundStyle(.safeBlack)
                .font(.title)
                .padding(40)
                .padding(.top,20)
        }
    }
}

#Preview {
    ReturnButton()
}

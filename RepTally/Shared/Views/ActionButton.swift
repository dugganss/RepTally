//
//  ActionButton.swift
//  RepTally
//
//  Created by Samuel Duggan on 09/01/2025.
//

import SwiftUI

//TODO: need to add action so that the button does something, style the font

///This is a reusable button element that allows for fast implementation of styled buttons.
///Allows for fast editing, instantiating the button requires parameters which can be set to
///quickly adjust the button to fit the styles as follows:
///- isArrowButton: boolean, when true inserts a arrow icon.
///- isBig: boolean, when true increases width.
///- title: String, sets the text contained within the button.
///- action: function, what the button does when pressed.
struct ActionButton:View {
    var title: String
    //var action: () -> Void
    var isArrowButton : Bool
    var isBig : Bool
    var width : CGFloat
    
    init(title: String, isArrowButton: Bool, isBig: Bool) {
        self.title = title
        self.isArrowButton = isArrowButton
        self.isBig = isBig
        if(self.isBig){
            self.width = UIScreen.main.bounds.width-80
        }else{
            self.width = UIScreen.main.bounds.width-220
        }
        
    }
    
    var body: some View {
        Button(action: {}){
            Text(title)
                .foregroundStyle(.white)
                .padding()
                .font(.title2)
                .bold()
            if(isArrowButton){
                Image(systemName: "arrow.right")
                    .padding()
                    .foregroundStyle(.white)
                    .font(.title2)
                    .bold()
            }
        }
        .frame(width: self.width, height: 60)
        .background(Color("ButtonColour"))
        .cornerRadius(5)
        
        
    }
}

#Preview {
    ActionButton(title: "Go", isArrowButton: true, isBig: false)
}

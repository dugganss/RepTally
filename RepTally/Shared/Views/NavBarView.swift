//
//  NavBarView.swift
//  RepTally
//
//  Created by Samuel Duggan on 09/01/2025.
//
import SwiftUI

///This is the view for the Navigation bar found at the bottom of some pages.
///It has been implemented as its own view to allow for reusability on multiple screens.
struct NavBarView: View {
    var body: some View{
        Color("NavBarColour")
            .overlay{
                HStack{
                    
                    Button(action: {}){
                        Image(systemName: "house")
                            .padding(.leading, 50)
                            .font(.title)
                            .foregroundStyle(Color("SafeBlack"))
                    }
                    
                    Spacer()
                    Button(action: {}){
                        Image(systemName: "person")
                            .padding(.trailing, 50)
                            .font(.title)
                            .foregroundStyle(Color("SafeBlack"))
                    }
                    
                }
            }.frame(width: .infinity ,height: 85)
    }
}

#Preview {
    NavBarView()
}

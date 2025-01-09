//
//  NavBarView.swift
//  RepTally
//
//  Created by Samuel Duggan on 09/01/2025.
//
import SwiftUI

struct NavBarView: View {
    var body: some View{
        Color("NavBarColour")
            .overlay{
            HStack{
                Spacer()
                Image(systemName: "house")
                    .padding(.trailing, 30)
                    .font(.title)
                Spacer()
                Image(systemName: "person")
                    .padding(.leading,30)
                    .font(.title)
                Spacer()
            }
        }
    }
}

#Preview {
    NavBarView()
}

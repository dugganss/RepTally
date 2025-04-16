//
//  HomeCardView.swift
//  RepTally
//
//  Created by Samuel Duggan on 09/01/2025.
//
import SwiftUI

struct HomeCardView: View{
    var title: String
    var action: () -> Void
    
    var body: some View{
        ZStack{
            Color(.cardColour)
            VStack{
                Text(title)
                    .font(.custom("Hesker",size: 23))
                    .frame(width:200)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.safeBlack)
                    .padding(.bottom)
                    .bold()
                ActionButton(title: "Go", isArrowButton: true, isBig: false, action: self.action)
            }
        }
        .frame(width: UIScreen.main.bounds.width-65, height: UIScreen.main.bounds.height-680)
        .cornerRadius(8)
        .padding(5)
        
    }
}

#Preview {
    HomeCardView(title: "View your previous sessions", action: {})
}

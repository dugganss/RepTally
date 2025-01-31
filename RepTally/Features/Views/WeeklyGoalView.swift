//
//  WeeklyGoalView.swift
//  RepTally
//
//  Created by Samuel Duggan on 19/01/2025.
//

import SwiftUI

struct WeeklyGoalView: View {
    @ObservedObject var user: User
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Text("Weekly Goal")
                    .padding(.top, 70)
                    .padding(.bottom, 10)
                    .font(.custom("Delta Block", size: 30))
                    .frame(alignment: .center)
                Spacer()
            }
            Spacer()
            Text("This is not a current feature of RepTally. It may be included in future versions, however it is more to demonstrate the potential of expandability.")
                .padding(.horizontal, 50)
            
            Spacer()
            NavBarView(user: user, isAccount: true, isHome: false)
            
            
            
            
                
            
            
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: ReturnButton())
    }
}


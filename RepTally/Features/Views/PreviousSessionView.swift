//
//  PreviousSessionView.swift
//  RepTally
//
//  Created by Samuel Duggan on 13/01/2025.
//

import SwiftUI

struct PreviousSessionView: View{
    var body: some View{
        VStack{
            HStack{
                Spacer()
                Text("Previous Sessions")
                    .padding(.top, 70)
                    .padding(.bottom, 10)
                    .font(.custom("Delta Block", size: 25))
                    .frame(alignment: .center)
                Spacer()
            }
            
            ScrollView{
                VStack{
                    //cards for previous sessions go here
                    //these cards will link to another screen that will display the data for the record chosen
                }
            }
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: ReturnButton())
    }
        
}
#Preview {
    PreviousSessionView()
}

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
    @Binding var selectedTab: Int
    @Binding var homePath: NavigationPath
    @Binding var resetBools: Bool
    
    var body: some View{
        Color("NavBarColour")
            .overlay{
                HStack{
                    Button(action: {
                        withAnimation(.none) {
                            if selectedTab == 0 {
                                resetBools = true
                            }
                            else{
                                selectedTab = 0
                            }
                        }
                    }){
                        Image(systemName: "house")
                            .padding(.leading, 50)
                            .padding(.bottom, 10)
                            .font(.title)
                            .foregroundStyle(Color("SafeBlack"))
                    }
                    
                    Spacer()
                    Button(action: {
                        withAnimation(.none) {
                            selectedTab = 1
                        }
                    }){
                        Image(systemName: "person")
                            .padding(.trailing, 50)
                            .padding(.bottom, 10)
                            .font(.title)
                            .foregroundStyle(Color("SafeBlack"))
                    }
                    
                }
            }.frame(height: 85)
    }
}

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
    @State private var isAccount:Bool
    @State private var isHome:Bool
    @State private var openHome = false
    @State private var openAccount = false
    
    init(isAccount: Bool, isHome: Bool, openHome: Bool = false, openAccount: Bool = false) {
        self.isAccount = isAccount
        self.isHome = isHome
        self.openHome = openHome
        self.openAccount = openAccount
    }
    
    var body: some View{
        NavigationStack{
            Color("NavBarColour")
                .overlay{
                    HStack{
                        Button(action: {
                            if(!isHome){
                                openHome = true
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
                            if(!isAccount){
                                openAccount = true
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
        }.navigationDestination(isPresented: $openHome){
            HomeView()
        }
        .navigationDestination(isPresented: $openAccount){
            AccountView()
        }
    }
}

#Preview {
    NavBarView(isAccount: false, isHome: false)
}

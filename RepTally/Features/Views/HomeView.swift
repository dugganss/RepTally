//
//  ContentView.swift
//  RepTally
//
//  Created by Samuel Duggan on 09/01/2025.
//

import SwiftUI
//TODO: add full styling to elements
struct HomeView: View {
    var body: some View {
        NavigationStack{
            VStack{
                HStack{
                    Button(action: {}){
                        Image(systemName: "pause")
                            .rotationEffect(.degrees(90))
                            .font(.title)
                            .foregroundStyle(Color("SafeBlack"))
                            .padding(30)
                            .padding(.top,10)
                    }
                    Spacer()
                    
                    Text("RepTally")
                        .padding(.top, 50)
                        .font(.custom("Delta Block", size: 30))
                    
                    Spacer()
                    Button(action: {}){
                        Image(systemName: "plus")
                            .font(.title)
                            .foregroundStyle(Color("SafeBlack"))
                            .padding(30)
                            .padding(.top,10)
                    }
                }
                .padding()
                
                HStack{
                    VStack(alignment: .leading){
                        Text("Hi,")
                            .font(.custom("FreeSerif", size: 30))
                        Text("Username") //TODO: needs to display actual username
                            .font(.custom("FreeSerif", size: 26))
                            .italic()
                    }.padding(.leading, 35)
                    Spacer()
                }.padding(.bottom)
                ZStack{
                    Color("BackgroundColour")
                    VStack{
                        Spacer()
                        HomeCardView(title: "View your Previous Sessions")
                           
                        Spacer()
                        HomeCardView(title: "Set a Weekly Goal")
                        
                        //adding the action button here for some reason, shifts up the nav bar?
                        Spacer()
                        //ActionButton(title: "Start a Session", isArrowButton: false, isBig: true)
                            
                            
                        
            
                        Spacer()
                        NavBarView()
                            //.frame(maxWidth: .infinity, maxHeight: 66)
                            //.ignoresSafeArea()
                            
                    }
                }
            }.ignoresSafeArea()
        }
        
    }
    
}
    


#Preview {
    HomeView()
}

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
                    .font(.title)
                
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
                        .font(.title)
                    Text("Username") //TODO: needs to display actual username
                        .font(.title)
                        .italic()
                }.padding(.leading, 35)
                Spacer()
            }.padding(.bottom)
            ZStack{
                Color("BackgroundColour")
                VStack{
                    Spacer()
                    HomeCardView(title: "View your Previous Sessions")
                        //.padding()
                    Spacer()
                    HomeCardView(title: "Set a Weekly Goal")
                        //.padding()
                    Spacer()
                    NavBarView()
                }
            }
        }.ignoresSafeArea()    
    }
    
}
    


#Preview {
    HomeView()
}

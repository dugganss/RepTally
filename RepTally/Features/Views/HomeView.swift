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
                        .foregroundStyle(.black)
                        .padding(30)
                }
                Spacer()
                
                Text("RepTally")
                    .padding(.top, 50)
                    .font(.title2)
                
                Spacer()
                Button(action: {}){
                    Image(systemName: "plus")
                        .font(.title)
                        .foregroundStyle(.black)
                        .padding(30)
                }
            }
            .padding()
            
            HStack{
                VStack(alignment: .leading){
                    Text("Hi,")
                        .font(.title)
                    Text("Username") //TODO: needs to display actual username
                        .font(.title2)
                        .italic()
                }.padding(.leading, 35)
                Spacer()
            }.padding(.bottom)
            Color("BackgroundColour")
        }
    }
}

#Preview {
    HomeView()
}

//
//  ContentView.swift
//  RepTally
//
//  Created by Samuel Duggan on 09/01/2025.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var user: User
    @ObservedObject var nav : NavigationManager
    
    var body: some View {
            VStack{
                HStack{
                    
                    Image(systemName: "pause")
                        .rotationEffect(.degrees(90))
                        .font(.title)
                        .foregroundStyle(.safeBlack)
                        .padding(30)
                        .padding(.top,10)
                    
                    Spacer()
                    
                    Text("RepTally")
                        .padding(.top, 50)
                        .font(.custom("Lobster", size: 35))
                    
                    Spacer()
                    Button(action: {
                        nav.goToCreateSession()
                    }){
                        Image(systemName: "plus")
                            .font(.title)
                            .foregroundStyle(.safeBlack)
                            .padding(30)
                            .padding(.top,10)
                    }
                }
                .padding()
                
                HStack{
                    VStack(alignment: .leading){
                        Text("Hi,")
                            .font(.custom("FreeSerif", size: 30))
                        Text("\(user.username ?? "empty")")
                            .font(.custom("FreeSerif", size: 26))
                            .italic()
                    }.padding(.leading, 35)
                    Spacer()
                }.padding(.bottom)
                
                ZStack{
                    VStack{
                        Group{
                            HomeCardView(title: "View your Previous Sessions", action: {nav.goToPreviousSessions()})
                            HomeCardView(title: "Set a Weekly Goal", action: {nav.goToWeeklyGoal()})
                            ActionButton(title: "Start a Session", isArrowButton: false, isBig: true, action: {nav.goToCreateSession();})
                        }
                        .padding(.top, 15)
                        Spacer()
                    }
                }
            }.ignoresSafeArea()
            .background(.clear)
        }
}
    


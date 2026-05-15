//
//  ContentView.swift
//  RepTally
//
//  Created by Samuel Duggan on 09/01/2025.
//

import SwiftUI

struct HomeView: View {
    @Binding var navigationPath: NavigationPath
    @Binding var showNav: Bool
    @Binding var resetBools: Bool
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var user: User
    
    //code adapted from Martins (2023)
    @State private var openCreateSessions = false
    @State private var openPreviousSessions = false
    @State private var openSideMenu = false
    @State private var openWeeklyGoal = false
    
    var body: some View {
        NavigationStack(path: $navigationPath){
        //end of adapted code
            VStack{
                HStack{
                    
                    Button(action: {openSideMenu = true}){
                        Image(systemName: "pause")
                            .rotationEffect(.degrees(90))
                            .font(.title)
                            .foregroundStyle(.safeBlack)
                            .padding(30)
                            .padding(.top,10)
                    }
                    Spacer()
                    
                    Text("RepTally")
                        .padding(.top, 50)
                        .font(.custom("Lobster", size: 35))
                    
                    Spacer()
                    Button(action: {
                        openCreateSessions = true
                        showNav = false
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
                    Color("BackgroundColour")
                    VStack{
                        Group{
                            HomeCardView(title: "View your Previous Sessions", action: {self.openPreviousSessions = true})
                            HomeCardView(title: "Set a Weekly Goal", action: {self.openWeeklyGoal = true})
                            ActionButton(title: "Start a Session", isArrowButton: false, isBig: true, action: {self.openCreateSessions = true; self.showNav = false})
                        }
                        .padding(.top, 15)
                        Spacer()
                    }
                }
            }.ignoresSafeArea()
            .navigationDestination(isPresented: $openCreateSessions){
                CreateSessionView(user: user)
                    .environment(\.managedObjectContext, viewContext)
            }
            .navigationDestination(isPresented: $openPreviousSessions){
                PreviousSessionView(user: user)
                    .environment(\.managedObjectContext, viewContext)
            }
            .navigationDestination(isPresented: $openWeeklyGoal){
                WeeklyGoalView(user: user)
            }
            .navigationBarBackButtonHidden(true)
            .onAppear{
                showNav = true
            }
            .onChange(of: resetBools){
                if resetBools {
                    resetNavigationBooleans()
                }
            }
        }
    }
    
    func resetNavigationBooleans() {
        openCreateSessions = false
        openPreviousSessions = false
        openSideMenu = false
        openWeeklyGoal = false
        resetBools = false
    }
}
    


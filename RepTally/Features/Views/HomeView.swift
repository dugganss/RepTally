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
    
    //navigation destination using booleans retrieved from https://medium.com/@fsamuelsmartins/how-to-use-the-swiftuis-navigationstack-79f32ada7c69
    @State private var openCreateSessions = false
    @State private var openPreviousSessions = false
    @State private var openSideMenu = false
    @State private var openWeeklyGoal = false
    
    var body: some View {
        NavigationStack{
            VStack{
                HStack{
                    Button(action: {openSideMenu = true}){
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
                    Button(action: {openCreateSessions = true}){
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
                        Text("\(user.username ?? "empty")")
                            .font(.custom("FreeSerif", size: 26))
                            .italic()
                    }.padding(.leading, 35)
                    Spacer()
                }.padding(.bottom)
                
                ZStack{
                    Color("BackgroundColour")
                    VStack{
                        //TODO: talk about this in your implementation section, you struggled to find a solution to get the navbar to stick to the bottom of the screen because padding and spacers werent working and are not reliable if i want the app to be responsive.
                        ///below is the original implementation but you tried some other things such as .safeareainset
                        ///and playing around with padding but adding the action button forced it up
                        ///solution is found at https://stackoverflow.com/questions/65135725/how-to-position-my-button-to-the-bottom-of-the-screen-swiftui
                        ///where they use a Group with some modifiers
//                        Spacer()
//                        HomeCardView(title: "View your Previous Sessions")
//                           
//                        Spacer()
//                        HomeCardView(title: "Set a Weekly Goal")
//                        
//                        //adding the action button here for some reason, shifts up the nav bar?
//                        Spacer()
//                        ActionButton(title: "Start a Session", isArrowButton: false, isBig: true)
//
//                        Spacer()
//                        NavBarView()
                        Spacer()
                        Group{
                            HomeCardView(title: "View your Previous Sessions", action: {self.openPreviousSessions = true})
                            HomeCardView(title: "Set a Weekly Goal", action: {self.openWeeklyGoal = true})
                            ActionButton(title: "Start a Session", isArrowButton: false, isBig: true, action: {self.openCreateSessions = true})
//                                .navigationDestination(isPresented: $openCreateSessions){
//                                    CreateSessionView()
//                                }
                            NavBarView(user: user, isAccount:false, isHome: true)
                        }
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .ignoresSafeArea()
                        .padding(.top)
                    }
                }
            }.ignoresSafeArea()
            .navigationDestination(isPresented: $openCreateSessions){
                CreateSessionView(user: user)
            }
            .navigationDestination(isPresented: $openPreviousSessions){
                PreviousSessionView(user: user)
            }
            .navigationDestination(isPresented: $openWeeklyGoal){
                WeeklyGoalView(user: user)
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}
    


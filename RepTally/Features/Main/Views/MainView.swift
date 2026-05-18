//
//  MainView.swift
//  RepTally
//
//  Created by Samuel Duggan on 09/03/2025.
//
//TODO: currently trying to figure out how to get the background onto each view rendered on top of this view with the current nav system
import SwiftUI

struct MainView: View {
    @StateObject private var nav = NavigationManager()
    @ObservedObject var user: User

    var body: some View {
        NavigationStack(path: $nav.path) {
            VStack(spacing: 0){
                ZStack {
                    MainBackgroundView()
                    
                    Group {
                        switch nav.selectedTab {
                        case .home:
                            HomeView(user: user, nav: nav)
                                .transition(.identity)
                        case .settings:
                            SettingsView(user: user)
                                .transition(.identity)
                        }
                    }
                }
                
                NavBarView(nav: nav)
                
            }
            .ignoresSafeArea()
            .navigationDestination(for: NavigationManager.Route.self) { route in

                switch route {

                case .home:
                    EmptyView()

                case .settings:
                    SettingsView(user: user)

                case .createSession:
                    ZStack{
                        MainBackgroundView()
                        CreateSessionView(user: user, nav: nav)
                    }

                case .frameCheck:
                    FrameCheckView(user: user, nav: nav)

                case .session:
                    ZStack{
                        MainBackgroundView()
                        SessionView(user: user, nav: nav)
                    }
                    

                case .previousSessions:
                    PreviousSessionView(user: user)

                case .weeklyGoal:
                    WeeklyGoalView(user: user)
                }
            }
        }
    }
}

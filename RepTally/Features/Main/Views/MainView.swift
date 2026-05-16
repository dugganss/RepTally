//
//  MainView.swift
//  RepTally
//
//  Created by Samuel Duggan on 09/03/2025.
//

import SwiftUI

struct MainView: View {
    @StateObject private var nav = NavigationManager()
    @ObservedObject var user: User
    
    //renders the currently selected view underneath the nav bar if the screen displays a nav bar, this ensures that it is persistent.
    var body: some View {
        NavigationStack(path: $nav.path) {
            //design pattern adapted from App Dev Insights
            VStack(spacing: 0){
                ZStack {
                    LinearGradient(stops: [.init(color: .purple, location: 0.2),
                                           .init(color: .black, location: 0.6)
                    ], startPoint: .top, endPoint: .bottom)
                    
                    
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
                    CreateSessionView(user: user, nav: nav)

                case .frameCheck:
                    FrameCheckView(user: user, nav: nav)

                case .session:
                    SessionView(user: user, nav: nav)

                case .previousSessions:
                    PreviousSessionView(user: user)

                case .weeklyGoal:
                    WeeklyGoalView(user: user)
                }
            }
        }
    }
}

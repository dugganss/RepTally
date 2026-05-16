//
//  MainView.swift
//  RepTally
//
//  Created by Samuel Duggan on 09/03/2025.
//

import SwiftUI

struct MainView: View {
    @State private var selectedTab: Int = 0
    @State private var homePath = NavigationPath()
    @State private var showNav = true
    @State private var resetBools = false
    
    @ObservedObject var user: User
    
    //renders the currently selected view underneath the nav bar if the screen displays a nav bar, this ensures that it is persistent.
    var body: some View {
        NavigationStack(path: $homePath) {
            //design pattern adapted from App Dev Insights
            ZStack {
                LinearGradient(stops: [.init(color: .purple, location: 0.2),
                                       .init(color: .black, location: 0.6)
                ], startPoint: .top, endPoint: .bottom)
                
                Group {
                    if selectedTab == 0 {
                        HomeView(navigationPath: $homePath, showNav: $showNav , resetBools: $resetBools, user: user)
                            .transition(.identity)
                    } else if selectedTab == 1 {
                        SettingsView(user: user)
                            .transition(.identity)
                    }
                }
                .animation(.none, value: selectedTab)
            }
            
            if showNav{
                NavBarView(selectedTab: $selectedTab, homePath: $homePath, resetBools: $resetBools)
            }
        }
        .ignoresSafeArea()
    }
}

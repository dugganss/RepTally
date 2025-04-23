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
    
    var body: some View {
        ZStack(alignment: .bottom) {
            //design pattern adapted from App Dev Insights https://medium.com/%40appdevinsights/building-a-custom-tabbar-in-swiftui-862636475151
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
            
            if showNav{
                NavBarView(selectedTab: $selectedTab, homePath: $homePath, resetBools: $resetBools)
            }
        }
        .ignoresSafeArea()
    }
}

//
//  NavigationManager.swift
//  RepTally
//
//  Created by Samuel Duggan on 16/05/2026.
//

import SwiftUI

final class NavigationManager: ObservableObject {
    @Published var path = NavigationPath()
    @Published var selectedTab: Tab = .home
    
    enum Route: Hashable {
        case home
        case settings
        case createSession
        case previousSessions
        case weeklyGoal
        case frameCheck
        case session
    }
    
    enum Tab {
        case home
        case settings
    }
    
    func goToHome() {
        selectedTab = .home
        path = NavigationPath()
    }
    
    func goToSettings() {
        selectedTab = .settings
    }
    
    func goToCreateSession() {
        path.append(Route.createSession)
    }
    
    func goToFrameCheck(){
        path.append(Route.frameCheck)
    }
    
    func goToPreviousSessions() {
        path.append(Route.previousSessions)
    }
    
    func goToSession() {
        path.append(Route.session)
    }
    
    func goToWeeklyGoal(){
        path.append(Route.weeklyGoal)
    }
}

//
//  RootView.swift
//  RepTally
//
//  Created by Samuel Duggan on 16/05/2026.
//

import SwiftUI

struct RootView: View {
    @Binding var loggedInUser: User?

    var body: some View {
        ZStack {
            if loggedInUser != nil {
                MainView(user: loggedInUser!)
            } else {
                LogInView(loggedInUser: $loggedInUser)
            }
        }
    }
        
}

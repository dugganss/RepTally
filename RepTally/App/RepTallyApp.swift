//
//  RepTallyApp.swift
//  RepTally
//
//  Created by Samuel Duggan on 09/01/2025.
//

import SwiftUI
import MijickPopupView

@main
struct RepTallyApp: App {
    let coreDataStack = CoreDataStack.shared
    
    @State private var loggedInUser: User?
    
    var body: some Scene {
        WindowGroup {
            if let user = loggedInUser {
                MainView(user: user)
                //code adapted from Apple (n.d.) (setting up a core data stack)
                    .environment(\.managedObjectContext, coreDataStack.persistentContainer.viewContext)
                    .implementPopupView()
                //end of adapted code
            }
            else{
                LogInView(loggedInUser: $loggedInUser)
                    .environment(\.managedObjectContext, coreDataStack.persistentContainer.viewContext)
                    .implementPopupView()
            }
        }
    }
}

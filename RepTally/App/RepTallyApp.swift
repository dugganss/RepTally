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
            RootView(loggedInUser: $loggedInUser)
            //code adapted from Apple (n.d.-b)
                .environment(\.managedObjectContext, coreDataStack.persistentContainer.viewContext)
                .implementPopupView()
            //end of adapted code
        }
        
    }
}

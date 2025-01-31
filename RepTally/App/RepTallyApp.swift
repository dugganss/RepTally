//
//  RepTallyApp.swift
//  RepTally
//
//  Created by Samuel Duggan on 09/01/2025.
//

import SwiftUI

@main
struct RepTallyApp: App {
    let coreDataStack = CoreDataStack.shared
    
    var body: some Scene {
        WindowGroup {
            LogInView()
            //code adapted from Apple (n.d.) (setting up a core data stack)
                .environment(\.managedObjectContext, coreDataStack.persistentContainer.viewContext)
            //end of adapted code
        }
    }
}

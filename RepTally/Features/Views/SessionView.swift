//
//  SessionView.swift
//  RepTally
//
//  Created by Samuel Duggan on 13/01/2025.
//

import SwiftUI

struct SessionView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var user: User
    @State private var isGoingHome = false
    var body: some View {
        NavigationStack{
            Text("session view")
            Button(action: {
                isGoingHome = true
            }){
                Text("Return home")
            }
            .navigationDestination(isPresented: $isGoingHome){
                HomeView(user: user)
                    .environment(\.managedObjectContext, viewContext)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

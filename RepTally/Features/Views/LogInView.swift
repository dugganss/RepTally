//
//  LogInView.swift
//  RepTally
//
//  Created by Samuel Duggan on 13/01/2025.
//

import SwiftUI
import CoreData

struct LogInView: View {
    // this defines the context for the coreDataStack (so that you can perform crud operation on persisting data)
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var loggedInUser: User?
    
    @State private var username = ""
    @State private var logInSuccess = false
    @State private var isEmpty = false
    @State private var isTooLong = false
    
    @State private var currentUser: User?
    var body: some View {
        NavigationStack{
            VStack{
                Text("Rep Tally")
                    .padding(.top, 50)
                    .font(.custom("Delta Block", size: 50))
                    .frame(width: 120)
                    .multilineTextAlignment(.center)
                Image(systemName: "dumbbell.fill")
                    .font(.custom("Delta Block", size: 90))
                Spacer()
                HStack{
                    Text("Log In")
                        .padding(.leading, 60)
                        .bold()
                    Spacer()
                }
                    
                TextField("Enter Username", text: $username)
                    .padding()
                    .border(.primary)
                    .padding(.horizontal, 50)
                
                if(isEmpty){
                    Text("Enter Username")
                        .foregroundStyle(.red)
                }
                
                if(isTooLong){
                    Text("Username too long, must be < 15 characters")
                        .foregroundStyle(.red)
                }
                
                Button(action: {
                    logIn()
                }){
                    Image(systemName: "arrow.right.circle")
                        .padding(.top,5)
                        .font(.title)
                        .foregroundStyle(.safeBlack)
                }
                Spacer()
            }
            .navigationDestination(isPresented: $logInSuccess){
                if let user = currentUser {
                    HomeView(user: user)
                }else{
                    Text("No User found")
                        .foregroundStyle(.red)
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
    
    private func logIn(){
        isEmpty = false
        isTooLong = false
        let trimmedUsername = username.trimmingCharacters(in: .whitespaces)
        guard !trimmedUsername.isEmpty else{
            isEmpty = true
            return
        }
        
        guard trimmedUsername.count < 15 else{
            isTooLong = true
            return
        }
        
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@", trimmedUsername)
        
        do {
            let results = try viewContext.fetch(fetchRequest)
            if let existingUser = results.first {
                currentUser = existingUser
            }else{
                let newUser = User(context: viewContext)
                newUser.username = trimmedUsername
                try viewContext.save()
                currentUser = newUser
            }
            if currentUser != nil{
                loggedInUser = currentUser
                logInSuccess = true
            }
        } catch{
            print("error fetching or creating user \(error.localizedDescription)")
        }
    }
}



//#Preview{
//    let coreDataStack = CoreDataStack.shared
//    let context = coreDataStack.persistentContainer.viewContext
//    return LogInView().environment(\.managedObjectContext, context)
//}

//
//  AccountView.swift
//  RepTally
//
//  Created by Samuel Duggan on 13/01/2025.
//

import SwiftUI
import CoreData

struct AccountView: View{
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var user: User
    
    //code adapted from Hudson (2022) https://www.hackingwithswift.com/quick-start/swiftui/how-to-dismiss-the-keyboard-for-a-textfield
    @FocusState private var nameIsFocused: Bool
    //end of adapted code
    @State private var alreadyExists = false
    @State private var successfulChange = false
    
    @State private var username: String = ""
    var body: some View{
        VStack{
            HStack{
                Spacer()
                Text("Account")
                    .padding(.top, 70)
                    .padding(.bottom, 10)
                    .font(.custom("Delta Block", size: 30))
                    .frame(alignment: .center)
                Spacer()
            }
            VStack{
                HStack{
                    Text("Change Username")
                        .font(.custom("Delta Block", size: 22))
                        .padding(.top, 15)
                    Spacer()
                }
                TextField(user.username ?? "No Name Found", text: $username)
                    .focused($nameIsFocused)
                    .padding()
                    .border(.primary)
                    .padding(.trailing, 50)
            }
            .padding(.leading, 50)
            Button(action: {
                nameIsFocused = false
                changeUsername()
            }){
                Image(systemName: "arrow.right.circle")
                    .padding(.top,5)
                    .font(.title)
                    .foregroundStyle(.safeBlack)
            }
            
            if(successfulChange){
                Text("Username was successfully changed")
                    .foregroundStyle(.green)
                    .padding(.top)
            }
            else if(alreadyExists){
                Text("Username already exists")
                    .foregroundStyle(.red)
                    .padding(.top)
            }
            
            Spacer()
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: ReturnButton())
    }
    
    func changeUsername(){
        alreadyExists = false
        successfulChange = false
        let trimmedUsername = username.trimmingCharacters(in: .whitespaces)
        guard !trimmedUsername.isEmpty else{
            return
        }
        
        guard trimmedUsername.count < 15 else{
            return
        }
        
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@", trimmedUsername)
        
        do {
            let results = try viewContext.fetch(fetchRequest)
            if results.first != nil {
                alreadyExists = true
                return
            }else{
                successfulChange = true
                user.username = username
            }
            
        }catch{
            print("error fetching or editing user \(error.localizedDescription)")
        }
        if viewContext.hasChanges && successfulChange {
            do{
                try viewContext.save()
            } catch {
                print("failed to save context \(error.localizedDescription)")
            }
        }
    }
}


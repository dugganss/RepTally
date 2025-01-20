//
//  LogInView.swift
//  RepTally
//
//  Created by Samuel Duggan on 13/01/2025.
//

import SwiftUI

struct LogInView: View {
    @State private var username = ""
    @State private var logInSuccess = false
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
                    .onSubmit {
                        //code to save username to device here, or check if already exists
                    }
                    .padding()
                    .border(.primary)
                    .padding(.horizontal, 50)
                
                Button(action: {
                    //if valid allow button to be pressed to open app. Should use the data associated with the user.
                    logInSuccess = true
                }){
                    Image(systemName: "arrow.right.circle")
                        .padding(.top,5)
                        .font(.title)
                        .foregroundStyle(.safeBlack)
                }
                Spacer()
            }
            .navigationDestination(isPresented: $logInSuccess){
                HomeView()
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview{
    LogInView()
}

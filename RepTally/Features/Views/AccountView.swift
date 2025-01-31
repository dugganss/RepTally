//
//  AccountView.swift
//  RepTally
//
//  Created by Samuel Duggan on 13/01/2025.
//

import SwiftUI

struct AccountView: View{
    @ObservedObject var user: User
    
    @State private var username: String = "Username"
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
                    Text("Username")
                        .font(.custom("Delta Block", size: 22))
                        .padding(.top, 15)
                    Spacer()
                }
                TextField(username, text: $username)
                    .onSubmit {
                        //code to save username to device here
                    }
                    .padding()
                    .border(.primary)
                    .padding(.trailing, 50)
            }
            .padding(.leading, 50)
            Spacer()
            NavBarView(user: user, isAccount: true, isHome: false)
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: ReturnButton())
    }
}


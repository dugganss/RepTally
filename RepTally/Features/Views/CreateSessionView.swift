//
//  CreateSessionView.swift
//  RepTally
//
//  Created by Samuel Duggan on 13/01/2025.
//

import SwiftUI

//TODO: this currently uses sett for values, you have now created a class for it that is persisted on the device
// you need to make this page work with it! figure it out lol.. not sure how youre going to connect the sessions
// to specific users but youll figure it out.

struct CreateSessionView:View{
    @ObservedObject var user: User
    
    @State private var sets: [sett] = [sett(id: 1)]
    
    var body: some View{
        VStack{
            HStack{
                Spacer()
                Text("New Session")
                    .padding(.top, 70)
                    .padding(.bottom, 10)
                    .font(.custom("Delta Block", size: 30))
                    .frame(alignment: .center)
                Spacer()
            }
            
            ScrollView{
                VStack{
                    ForEach(sets){ set in
                        NewSessionCard(set: Binding(
                            get: {
                                self.sets.first(where: {$0.id == set.id})!
                            },
                            set: { updatedSet in
                                if let index = self.sets.firstIndex(where: {$0.id == updatedSet.id}){
                                    self.sets[index] = updatedSet
                                }
                            }), delete: {
                                if let index = self.sets.firstIndex(where: {$0.id == set.id}){
                                    if(index>0){
                                        self.sets.remove(at: index)
                                        if(sets.count > 0){
                                            for i in 0...sets.count-1{
                                                sets[i].id = i+1
                                            }
                                        }
                                    }
                                    
                                    
                                }
                            })
                        .padding(.horizontal, 5)
                    }
                }
                
                //add new set button
                Button(action: {
                    //if(sets.count > 0){
                    sets.append(sett(id: sets.count+1))
                    //}else{
                    //    sets.append(Set(id: 1))
                    //}
                }) {
                    HStack {
                        Image(systemName: "plus.circle")
                        Text("Add New Set")
                    }
                }
                .font(.headline)
                .foregroundStyle(.safeBlack)
                .padding(.top, 5)
            }
            .padding(.bottom, 15)
            Spacer()
            
            ActionButton(title: "Start Session", isArrowButton: false, isBig: true, action: {})
                .padding(.bottom, 10)
                
            Spacer()
            NavBarView(user: user, isAccount: false, isHome: false)
        }.ignoresSafeArea()
        //code adapted from Ashish (2019)https://stackoverflow.com/questions/56571349/custom-back-button-for-navigationviews-navigation-bar-in-swiftui
        
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: ReturnButton())
        //end of adapted code
    }
}


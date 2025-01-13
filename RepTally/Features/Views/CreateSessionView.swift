//
//  CreateSessionView.swift
//  RepTally
//
//  Created by Samuel Duggan on 13/01/2025.
//

import SwiftUI

struct CreateSessionView:View{
    @State private var sets: [Set] = [Set(id: 1)]
    
    var body: some View{
        VStack{
            HStack{
                ReturnButton()
                
                Spacer()
                
                Text("New Session")
                    .padding(.top, 50)
                    .padding(.leading, -50)
                    .font(.custom("Delta Block", size: 30))
                    .frame(alignment: .center)
                Spacer()
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
                    sets.append(Set(id: sets.count+1))
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
            
            ActionButton(title: "Start Session", isArrowButton: false, isBig: true)
                .padding(.bottom, 10)
                
            Spacer()
            NavBarView()
        }.ignoresSafeArea()
    }
}
#Preview {
    CreateSessionView()
}

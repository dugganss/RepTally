//
//  CreateSessionView.swift
//  RepTally
//
//  Created by Samuel Duggan on 13/01/2025.
//

import SwiftUI



struct CreateSessionView:View{
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var user: User
    
    @State private var sets: [IntermediateSet] = [IntermediateSet(id: 1)]
    @State private var incorrectDataEntry = false
    
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
                                    if(self.sets.count > 1){
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
                    sets.append(IntermediateSet(id: sets.count+1))
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
            if incorrectDataEntry{
                Text("Ensure all Sets have a Workout and Reps")
                    .foregroundStyle(.red)
            }
            ActionButton(title: "Start Session", isArrowButton: false, isBig: true, action: {
                createSession()
                //outputs sessions and sets to console
//                if let sessions = user.sessions as? Set<Session> {
//                    for session in sessions {
//                        print("Session id: \(session.sessionID)")
//                        // session.sets is also an NSSet or Swift Set<SetData>
//                        if let sets = session.sets as? Set<SetData> {
//                            for setData in sets {
//                                print("Workout: \(setData.workout ?? "N/A"), Reps: \(setData.reps)")
//                            }
//                        }
//                    }
//                    }
            })
                .padding(.bottom, 10)
                
            Spacer()
            NavBarView(user: user, isAccount: false, isHome: false)
        }.ignoresSafeArea()
        //code adapted from Ashish (2019)https://stackoverflow.com/questions/56571349/custom-back-button-for-navigationviews-navigation-bar-in-swiftui
        
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: ReturnButton())
        //end of adapted code
    }
    
    func createSession(){
        /*
         This method creates a Session to be persisted on the device and creates a new SetData
         for each IntermediateSet that was created using the UI.
         It provides validation by ensuring each set has a defined workout and rep count before
         allowing any changes to be saved to the device.
         */
        incorrectDataEntry = false
        let newSession = Session(context: viewContext)
        newSession.sessionID = UUID()
        newSession.user = user
        for setx in sets{
            let newSet = SetData(context: viewContext)
            if (!setx.workout.isEmpty && setx.reps != 0) {
                newSet.workout = setx.workout
                newSet.reps = Int32(setx.reps)
            }else{
                incorrectDataEntry = true
                viewContext.delete(newSession)
                return
            }
            newSet.num = Int32(setx.id)
            newSet.repeats = Int32(setx.repeats)
            newSet.session = newSession
        }
        if viewContext.hasChanges && !incorrectDataEntry {
            do{
                try viewContext.save()
            } catch {
                print("failed to save context \(error.localizedDescription)")
            }
        }
    }
}


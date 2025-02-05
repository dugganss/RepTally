//
//  SessionView.swift
//  RepTally
//
//  Created by Samuel Duggan on 13/01/2025.
//

import SwiftUI
import CoreData

struct SessionView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var user: User
    @StateObject var cameraInfoModel = CameraInfoModel()
    @State private var isGoingHome = false //flag to return home (temporary)
    @State private var sets: [SetData] = [] //workout related data for current session
    @State private var setIndex = 0 //index in sets (current workout)
    @State private var currentRep = 0 //counter of completed reps for current set
    var body: some View {
        NavigationStack{
            if !sets.isEmpty{ 
                VStack{
                    Text("Set \(sets[setIndex].num)")
                        .font(.title)
                    Spacer().frame(height: 20)
                    Text(sets[setIndex].workout!)
                        .font(.custom("Wesker", size: 40))
                        .bold()
                    HStack{
                        Spacer()
                        CameraView(cameraInfoModel: cameraInfoModel)
                            .frame(width: 60, height: 90)
                            .padding(.trailing, 60)
                    }
                    Spacer().frame(height: 30)
                    Text("Rep")
                        .font(.custom("Wesker", size: 35))
                    Spacer().frame(height: 30)
                    Text("\(currentRep)")
                        .font(.custom("Wesker", size: 110))
                        .padding(.leading,-80)
                    Text("/")
                        .font(.custom("Wesker", size: 60))
                        .padding(.top,-90)
                        .padding(.leading, 30)
                    Text("\(sets[setIndex].reps)")
                        .font(.custom("Wesker", size: 50))
                        .padding(.leading, 105)
                        .padding(.top, -90)
                    Spacer()
                    Button(action: {
                        isGoingHome = true
                    }){
                        Text("End Session")
                            .font(.title)
                    }
                    Spacer()
                }
                .navigationDestination(isPresented: $isGoingHome){
                    HomeView(user: user)
                        .environment(\.managedObjectContext, viewContext)
                }
            }else{
                Text("Loading info")
            }
                
        }
        .navigationBarBackButtonHidden(true)
        .onAppear{
            getSetInfoFromMostRecentSession()
            cameraInfoModel.isDisplayCameraFeed = false //causes camera to not be displayed in the cameraView
            for i in 1...3 { // temporary for preview to work
                let set = SetData(context: viewContext)
                set.num = Int32(i)
                set.workout = "Workout \(i)"
                set.reps = Int32(10 + i)
                set.repeats = Int32(2)
                sets.append(set)
            }
        }
    }
    
    func getSetInfoFromMostRecentSession(){
        //code adapted from Hudson (n.d.) https://www.hackingwithswift.com/read/38/5/loading-core-data-objects-using-nsfetchrequest-and-nssortdescriptor
        //create request
        let request = Session.fetchRequest()
        
        //define request
        request.predicate = NSPredicate(format: "user == %@", user) //only give results for current user
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)] //sort by most recent
        request.fetchLimit = 1 //retrieve only 1 result
        
        //safely perform request
        var mostRecentSession: Session?
        do {
            let sessions = try viewContext.fetch(request)
            mostRecentSession = sessions.first ?? nil  //return the most recent session
        } catch {
            print("Error fetching most recent session: \(error)")
            return
        }
        //end of adatped code
        //retrieve sets from session
        if mostRecentSession != nil{
            /*
             mostRecentSession.sets is an NSSet (unordered). The implementation requires
             indexing as well as an order, therefore this code casts the NSSet to a set
             then sorts it by the SetData.num property. By calling sorted(), it automatically
             casts the collection to an Array.
             */
            sets = ((mostRecentSession?.sets as? Set<SetData>) ?? [])
                .sorted { $0.num < $1.num }
        }else{
            print("No sessions were returned from request")
        }
    }
}


#Preview {
    let coreDataStack = CoreDataStack.shared
    let context = coreDataStack.persistentContainer.viewContext
    // Create a mock user
    let mockUser = User(context: context)
    
    SessionView(user: mockUser)
        .environment(\.managedObjectContext, context)
}

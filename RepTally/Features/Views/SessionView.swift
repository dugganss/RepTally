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
    @StateObject var cameraManagerModel = CameraManagerModel()
    @State private var isGoingHome = false //flag to return home (temporary)
    @State private var sets: [SetData] = [] //workout related data for current session
    @State private var setIndex = 0 //index in sets (current workout)
    @State private var currentRep = 0 //counter of completed reps for current set
    @State private var noRepeats = 0 //number of repeats of current set
    @State private var subset = 0 //current subset
    @StateObject var popUpDetector = PopUpDetectionModel()
    @State var popupCounter: Int = 0
    var setComplete: Bool {
        guard !sets.isEmpty else { return false }
        return currentRep >= sets[setIndex].reps
    }
    var body: some View {
        NavigationStack{
            if !sets.isEmpty{
                ZStack{
                    VStack{
                        Spacer().frame(height: 90)
                        HStack{
                            Spacer()
                            CameraView(cameraManagerModel: cameraManagerModel, poseEstimator: ModelSwitcher.shared.currentModel)
                                .frame(width: 100, height: 150)
                                .padding(.trailing, 30)
                        }
                        Spacer()
                    }
                    
                    VStack{
                        Text("Set \(sets[setIndex].num).\(subset)")
                            .font(.title)
                        Spacer().frame(height: 20)
                        Text(sets[setIndex].workout!)
                            .font(.custom("Wesker", size: 40))
                            .bold()
                        
                        Circle()
                            .strokeBorder(lineWidth: 24)
                            .overlay {
                                VStack{
                                    Text("Rep")
                                        .font(.custom("Wesker", size: 35))
                                    Spacer().frame(height:25)
                                    HStack{
                                        Text("\(currentRep)")
                                            .font(.custom("Wesker", size: 110))
                                        Text("/")
                                            .font(.custom("Wesker", size: 60))
                                            .padding(.top,30)
                                        Text("\(sets[setIndex].reps)")
                                            .font(.custom("Wesker", size: 50))
                                            .padding(.top, 30)
                                    }
                                    Spacer().frame(height: 5)
                                }
                                
                            }
                            .overlay{
                                if currentRep > 0{
                                    ForEach((0...currentRep-1), id: \.self) {i in
                                        ProgressBar(rep: i, totalReps: Int(sets[setIndex].reps))
                                            .rotation(Angle(degrees: -90))
                                            .stroke(.backgroundColour, lineWidth: 15)
                                    }
                                }
                                
                                
                            }
                            .padding(.horizontal)
                        
                        ActionButton(title: "Finish Set", isArrowButton: false, isBig: true, action: {
                            if !setComplete{
                                currentRep += 1
                                if currentRep == sets[setIndex].reps {
                                    if noRepeats > 0{
                                        currentRep = 0
                                        noRepeats -= 1
                                        subset += 1
                                    }
                                    else if setIndex < sets.count - 1 {
                                        currentRep = 0
                                        setIndex += 1
                                        noRepeats = Int(sets[setIndex].repeats)
                                        subset = 0
                                    }
                                }
                            }
                        })
                        
                        Spacer()
                        Button(action: {
                            isGoingHome = true
                        })
                        {
                            Text("End Session")
                                .font(.title3)
                                .foregroundStyle(.red)
                        }
                        .padding(.vertical, 15)
                        Spacer()
                    }
                    
                    if (setComplete && popupCounter < 1){
                        ConfigurableCentrePopup(popUpDetector: popUpDetector, title: "Session is Complete!", buttonText: "Return Home",line2: "Good Effort!", dismissable: false, eventFlagBoolean: $isGoingHome).showAndStack()
                    }
                }
                .navigationDestination(isPresented: $isGoingHome){
                    MainView(user: user)
                        .environment(\.managedObjectContext, viewContext)
                }
            }else{
                Text("Loading info")
            }
                
        }
        .navigationBarBackButtonHidden(true)
        .onAppear{
            sets = DataFetcher(user: user, viewContext: viewContext).getSetsFromMostRecentSession()
            cameraManagerModel.isDisplayCameraFeed = false //causes camera to not be displayed in the cameraView
            if !sets.isEmpty{
                noRepeats = Int(sets[setIndex].repeats)
            }
//            for i in 1...3 { // temporary for preview to work
//                let set = SetData(context: viewContext)
//                set.num = Int32(i)
//                set.workout = "Workout \(i)"
//                set.reps = Int32(10 + i)
//                set.repeats = Int32(2)
//                sets.append(set)
//            }
        }
        .onChange(of: setComplete){
            popupCounter += 1
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

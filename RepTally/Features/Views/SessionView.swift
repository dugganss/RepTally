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
    @StateObject var popUpDetector = PopUpDetectionModel()
    @State var popupCounter: Int = 0
    @State private var isPaused = false
    @State private var countDown = 3
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationStack{
            if !SetTracker.shared.sets.isEmpty{
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
                        //SetTracker holds the information for sets and has an API to perform the relevant functions, this displays the current set being performed
                        Text("Set \(SetTracker.shared.currentSet()!.num).\(SetTracker.shared.subset)")
                            .font(.title)
                        Spacer().frame(height: 20)
                        Text(SetTracker.shared.currentSet()!.workout!)
                            .font(.custom("Wesker", size: 40))
                            .bold()
                        
                        //Circular progress bar.
                        Circle()
                            .strokeBorder(lineWidth: 24)
                            .overlay {
                                //Centered numerical rep count
                                VStack{
                                    Text("Rep")
                                        .font(.custom("Wesker", size: 35))
                                    Spacer().frame(height:25)
                                    HStack{
                                        Text("\(SetTracker.shared.currentRep)")
                                            .font(.custom("Wesker", size: 110))
                                        Text("/")
                                            .font(.custom("Wesker", size: 60))
                                            .padding(.top,30)
                                        Text("\(SetTracker.shared.currentSet()!.reps)")
                                            .font(.custom("Wesker", size: 50))
                                            .padding(.top, 30)
                                    }
                                    Spacer().frame(height: 5)
                                }
                                
                            }
                            .overlay{
                                if SetTracker.shared.currentRep > 0{
                                    ForEach((0...SetTracker.shared.currentRep-1), id: \.self) {i in
                                        ProgressBar(rep: i, totalReps: Int(SetTracker.shared.currentSet()!.reps))
                                            .rotation(Angle(degrees: -90))
                                            .stroke(.backgroundColour, lineWidth: 15)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        
                        //Skips the current set, disabled at the last set (pausing automatically moves to the next set)
                        ActionButton(title: "Finish Set", isArrowButton: false, isBig: true, action: {
                            isPaused = true
                            countDown = 4
                        })
                        .disabled(SetTracker.shared.lastSet())
                        .opacity(SetTracker.shared.lastSet() ? 0.5 : 1.0)
                        
                        Spacer()
                        //Returns the user to the home screen.
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
                    
                    //Show pop up when session has ended that only allows the user to return to the home screen. uses counter to ensure the pop up is only shown once
                    if (SetTracker.shared.workoutComplete() && popupCounter < 1){
                        ConfigurableCentrePopup(popUpDetector: popUpDetector, title: "Session is Complete!", buttonText: "Return Home",line2: "Good Effort!", dismissable: false, eventFlagBoolean: $isGoingHome).showAndStack()
                    }
                    
                    //Pausing overlay
                    if isPaused {
                        Color.black.opacity(0.7)
                            .ignoresSafeArea()

                        VStack() {
                            //Display instructions and next workout until user touches the screen.
                            //Display 3 second countdown, then go and then start the next set.
                            if countDown == 4 {
                                Text("Set Break")
                                    .foregroundColor(.white)
                                    .font(.custom("Wesker", size: 40))
                                    .bold()
                                Spacer().frame(height: 50)
                                Text("Tap anywhere to continue your workout")
                                    .multilineTextAlignment(.center)
                                    .font(.custom("Wesker", size: 25))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 15)
                                Spacer().frame(height: 70)
                                Text("Next workout: \(SetTracker.shared.nextWorkout() ?? "None")")
                                    .foregroundColor(.white)
                                    .font(.title)
                                    .padding(.horizontal, 15)
                            } else if countDown > 0 {
                                Text("\(countDown)")
                                    .font(.system(size: 100, weight: .bold))
                                    .foregroundColor(.white)
                            } else {
                                Text("Go!")
                                    .font(.system(size: 60, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .contentShape(Rectangle()) //make tap box stretch for the entire screen
                        .onTapGesture {
                            if countDown == 4 { // start countdown
                                countDown = 3
                            }
                        }
                        .onReceive(timer) { _ in //decrement countdown every second when activated
                            guard isPaused else { return }
                            if countDown > 0 && countDown < 4 {
                                countDown -= 1
                            } else if countDown == 0 { //start next set at end of timer.
                                isPaused = false
                                SetTracker.shared.isPaused = isPaused
                                SetTracker.shared.moveToNextSet()
                            }
                        }
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
            SetTracker.shared.updateSetData(from: user, viewContext: viewContext)   //get the most recently created set for the current user.
            cameraManagerModel.isDisplayCameraFeed = false  //remove camera feed display (only showing skeleton)
        }
        .onChange(of: SetTracker.shared.workoutComplete()){ //show popup when the session ends
            popupCounter += 1
        }
        .onChange(of: SetTracker.shared.setComplete()){ complete in //pause, when a set completes so that the next set can start
            if complete {
                isPaused = true
                countDown = 4
                SetTracker.shared.isPaused = isPaused
            }
        }
        .onDisappear{   //clears the settracker when the view closes (it is a singleton so needs to be emptied after sessions)
            SetTracker.shared.hardReset()
        }
    }
}


//
//  FrameCheckView.swift
//  RepTally
//
//  Created by Samuel Duggan on 03/02/2025.
//

import SwiftUI

struct FrameCheckView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var user: User
    @StateObject var cameraInfoModel = CameraManagerModel() //Observable object to track whether someone's been detected on camera
    @StateObject var popUpDetector = PopUpDetectionModel()
    @State private var timeDetected = 5 //Amount of time someone needs to be detected on camera
    @State private var validDetection = false //flag for when timeDetected reaches 0
    var colors = [Color.red, Color.green] //colours for border
    //code adapted from Hudson (2023)
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect() //timer that updates every second
    //end of adapted code
    
    var body: some View{
        NavigationStack{
            CameraView(cameraManagerModel: cameraInfoModel, poseEstimator: ModelSwitcher.shared.currentModel)
                .clipShape(RoundedRectangle(cornerRadius: 55, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 55, style: .continuous)
                        .stroke(colors[cameraInfoModel.isBodyDetected ? 1 : 0], lineWidth: 20) //varying colour of border
                )
            //code adapted from Hudson (2023)
                .onReceive(timer){ _ in //runs code below after a whole second has passed
            //end of adapted code
                    if cameraInfoModel.isBodyDetected && !popUpDetector.isPopUpShowing{ //only decrements timer when someone in frame
                        timeDetected -= 1
                    }else{  //otherwise resets timer
                        timeDetected = 5
                    }
                    if timeDetected <= 0 {
                        validDetection = true
                    }
                }
                .ignoresSafeArea()
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: ReturnButton())
                .onAppear{ //pop up shows at when view is open
                    cameraInfoModel.isDisplaySkeleton = false
                    ConfigurableCentrePopup(popUpDetector: popUpDetector, title: "Lets see where you are...", buttonText: "Understood", line1: "- Put your phone at a distance where your whole body is visible in the frame", line2: "- Center yourself within the frame and try to ensure that your body parts are visible (e.g. no objects obstructing view)", line3: "- The session will automatically start when you have been detected for a short period of time", dismissable: true).showAndStack()
                }
        }
        .navigationDestination(isPresented: $validDetection){
            SessionView(user: user)
                .environment(\.managedObjectContext, viewContext)

        }
    }
}

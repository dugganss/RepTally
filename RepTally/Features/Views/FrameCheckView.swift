//
//  FrameCheckView.swift
//  RepTally
//
//  Created by Samuel Duggan on 03/02/2025.
//

import SwiftUI

//TODO: also could find a way that displays a loadins symbol or something that displays while the pose estimation is loading

struct FrameCheckView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var user: User
    @StateObject var cameraInfoModel = CameraInfoModel() //Observable object to track whether someone's been detected on camera
    @StateObject var popUpDetector = PopUpDetectionModel()
    @State private var timeDetected = 2 //Amount of time someone needs to be detected on camera
    @State private var validDetection = false //flag for when timeDetected reaches 0
    var colors = [Color.red, Color.green] //colours for border
    //code adapted from Hudson (2023) https://www.hackingwithswift.com/quick-start/swiftui/how-to-use-a-timer-with-swiftui
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect() //timer that updates every second
    //end of adapted code
    
    var body: some View{
        NavigationStack{
            CameraView(cameraInfoModel: cameraInfoModel)
                .clipShape(RoundedRectangle(cornerRadius: 55, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 55, style: .continuous)
                        .stroke(colors[cameraInfoModel.isBodyDetected ? 1 : 0], lineWidth: 20) //varying colour of border
                )
            //code adapted from Hudson (2023) ^
                .onReceive(timer){ _ in //runs code below after a whole second has passed
            //end of adapted code
                    if cameraInfoModel.isBodyDetected && !popUpDetector.isPopUpShowing{ //only decrements timer when someone in frame
                        timeDetected -= 1
                    }else{  //otherwise resets timer
                        timeDetected = 2
                    }
                    if timeDetected <= 0 {
                        validDetection = true
                    }
                }
                .ignoresSafeArea()
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: ReturnButton())
                .onAppear{ //pop up shows at when view is openec
                    FrameCheckCentrePopup(popUpDetector: popUpDetector).showAndStack()
                }
        }
        .navigationDestination(isPresented: $validDetection){
            SessionView(user: user)
                .environment(\.managedObjectContext, viewContext)

        }
    }
}

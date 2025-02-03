//
//  FrameCheckView.swift
//  RepTally
//
//  Created by Samuel Duggan on 03/02/2025.
//

import SwiftUI

//TODO: setup a timer that moves onto the next page when cameraInfoModel.isBodyDetected = true for a few seconds
//TODO: also could find a way that displays a loadins symbol or something that displays while the pose estimation is loading

struct FrameCheckView: View {
    @StateObject var cameraInfoModel = CameraInfoModel()
    var colors = [Color.red, Color.green]
    var body: some View{
        
        CameraView(cameraInfoModel: cameraInfoModel)
            .clipShape(RoundedRectangle(cornerRadius: 55, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 55, style: .continuous)
                    .stroke(colors[determineColor()], lineWidth: 20)
            )
            .ignoresSafeArea()
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: ReturnButton())
            
    }
    func determineColor() -> Int{
        if cameraInfoModel.isBodyDetected{
            return 1
        }else{
            return 0
        }
    }
    
}

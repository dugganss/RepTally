//
//  CentreCustomPopup.swift
//  RepTally
//
//  Created by Samuel Duggan on 04/02/2025.
//

import MijickPopupView
import SwiftUI

//code adapted from Mijick (2024) https://medium.com/@mijick/present-popups-from-anywhere-with-swiftui-9cd57e98e945#:~:text=Presenting%20popups%20(a.k.a.%20sheets,in%20the%20view)%20and%20voila.
/*
 This module represents the pop up that shows when opening the FrameCheckView
 it implements CentrePopup which is a protocol derived from the MijickPopupView library
 (essentially makes it easier to create and use custom pop ups)
 */

struct FrameCheckCentrePopup: CentrePopup{
    var popUpDetector : PopUpDetectionModel
    func createContent() -> some View { //essentially the body property of a typical view
        VStack{
            Text("Lets see where you are...")
                .font(.system(size: 23, weight: .bold))
                .foregroundStyle(.safeBlack)
                .multilineTextAlignment(.center)
            Spacer().frame(height: max(12, 0))
            Text("- Put your phone at a distance where your whole body is visible in the frame")
                        .font(.system(size: 16))
                        .foregroundColor(.safeBlack)
                        .multilineTextAlignment(.center)
            Spacer().frame(height: max(8, 0))
            Text("- Center yourself within the frame and try to ensure that your body parts are visible (e.g. no objects obstructing view)")
                        .font(.system(size: 16))
                        .foregroundColor(.safeBlack)
                        .multilineTextAlignment(.center)
            Spacer().frame(height: max(8, 0))
            Text("- The session will automatically start when you have been detected for a short period of time")
                        .font(.system(size: 16))
                        .foregroundColor(.safeBlack)
                        .multilineTextAlignment(.center)
            Spacer().frame(height: max(25, 0))
            Button(action: {
                dismiss()
                popUpDetector.isPopUpShowing = false}){
                Text("Understood")
                    .foregroundStyle(.white)
                    .padding()
                    .font(.title3)
                    .bold()
            }
            .frame(width: 160, height: 50)
            .background(Color("ButtonColour"))
            .cornerRadius(5)
            
            }
            .padding(.top, 12)
            .padding(.bottom, 24)
            .padding(.horizontal, 24)
        }
        
    func configurePopup(popup: CentrePopupConfig) -> CentrePopupConfig {
        popup
            .backgroundColour(.safeWhite)
            .horizontalPadding(28)
            .tapOutsideToDismiss(true)
    }
}
//end of adapted code


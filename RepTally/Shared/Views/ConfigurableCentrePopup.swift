//
//  ConfigurableCentrePopup.swift
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

struct ConfigurableCentrePopup: CentrePopup{
    let title: String
    let line1: String
    let line2: String
    let line3: String
    let buttonText: String
    let dismissable: Bool
    
    
    @Binding var eventFlagBoolean: Bool
    
    init(popUpDetector: PopUpDetectionModel, title: String, buttonText: String, line1: String = "", line2: String = "", line3: String = "", dismissable: Bool = true, eventFlagBoolean: Binding<Bool> = .constant(false)) {
        self.title = title
        self.line1 = line1
        self.line2 = line2
        self.line3 = line3
        self.dismissable = dismissable
        self.buttonText = buttonText
        self.popUpDetector = popUpDetector
        
        self._eventFlagBoolean = eventFlagBoolean
    }
    
    var popUpDetector : PopUpDetectionModel
    func createContent() -> some View { //essentially the body property of a typical view
        VStack{
            Text(title)
                .font(.system(size: 23, weight: .bold))
                .foregroundStyle(.safeBlack)
                .multilineTextAlignment(.center)
            Spacer().frame(height: max(12, 0))
            Text(line1)

                        .font(.system(size: 16))
                        .foregroundColor(.safeBlack)
                        .multilineTextAlignment(.center)
            Spacer().frame(height: max(8, 0))
            Text(line2)

                        .font(.system(size: 16))
                        .foregroundColor(.safeBlack)
                        .multilineTextAlignment(.center)
            Spacer().frame(height: max(8, 0))
            Text(line3)

                        .font(.system(size: 16))
                        .foregroundColor(.safeBlack)
                        .multilineTextAlignment(.center)
            Spacer().frame(height: max(25, 0))
            Button(action: {
                if !dismissable{
                    eventFlagBoolean = !eventFlagBoolean
                }
                dismiss()
                popUpDetector.isPopUpShowing = false}){
                    Text(buttonText)
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
    }
}
//end of adapted code


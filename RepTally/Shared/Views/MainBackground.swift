//
//  MainBackground.swift
//  RepTally
//
//  Created by Samuel Duggan on 18/05/2026.
//

import SwiftUI

struct MainBackgroundView: View {
    var body: some View {
        LinearGradient(stops: [.init(color: .backgroundBright, location: 0.0),
                               .init(color: .backgroundMid, location: 0.26),
                               .init(color: .paleBlack, location: 0.72)
        ], startPoint: .top, endPoint: .bottom)
        .ignoresSafeArea()
        
        RadialGradient(stops: [.init(color: .accent, location: 0.12),
                               .init(color: .accentSecondary, location: 0.29),
                               .init(color: .clear, location: 1)
        ],center: .center, startRadius: 20, endRadius: 190)
        .offset(y: -200)
        .opacity(0.25)
        .ignoresSafeArea()
    }
}

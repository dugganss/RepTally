//
//  PreviousSessionView.swift
//  RepTally
//
//  Created by Samuel Duggan on 13/01/2025.
//

import SwiftUI

struct PreviousSessionView: View{
    @ObservedObject var user: User
    @Environment(\.managedObjectContext) private var viewContext
    @State var sessions: [Session] = []
    let dateFormatter = DateFormatter()
    var body: some View{
        
        VStack{
            HStack{
                Spacer()
                Text("Previous Sessions")
                    .padding(.top, 70)
                    .padding(.bottom, 10)
                    .font(.custom("Delta Block", size: 25))
                    .frame(alignment: .center)
                Spacer()
            }
            
            ScrollView{
                VStack{
                    //getting bug that doesnt show dates when you click on account then go home then back (still shows the entries just not the date...???
                    ForEach(sessions, id: \.self) { session in
                        Button(action: {
                            print("pressed")
                        }){
                            VStack{
                                Divider().frame(width:300,height: 15)
                                    .bold()
                                HStack{
                                    Text("\(dateFormatter.string(from: session.timestamp!))")
                                    
                                    Spacer().frame(width: 40)
                                    Image(systemName: "arrow.right")
                                        .font(.title2)
                                        .bold()
                                }
                                .foregroundStyle(.safeBlack)
                            }
                        }
                        
                    }
                    
                    
                    //cards for previous sessions go here
                    //these cards will link to another screen that will display the data for the record chosen
                }
            }
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: ReturnButton())
        .onAppear{
            sessions = DataFetcher(user: user, viewContext: viewContext).getSessions()
            dateFormatter.timeStyle = DateFormatter.Style.medium
            dateFormatter.dateStyle = DateFormatter.Style.medium

        }
    }
}


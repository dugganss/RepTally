//
//  NewSessionCard.swift
//  RepTally
//
//  Created by Samuel Duggan on 13/01/2025.
//
import SwiftUI

///This view is used every time a user adds a new set in the create session screen
///It allows Set objects to be created through the UI
struct NewSessionCard: View{
    @Binding var set: IntermediateSet
    var delete: () -> Void
    
    var body: some View{
        VStack{
            Text("Set \(set.id)")
                .padding(.top)
                .font(.custom("Wesker", size: 20))
                .foregroundStyle(.white)
            
            //Allows to set the workout for the set
            Menu{
                ForEach(Exercise.allCases, id: \.self) { exercise in
                    Button(exercise.description) {set.workout = exercise.description}
                }
            } label: {
                //Shows default text if not chosen an option
                Text(set.workout.isEmpty ? "Select A Workout" : set.workout)
                    .padding()
                    .foregroundStyle(.safeBlack)
                    .font(.custom("Wesker", size: 15))
                Spacer()
                Image(systemName: "chevron.down")
                    .foregroundStyle(.safeBlack)
                    .padding(.trailing, 40)
            }
                .frame(maxWidth: 300, alignment: .leading)
                .padding(.leading, 32)
                .background(.navBarColour)
                .cornerRadius(5)
            
            HStack(){
                
                VStack{
                    Text("No. Reps")
                        .font(.subheadline)
                        .foregroundStyle(.white)
                        .padding(.leading, -32)
                    Stepper(value: $set.reps, in: 0...99){
                        Text("\(set.reps)")
                            .padding(.horizontal, 3)
                            
                    }
                    .background(.navBarColour)
                    .padding(.leading, 20)
                    .cornerRadius(10)
                
                }
                
                VStack{
                    Text("No. Repeats")
                        .font(.subheadline)
                        .padding(.leading, -10)
                        .foregroundStyle(.white)
                    Stepper(value: $set.repeats, in: 0...99){
                        Text("\(set.repeats)")
                            .padding(.horizontal, 3)
                            
                    }
                    .background(.navBarColour)
                    .padding(.leading, 20)
                    .cornerRadius(10)
                    
                }
                
                Button(action: delete) {
                    Image(systemName: "trash")
                        .foregroundColor(.safeBlack)
                        .font(.title2)
                }
                .padding(.leading)
                .padding(.trailing, 20)
                .padding(.top, 25)
                
                Spacer()
            }
            .padding(.top, 15)
            .padding(.bottom, 25)
        }
        .background(.backgroundColour)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        var set = IntermediateSet(id: 1)
        NewSessionCard(set: Binding(get: {return set}, set: { Value in
            set = Value
        })) {
            var hi:Int = 0
        }
    }
}

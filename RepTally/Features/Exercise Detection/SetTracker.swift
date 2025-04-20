//
//  SetTracker.swift
//  RepTally
//
//  Created by Samuel Duggan on 18/04/2025.
//
import UIKit
import CoreData

class SetTracker: ObservableObject {
    static let shared = SetTracker()
    
    @Published var sets: [SetData] = [] //workout related data for current session
    @Published var setIndex = 0 //index in sets (current workout)
    @Published var currentRep = 0 //counter of completed reps for current set
    @Published var noRepeats = 0 //number of repeats of current set
    @Published var subset = 0 //current subset
    var isPaused = false
    
    func currentSet() -> SetData? {
        guard !sets.isEmpty else { return nil }
        return sets[setIndex]
    }
    
    func setComplete() -> Bool {
        guard !sets.isEmpty else { return false }
        return currentRep >= sets[setIndex].reps && (noRepeats > 0 || setIndex < sets.count - 1)
    }
    
    func workoutComplete() -> Bool {
        guard !sets.isEmpty else { return false }
        return currentRep >= sets[setIndex].reps && setIndex == sets.count-1 && noRepeats == 0
    }
    
    func updateSetData(from user: User, viewContext: NSManagedObjectContext){
        hardReset()
        sets = DataFetcher(user: user, viewContext: viewContext).getSetsFromMostRecentSession()
        setIndex = 0
        currentRep = 0
        subset = 0
        if !sets.isEmpty{
            noRepeats = Int(sets[setIndex].repeats)
        }
    }
    
    func hardReset(){
        sets = []
        setIndex = 0
        currentRep = 0
        noRepeats = 0
        subset = 0
    }
    
    func nextWorkout() -> String? {
        if noRepeats > 0 {
            return sets[setIndex].workout
        }
        else if setIndex < sets.count - 1 {
            return sets[setIndex+1].workout
        }
        return nil
    }
    
    func lastSet() -> Bool {
        return setIndex == sets.count-1 && noRepeats == 0
    }
    
    func moveToNextSet() {
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
    
    func incrementRep(){
        if !setComplete() && !isPaused{
            currentRep += 1
        }
    }
}

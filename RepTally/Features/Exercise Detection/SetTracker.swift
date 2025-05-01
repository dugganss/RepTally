//
//  SetTracker.swift
//  RepTally
//
//  Created by Samuel Duggan on 18/04/2025.
//
import UIKit
import CoreData
import AudioToolbox

/*
 This module is used to track the exercises in a session. It is a singleton so needs to be reset inbetween sessions.
 It was made like this so sessions can be managed from anywhere, meaning if the implementation changes, the session screen will still work.
 */

class SetTracker: ObservableObject {
    static let shared = SetTracker()
    
    @Published var sets: [SetData] = [] //workout related data for current session
    @Published var setIndex = 0 //index in sets (current workout)
    @Published var currentRep = 0 //counter of completed reps for current set
    @Published var noRepeats = 0 //number of repeats of current set
    @Published var subset = 0 //current subset
    var isPaused = false
    
    private let soundID: SystemSoundID = {
        //code adapted from Jain (2016) https://stackoverflow.com/questions/35595342/audioservicescreatesystemsoundid-only-once-in-application-and-play-sound-from-an
        var id: SystemSoundID = 0
        if let url = Bundle.main.url(forResource: "beep", withExtension: "mp3") {
            AudioServicesCreateSystemSoundID(url as CFURL, &id)
        }
        //end of adapted code
        return id
    }()
    
    // Returns the current set being performed
    func currentSet() -> SetData? {
        guard !sets.isEmpty else { return nil }
        return sets[setIndex]
    }
    
    // Returns whether the current set is complete and not the end of the session
    func setComplete() -> Bool {
        guard !sets.isEmpty else { return false }
        return currentRep >= sets[setIndex].reps && (noRepeats > 0 || setIndex < sets.count - 1)
    }
    
    // Returns whether the current session is complete
    func workoutComplete() -> Bool {
        guard !sets.isEmpty else { return false }
        return currentRep >= sets[setIndex].reps && setIndex == sets.count-1 && noRepeats == 0
    }
    
    // Updates the current set being looked at by fetching the most recently created set for the current user.
    // Starts from the beginning of the session
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
    
    // Clears everything
    func hardReset(){
        sets = []
        setIndex = 0
        currentRep = 0
        noRepeats = 0
        subset = 0
    }
    
    // Moves to the next workout
    func nextWorkout() -> String? {
        if noRepeats > 0 {
            return sets[setIndex].workout
        }
        else if setIndex < sets.count - 1 {
            return sets[setIndex+1].workout
        }
        return nil
    }
    
    // Returns whether the current set is the last set.
    func lastSet() -> Bool {
        return setIndex == sets.count-1 && noRepeats == 0
    }
    
    // Moves to the next set
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
    
    // Increments the rep counter and plays a sound.
    func incrementRep(){
        if !setComplete() && !workoutComplete() && !isPaused{
            currentRep += 1
            AudioServicesPlaySystemSound(soundID)
        }
    }
}

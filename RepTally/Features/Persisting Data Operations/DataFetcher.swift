//
//  DataFetcher.swift
//  RepTally
//
//  Created by Samuel Duggan on 06/02/2025.
//
import CoreData

struct DataFetcher{
    var user: User?
    var viewContext: NSManagedObjectContext?
    
    func getSetsFromMostRecentSession() -> [SetData]{
        //code adapted from Hudson (n.d.) https://www.hackingwithswift.com/read/38/5/loading-core-data-objects-using-nsfetchrequest-and-nssortdescriptor
        //create request
        let request = Session.fetchRequest()
        
        //define request
        request.predicate = NSPredicate(format: "user == %@", user!) //only give results for current user
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)] //sort by most recent
        request.fetchLimit = 1 //retrieve only 1 result
        
        //safely perform request
        var mostRecentSession: Session?
        do {
            let sessions = try viewContext!.fetch(request)
            mostRecentSession = sessions.first ?? nil  //return the most recent session
        } catch {
            print("Error fetching most recent session: \(error)")
            return []
        }
        //end of adatped code
        //retrieve sets from session
        if mostRecentSession != nil{
            /*
             mostRecentSession.sets is an NSSet (unordered). The implementation requires
             indexing as well as an order, therefore this code casts the NSSet to a set
             then sorts it by the SetData.num property. By calling sorted(), it automatically
             casts the collection to an Array.
             */
            return ((mostRecentSession?.sets as? Set<SetData>) ?? [])
                .sorted { $0.num < $1.num }
        }else{
            print("No sessions were returned from request")
            return []
        }
    }
    
    func getSessions() -> [Session] {
        let request = Session.fetchRequest()
        
        request.predicate = NSPredicate(format: "user == %@", user!)
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
    
        do {
            return try viewContext!.fetch(request)
        } catch {
            print("Error fetching sessions: \(error)")
            return []
        }
    }
}

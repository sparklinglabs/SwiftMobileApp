//
//  APIManager.swift
//  devoxxApp
//
//  Created by maxday on 10.12.15.
//  Copyright (c) 2015 maximedavid. All rights reserved.
//

import Foundation
import UIKit
import CoreData

let topAppURL = "http://cfp.devoxx.be/api/conferences/DV15/schedules/wednesday"

let apiURLS = ["Slot" : "http://cfp.devoxx.be/api/conferences/DV15/schedules/wednesday/", "TalkType" : "http://cfp.devoxx.be/api/conferences/DV15/proposalTypes", "Track" : "http://cfp.devoxx.be/api/conferences/DV15/tracks"]

class APIManager {
    


    
    class func getMockedObjets(postActionParam postAction :(Void) -> (Void), clear : Bool, dataHelper: DataHelper.Type) {
    
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!
        
        //TODO by entity
        if(clear) {
            self.deleteAll(context)
        }
        
        if(!isEntityEmpty(context, name: dataHelper.entityName())) {
            postAction()
            return
        }
        
        /*let testBundle = NSBundle.mainBundle()
        let filePath = testBundle.pathForResource(dataHelper.fileName(), ofType: "json")
        
        let checkString = (try? NSString(contentsOfFile: filePath!, encoding: NSUTF8StringEncoding)) as? String
        
        if(checkString == nil) {
            print("should not be empty", terminator: "")
        }
        
        let data = NSData(contentsOfFile: filePath!)!
        */
        
        let url = NSURL(string: apiURLS[dataHelper.entityName()]!)
        
        
        loadDataFromURL(url!, completion:{(data, error) -> Void in
            print(url)
            print(data)
            
            if let slotData = data {
                self.handleData(slotData, dataHelper: dataHelper, postAction: postAction)
            }
            
            
        })
        
        

        
        
        
    }

    
    class func handleData(inputData : NSData, dataHelper: DataHelper.Type, postAction : (Void) -> Void) {
        
        let json = JSON(data: inputData)
        let arrayToParse = dataHelper.prepareArray(json)
        
        if let appArray = arrayToParse {
            
            for appDict in appArray {
                let fedHelper = dataHelper.feed(appDict)
                dataHelper.save(fedHelper!)
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                postAction()
            }
        }
        
    }
    
    class func loadDataFromURL(url: NSURL, completion:(data: NSData?, error: NSError?) -> Void) {
        let session = NSURLSession.sharedSession()
        let loadDataTask = session.dataTaskWithURL(url, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if let responseError = error {
                completion(data: nil, error: responseError)
            } else if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    let statusError = NSError(domain:"devoxx", code:httpResponse.statusCode, userInfo:[NSLocalizedDescriptionKey : "HTTP status code has unexpected value."])
                    completion(data: nil, error: statusError)
                } else {
                    completion(data: data, error: nil)
                }
            }
        })
        loadDataTask.resume()
    }
    
    class func save(context:NSManagedObjectContext) {
        var error: NSError?
        do {
            try context.save()
        } catch let error1 as NSError {
            error = error1
            print("Could not save \(error), \(error?.userInfo)")
        }
    }
    
    class func deleteAll(context : NSManagedObjectContext) {
        
        let fetchRequest = NSFetchRequest(entityName: "Slot")
        fetchRequest.includesSubentities = true
        fetchRequest.returnsObjectsAsFaults = false
        
        let items = try! context.executeFetchRequest(fetchRequest)
        
        for item in items {
            context.deleteObject(item as! NSManagedObject)
        }
    }
    
    class func getDayFromIndex(index : NSInteger) -> String {
        if(index == 0) {
            return "monday"
        }
        if(index == 1) {
            return "tuesday"
        }
        if(index == 2) {
            return "wednesday"
        }
        if(index == 3) {
            return "thursday"
        }
        return "friday"
    }
    
    class func isAlreadyLoaded() -> Bool {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!
        let fetchRequest = buildFetchRequest(context, name: "Slot")
        let predicate = NSPredicate(format: "day = %@", 0)
        fetchRequest.predicate = predicate
        return checkForEmptyness(context, request: fetchRequest)
    }

    
    class func buildFetchRequest(context: NSManagedObjectContext, name: String) -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: name)
        fetchRequest.includesSubentities = true
        fetchRequest.returnsObjectsAsFaults = false
        return fetchRequest
    }


    class func isEntityEmpty(context: NSManagedObjectContext, name: String) -> Bool {
        return checkForEmptyness(context, request: buildFetchRequest(context, name: name))
    }
    
    class func checkForEmptyness(context: NSManagedObjectContext, request : NSFetchRequest) -> Bool {
        let items = try! context.executeFetchRequest(request)
        return items.count == 0
    }
    
    class func isFavorited(type: String, identifier: String) -> Bool {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!
        let fetchRequest = getFavorite(type, identifier: identifier, context: context)
        let items = try! context.executeFetchRequest(fetchRequest)
        print(items.count)
        if let fav = items[0] as? Favorite {
            return (fav.isFavorited?.boolValue)!
        }
        return false
    }
    
    class func getFavorite(type: String, identifier: String, context: NSManagedObjectContext) -> NSFetchRequest {
        let fetchRequest = buildFetchRequest(context, name: "Favorite")
        let predicateId = NSPredicate(format: "id = %@", identifier)
        let predicateType = NSPredicate(format: "type = %@", type)
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateId, predicateType])
        return fetchRequest
    }

    
    class func invertFavorite(type: String, identifier: String) -> Bool {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!
        let fetchRequest = getFavorite(type, identifier: identifier, context: context)
        let items = try! context.executeFetchRequest(fetchRequest)
        print(items.count)
        if let fav = items[0] as? Favorite {
            if fav.isFavorited!.boolValue {
                fav.isFavorited = 0
            }
            else {
                fav.isFavorited = 1
            }
            save(context)
            return fav.isFavorited!.boolValue
        }
        return false
    }

}


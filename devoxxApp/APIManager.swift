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



let commonUrl:[String : [String]] = ["StoredResource" : ["StoredResource"], "Cfp" : ["Cfp"]]



class APIManager {
    
    static var currentEvent : Cfp!
    
    class func qrCodeAlreadyScanned() -> Bool {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let _ = defaults.objectForKey("qrCode") as? String {
            return true
        }
        return false
    }

    
    class func clearQrCode() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(nil, forKey: "qrCode")
    }

    
    class func setQrCode(str : String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(str, forKey: "qrCode")
    }
    
  

 
    
    class func save(context:NSManagedObjectContext) {
        var error: NSError?
        do {
            try context.save()
        } catch let error1 as NSError {
            error = error1
            //print("Could not save \(error)")
        }
    }
    
    
    
       
    class func getDateFromIndex(index : NSInteger, array: NSArray) -> NSDate {
        if index < array.count  {
            if let dict = array.objectAtIndex(index) as? NSDictionary {
                return (dict.objectForKey("date") as? NSDate)!
            }
        }
        //error
        return NSDate()
    }
    
    
    class func getTrackFromIndex(index : NSInteger, array: NSArray) -> String {
  
        if index < array.count  {
            if let dict = array.objectAtIndex(index) as? NSDictionary {
                return (dict.objectForKey("label") as? String)!
            }
        }
        //error
        return ""
    }
    
    class func buildFetchRequest(context: NSManagedObjectContext, name: String) -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: name)
        fetchRequest.includesSubentities = true
        fetchRequest.returnsObjectsAsFaults = false
        return fetchRequest
    }
    
            

    
       
    class func handleData(inputData : NSData, dataHelper: DataHelperProtocol, storedResource : StoredResource?, etag : String?) {
        
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!


        let json = JSON(data: inputData)
        
        let arrayToParse = dataHelper.prepareArray(json)

        if let appArray = arrayToParse {
            for appDict in appArray {

                let newHelper = dataHelper.copyWithZone(nil) as! DataHelperProtocol
                
                newHelper.feed(appDict)
                newHelper.save(context)
                
            }
        }
        
        storedResource?.etag = etag ?? ""
        
        
        APIManager.save(context)

        
    
    }

    
    static var serviceGroup = dispatch_group_create()
    
    class func step(msg:String) -> Void {
        //print("step out")
        dispatch_group_leave(serviceGroup)
    }
    
    class func handleData(inputData : NSData, service: AbstractService, storedResource : StoredResource?, etag : String?,completionHandler : (msg: String) -> Void) {
        
        let json = JSON(data: inputData)
        print(storedResource?.url)
        let arrayToParse = service.getHelper().prepareArray(json)
        
        if let appArray = arrayToParse {
            
        
            
            for appDict in appArray {
                //print("step in")
                dispatch_group_enter(serviceGroup)
            }
            
            for appDict in appArray {
                
                let newHelper = service.getHelper()
                newHelper.feed(appDict)
                
                service.updateWithHelper(newHelper, completionHandler: step)
                
                
            }
        }

        storedResource?.etag = etag ?? ""
    
        dispatch_group_notify(serviceGroup,dispatch_get_main_queue(), {
            completionHandler(msg:"DONE")
        })
    }

    

    
    class func firstFeed(completionHandler: (msg: String) -> Void, service : AbstractService) {
        singleCommonFeed(CfpHelper(), completionHandler: completionHandler, service : service)
    }
    
    class func singleCommonFeed(helper : DataHelperProtocol, completionHandler: (msg: String) -> Void, service : AbstractService) {
        
        
        let url = commonUrl[helper.entityName()]
        
        let testBundle = NSBundle.mainBundle()
        
        for singleUrl in url! {
            
            let filePath = testBundle.pathForResource(singleUrl, ofType: "json")
            let checkString = (try? NSString(contentsOfFile: filePath!, encoding: NSUTF8StringEncoding)) as? String
            if(checkString == nil) {
               // print("should not be empty", terminator: "")
            }
            let data = NSData(contentsOfFile: filePath!)!
            
            
            self.handleData(data, service: service, storedResource: nil, etag: nil, completionHandler: completionHandler)
            
            //self.handleData(data, dataHelper: helper, storedResource: nil, etag: nil)
        }
        
        
    }
    
   
    
    
    
    
    
    
    class func dataFromImage(imageName : String) -> NSData? {
        let image = UIImage(named: imageName)
        let nsData = UIImageJPEGRepresentation(image!, 1.0)
        return nsData
    }
    
    
    class func getStringDevice() -> String{
        switch UIDevice.currentDevice().userInterfaceIdiom {
        case .Phone:
            return "phone"
        case .Pad:
            return "tablet"
        default :
            return ""
        }
    }
  
    class func setEvent(event : Cfp) {
        currentEvent = event
    }
    
    class func getEvent() -> Cfp {
        return currentEvent
    }
    
    
    
    class func getLastFromUrl(url : String) -> String {
        let lastPartImageName = url.characters.split{$0 == "/"}.map(String.init)
        
        //check if well formed URL
        if lastPartImageName.count < 2 {
            return ""
        }
        return lastPartImageName[lastPartImageName.count-1]
    }
    
    
    
    class func exists(id : String, leftPredicate: String, entity: String, checkAgainCurrentEvent : Bool) -> Bool {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!
        let fetchRequest = NSFetchRequest(entityName: entity)
        let predicate = NSPredicate(format: "\(leftPredicate) = %@", id)
        if checkAgainCurrentEvent {
            let predicateEvent = NSPredicate(format: "cfp.id = %@", APIManager.currentEvent.id!)
            fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, predicateEvent])
        } else {
            fetchRequest.predicate = predicate
        }
        do {
            let items = try context.executeFetchRequest(fetchRequest)
            return items.count > 0
        } catch {
            print("err")
        }
        
        return false

    }
    
    
    class func exists(id : String, leftPredicate: String, entity: String) -> Bool {
        return exists(id, leftPredicate: leftPredicate, entity: entity, checkAgainCurrentEvent: false)
    }
    
    class func findOne(name : String, value : String, entity: String, context: NSManagedObjectContext) -> FeedableProtocol {
        let fetchRequest = NSFetchRequest(entityName: entity)
        let predicate = NSPredicate(format: "\(name) = %@", value)
        fetchRequest.predicate = predicate
        let items = try! context.executeFetchRequest(fetchRequest)
        
        return items[0] as! FeedableProtocol
    }
    
    
    class func isCurrentEventEmpty() -> Bool {
        //return getDistinctDays().count == 0
        return false

    }
   
    
}


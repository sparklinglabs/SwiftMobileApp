//
//  Cfp.swift
//  devoxxApp
//
//  Created by got2bex on 2016-02-06.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import CoreData
import UIKit


public protocol EventProtocol  {
    func title() -> String
    func splashImageName() -> String
    func capacityCount() -> String
    func sessionsCount() -> String
    func daysLeft() -> String
    func backgroundImage() -> Data
    func identifier() -> String
}

class Cfp: NSManagedObject, FeedableProtocol, EventProtocol {
    
    @NSManaged var id: String?
    @NSManaged var integration_id: String?
    @NSManaged var confType: String?
    @NSManaged var confDescription: String?
    @NSManaged var venue: String?
    @NSManaged var address: String?
    @NSManaged var country: String?
    @NSManaged var fromDate: String?
    @NSManaged var capacity: String?
    @NSManaged var sessions: String?
    @NSManaged var latitude: String?
    @NSManaged var longitude: String?
    @NSManaged var splashImgURL: String?
    @NSManaged var talkURL: String?
    @NSManaged var hashtag: String?
    @NSManaged var votingImageName: String?
    @NSManaged var cfpEndpoint: String?
    @NSManaged var regURL: String?
    @NSManaged var backgroundImageData: Data?
    @NSManaged var floors: NSSet
    @NSManaged var days: NSOrderedSet
    @NSManaged var attributes: NSSet
    
    
    func getId() -> NSManagedObject? {
        return nil
    }
    func resetId(_ id: NSManagedObject?) {
    }
    
    func identifier() -> String {
        return id!
    }
    
    
    func feedHelper(_ helper: DataHelperProtocol) -> Void {
        if let castHelper = helper as? CfpHelper  {
            
            id = castHelper.id
            integration_id = castHelper.integration_id
            confType = castHelper.confType
            confDescription = castHelper.confDescription
            venue = castHelper.venue
            address = castHelper.address
            talkURL = castHelper.talkURL
            country = castHelper.country
            capacity = castHelper.capacity
            regURL = castHelper.regURL
            fromDate = castHelper.fromDate
            sessions = castHelper.sessions
            cfpEndpoint = castHelper.cfpEndpoint
            latitude = castHelper.latitude
            longitude = castHelper.longitude
            votingImageName = castHelper.votingImageName
            splashImgURL = castHelper.splashImgURL
            hashtag = castHelper.hashtag
            
            let splashImgUrlLastComponent = APIManager.getLastFromUrl(splashImgURL!)
            
            if let path = Bundle.main.path(forResource: splashImgUrlLastComponent, ofType: "") {
                if let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                    backgroundImageData = data
                }
            }
            
        }
    }
    
    func daysLeft() -> String {
        
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = dateFormatter.date(from: fromDate!)
        let now = Date()
        
        let string = "\(differenceInDaysWithDate(now, secondDate: date!))"
        
        
        return string
        
        
    }
    
    
    func differenceInDaysWithDate(_ firstDate : Date, secondDate: Date) -> Int {
        
        if firstDate.timeIntervalSince1970 >= secondDate.timeIntervalSince1970 {
            return 0
        }
        
        let calendar: Calendar = Calendar.current
        
        let date1 = calendar.startOfDay(for: firstDate)
        let date2 = calendar.startOfDay(for: secondDate)
        
        let components = (calendar as NSCalendar).components(.day, from: date1, to: date2, options: [])
        return components.day!
    }
    
    
    func title() -> String {
        return country!
    }
    
    func capacityCount() -> String {
        if capacity == nil {
            return "0"
        }
        return capacity!
    }
    
    func sessionsCount() -> String {
        if sessions == nil {
            return "0"
        }
        return sessions!
    }
    
    func splashImageName() -> String {
        return "splash_btn_\(id!).png"
    }
    
    func numbers() -> Array<Int> {
        return [10, 20, 30]
    }
    
    func backgroundImage() -> Data {
        return backgroundImageData!
    }
    
    func getVotingImage() -> String {
        return "ic_\(votingImageName!)"
    }
    
    
    
}

//
//  TalkHelper.swift
//  devoxxApp
//
//  Created by maxday on 10.12.15.
//  Copyright (c) 2015 maximedavid. All rights reserved.
//

import Foundation
import CoreData
import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


class TalkHelper: DataHelperProtocol, DetailableProtocol, RatableProtocol{
    
    var title: String?
    var lang: String?
    var trackId: String?
    var talkType: String?
    var track: String?
    var id: String?
    var summary: String?
    var isBreak: Bool?
    var objectID : NSManagedObjectID?
    var speakerIds:[String]?
    var isFav: Bool?
    var roomName : String?
    var friendlyTime : String?
    var speakerList : String?
    var speakerListTwitter : String?
    var speakersId : [NSManagedObjectID]?
    var relatedObjects: [DataHelperProtocol]?
    var day : String?
    
    init() {
    }
    
    init(title: String?, lang: String?, trackId: String?, talkType: String?, track: String?, id: String?, summary: String?, isBreak: Bool, roomName:String?, friendlyTime : String?, speakerList : String?, speakerListTwitter : String?, speakersId : [NSManagedObjectID], objectID : NSManagedObjectID?, isFav : Bool, day : String) {
        self.title = title ?? ""
        self.lang = lang ?? ""
        self.trackId = trackId ?? ""
        self.talkType = talkType ?? ""
        self.track = track ?? ""
        self.id = id ?? ""
        self.summary = summary ?? ""
        self.isBreak = isBreak
        self.roomName = roomName ?? ""
        self.friendlyTime = friendlyTime ?? ""
        self.speakerList = speakerList ?? ""
        self.objectID = objectID
        self.speakerListTwitter = speakerListTwitter ?? ""
        self.speakersId = speakersId ?? [NSManagedObjectID]()
        self.isFav = isFav ?? false
        self.day = day ?? ""
    }
    
    func getMainId() -> String {
        return ""
    }
    
    func typeName() -> String {
        return entityName()
    }
    
    func feed(_ data: JSON) {
        
        title = data["title"].string
        if(title == nil) {
            title = data["nameEN"].string
        }
        lang = data["lang"].string
        trackId = data["trackId"].string
        talkType = data["talkType"].string
        track = data["track"].string
        id = data["id"].string
        summary = data["summary"].string
        
        if let speakerArray = data["speakers"].array {
            speakerIds = [String]()
            for spk in speakerArray {
                
                speakerIds!.append(spk["link"]["href"].string!)
            }
        }
        
    }
    
    func entityName() -> String {
        return "Talk"
    }
    
    func prepareArray(_ json: JSON) -> [JSON]? {
        
        if(json["break"] != nil) {
            isBreak = true
            return [json["break"]]
        }
        isBreak = false
        return [json["talk"]]
    }
    
    
    
    //detailable
    func getTitleD() -> String? {
        return title
    }
    
    func getSubTitle() -> String? {
        return track
    }
    
    func getSummary() -> String? {
        return summary
    }
    
    func getTwitter() -> String? {
        let hashtag = CfpService.sharedInstance.getHashtag()
        return "\(hashtag) \(getTitle()) by \(speakerListTwitter!) \(getFullLink()!)"
    }
    
        
    func getDetailInfoWithIndex(_ idx: Int) -> String? {
        if idx < detailInfos().count {
            return detailInfos()[idx]
        }
        return nil
    }

    
    func detailInfos() -> [String] {
        return [roomName!, HelperManager.getShortTalkTypeName(talkType!), friendlyTime!, speakerList!, day!]
    }
    
    func getRelatedDetailWithIndex(_ idx : Int) -> DetailableProtocol? {
        if idx < relatedObjects?.count {
            return relatedObjects?[idx] as? DetailableProtocol
        }
        return nil
    }
    
    func getObjectId() -> NSManagedObjectID? {
        return objectID
    }
    
    func getFullLink() -> String? {
        return "\(CfpService.sharedInstance.getTalkURL())\(id!)"
    }
    
    func getImageFullLink() -> String? {
        return nil
    }
    
    func getRelatedDetailsCount() -> Int {
        if speakersId != nil {
            return speakersId!.count
        }
        return 0
    }
    
    func getPrimaryImage() -> UIImage? {
        return UIImage(named: "icon_\(trackId!)")
    }
    
    func getHeaderTitle() -> String? {
        return "Speakers"
    }

    func getRelatedIds() -> [NSManagedObjectID] {
        if speakersId == nil {
            return [NSManagedObjectID]()
        }
        return speakersId!
    }
    
    func setRelated(_ data: [DataHelperProtocol]) {
        relatedObjects = data
    }
    
    func getObjectID() -> NSManagedObjectID? {
        return objectID
    }
    func isFavorited() -> Bool {
        return isFav!
    }
    
    func getTitle() -> String {
        return title!
    }
    
    func getSubTitle() -> String {
        return speakerList ?? ""
    }
    
    func getIdentifier() -> String {
        return id!
    }
    
    func isEnabled() -> Bool {
        if isBreak == nil {
            return false
        }
        return !(isBreak!)
    }



    
}

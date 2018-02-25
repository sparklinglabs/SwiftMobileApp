//
//  Talk.swift
//  devoxxApp
//
//  Created by maxday on 11.12.15.
//  Copyright (c) 2015 maximedavid. All rights reserved.
//

import Foundation
import CoreData
import UIKit

public protocol DetailableProtocol {
    func getTitleD() -> String?
    func getSubTitle() -> String?
    func getSummary() -> String?
    func detailInfos() -> [String]
    func getRelatedDetailsCount() -> Int
    func getRelatedDetailWithIndex(_ idx : Int) -> DetailableProtocol?
    func getDetailInfoWithIndex(_ idx : Int) -> String?
    func getFullLink() -> String?
    func getImageFullLink() -> String?
    func getPrimaryImage() -> UIImage?
    func getTwitter() -> String?
    func getHeaderTitle() -> String?
    func getRelatedIds() -> [NSManagedObjectID]
    func setRelated(_ data : [DataHelperProtocol])
    func getObjectID() -> NSManagedObjectID?
    func isFavorited() -> Bool
}

protocol RatableProtocol {
    func getTitle() -> String
    func getIdentifier() -> String
    func getSubTitle() -> String
    func isEnabled() -> Bool
}


protocol HelperableProtocol {
    func toHelper() -> DataHelperProtocol
}


class Talk: NSManagedObject, FavoriteProtocol, CellDataPrococol, SearchableItemProtocol, HelperableProtocol, FeedableProtocol {
    
    @NSManaged var id: String
    @NSManaged var lang: String
    @NSManaged var summary: String
    @NSManaged var talkType: String
    @NSManaged var title: String
    @NSManaged var track: String
    @NSManaged var trackId: String
    @NSManaged var speakers: NSSet
    @NSManaged var isFavorited: Bool
    @NSManaged var isBreak : Bool
    @NSManaged var slot: Slot
    
        
    func getIconFromTrackId() -> String {
        return "icon_\(trackId)"
    }
    
    func getId() -> NSManagedObject? {
        return nil
    }
    
    func resetId(_ id: NSManagedObject?) {
    }
    
    func getIdentifier() -> String {
        return id
    }
    
    
    func getFriendlySpeaker(_ delimiter : String, useTwitter : Bool) -> String {
        var returnString = ""
        var isFirst = true
        for spk in speakers {
            if let castSpk = spk as? Speaker {
                let display = (useTwitter && castSpk.speakerDetail.twitter != "") ? castSpk.speakerDetail.twitter : castSpk.getFirstInformation()
                if(isFirst)  {
                    returnString = returnString + display
                    isFirst = false
                }
                else {
                    returnString = returnString + delimiter + display
                }
            }
        }
        return returnString
    }
    
    
    
    func getShortTalkTypeName() -> String {
        if(talkType == "Ignite Sessions") {
            return "Ignite"
        }
        if(talkType == "Conference") {
            return "Conference"
        }
        if(talkType == "Quickie") {
            return "Quickie"
        }
        if(talkType == "Keynote") {
            return "Keynote"
        }
        if(talkType == "University") {
            return "University"
        }
        if(talkType == "Tools-in-Action") {
            return "Tools"
        }
        if(talkType == "Hand's on Labs") {
            return "HOL"
        }
        if(talkType == "BOF (Bird of a Feather)") {
            return "BOF"
        }
        return talkType
    }
  
    
    
    func feedHelper(_ helper: DataHelperProtocol) -> Void {
        if let castHelper = helper as? TalkHelper  {
            id = castHelper.id ?? ""
            lang = castHelper.lang ?? ""
            summary = castHelper.summary ?? ""
            talkType = castHelper.talkType ?? ""
            title = castHelper.title ?? ""
            track = castHelper.track ?? ""
            trackId = castHelper.trackId ?? ""
            isBreak = castHelper.isBreak ?? false
        }
    }
    
    func invertFavorite() {
        isFavorited = !isFavorited
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.updateFavoriteStatus(isFavorited, forTalkWithId: self.getIdentifier(), inConferenceWithId: self.slot.cfp!.identifier())
            appDelegate.unscheduleLocalNotificationForTalkWithId(self.getIdentifier())
            if isFavorited {
                appDelegate.scheduleLocalNotificationForTalkWithId(self.getIdentifier(), title: self.title, room: self.slot.roomName, fromTime: self.slot.fromTime, toTime: self.slot.toTime, fromTimeMillis: self.slot.fromTimeMillis)
            }
        }
    }
    
    func isFav() -> Bool {
        return isFavorited
    }
    
    
    
    
    
    
    func getForthInformation(_ useTwitter : Bool) -> String {
        return getFriendlySpeaker(", ", useTwitter : useTwitter)
    }
    
    func getPrimaryImage() -> UIImage? {
        return UIImage(named: getIconFromTrackId())
    }
    
    
    func getFirstInformation() -> String {
        return title
    }
    
    func getSecondInformation() -> String {
        return slot.roomName
    }
    
    func getThirdInformation() -> String {
        return track
    }
    
    func isMatching(_ str : String) -> Bool {
        return getFirstInformation().lowercased().contains(str.lowercased()) || getFriendlySpeaker("", useTwitter: false).lowercased().contains(str.lowercased())
    }
    
    
    func getColor() -> UIColor? {
        return ColorManager.getColorFromTalkType(talkType)
    }
    
    func getElement() -> NSManagedObject {
        return self
    }
    
    func getObjectID() -> NSManagedObjectID {
        return objectID
    }

    func getUrl() -> String? {
        return ""
    }
    
    func isSpecial() -> Bool {
        return isBreak
    }
    
    func toHelper() -> DataHelperProtocol {
        
        var speakerHelpers = [NSManagedObjectID]()
        for singleSpeaker in speakers {
            speakerHelpers.append((singleSpeaker as AnyObject).getObjectID())
        }
        
        return TalkHelper(title: title, lang: lang, trackId: trackId, talkType: talkType, track: track, id: id, summary: summary, isBreak: isBreak, roomName: slot.roomName, friendlyTime: slot.getFriendlyTime(), speakerList : getFriendlySpeaker(", ", useTwitter : false), speakerListTwitter : getFriendlySpeaker(", ", useTwitter : true), speakersId : speakerHelpers, objectID : objectID, isFav : isFavorited, day : slot.day)
    }
    
    
    
}

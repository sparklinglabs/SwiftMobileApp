//
//  SpeakerHelper.swift
//  devoxxApp
//
//  Created by got2bex on 2015-12-14.
//  Copyright © 2015 maximedavid. All rights reserved.
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


class SpeakerHelper: DataHelperProtocol, DetailableProtocol, CellDataDisplayPrococol, FavoriteProtocol, SearchableItemProtocol {
    
    var uuid: String?
    var lastName: String?
    var firstName: String?
    var avatarUrl: String?
    var objectID : NSManagedObjectID?
    var href: String?
    var bio : String?
    var company : String?
    var isFavorite : Bool?
    var imgData : Data?
    var talksId : [NSManagedObjectID]?
    var relatedObjects: [DataHelperProtocol]?
    var twitter : String?
    
    func getMainId() -> String {
        return uuid!
    }
    
    init() {
    }
    
    init(uuid: String?, lastName: String?, firstName: String?, avatarUrl: String?, objectID : NSManagedObjectID, href: String?, bio: String?, company: String?, twitter : String?, isFavorite: Bool, talksId : [NSManagedObjectID]?, imgData : Data?) {
        self.uuid = uuid ?? ""
        self.lastName = lastName ?? ""
        self.firstName = firstName ?? ""
        self.objectID = objectID
        self.avatarUrl = avatarUrl ?? ""
        self.href = href ?? ""
        self.bio = bio ?? ""
        self.twitter = twitter ?? ""
        self.company = company ?? ""
        self.isFavorite = isFavorite
        self.talksId = talksId
        self.imgData = imgData
    }
    
    func feed(_ data: JSON) {
        uuid = data["uuid"].string
        lastName = data["lastName"].string?.capitalized
        firstName = data["firstName"].string?.capitalized
        avatarUrl = data["avatarURL"].string
        href = data["links"][0]["href"].string
    }
    
    func typeName() -> String {
        return entityName()
    }
    
    func entityName() -> String {
        return "Speaker"
    }
    
    func prepareArray(_ json : JSON) -> [JSON]? {
        return json.array
    }
    
    
    
    
    
    func displayTwitter() -> String {
        if twitter != nil && twitter != "" {
            return twitter!
        }
        return getTitleD()!
    }
    
    
    //detailable
    func getTwitter() -> String? {
        let hashtag = CfpService.sharedInstance.getHashtag()
        return "\(hashtag) \(displayTwitter())"
    }
    
    func getTitleD() -> String? {
        return "\(firstName!) \(lastName!)"
    }
    
    func getSubTitle() -> String? {
        return company
    }
    
    func getSummary() -> String? {
        return bio
    }
    
    func detailInfos() -> [String] {
        return []
    }
    
    func getDetailInfoWithIndex(_ idx: Int) -> String? {
        if idx < detailInfos().count {
            return detailInfos()[idx]
        }
        return nil
    }
    
    func getObjectId() -> NSManagedObjectID? {
        return objectID
    }
    
    func getRelatedDetailWithIndex(_ idx : Int) -> DetailableProtocol? {
        if idx < relatedObjects?.count {
            return relatedObjects?[idx] as? DetailableProtocol
        }
        return nil
    }
    
    func getFullLink() -> String? {
        return href
    }
    
    func getImageFullLink() -> String? {
        return avatarUrl
    }
    
    
    func getRelatedDetailsCount() -> Int {
        if talksId != nil {
            return talksId!.count
        }
        return 0
    }
    
    func getHeaderTitle() -> String? {
        return "Talks"
    }

    func getPrimaryImage() -> UIImage? {
        if imgData == nil {
            return nil
        }
        return UIImage(data: imgData!)
    }
    
    func getRelatedIds() -> [NSManagedObjectID] {
        if talksId == nil {
            return [NSManagedObjectID]()
        }
        return talksId!
    }
    
    func getObjectID() -> NSManagedObjectID? {
        return objectID
    }
    
    func setRelated(_ data : [DataHelperProtocol]){
        relatedObjects = data
    }
    
    
    func getFirstInformation() -> String? {
        return getTitleD()
    }
    
    func getUrl() -> String? {
        return avatarUrl
    }
    func isFavorited() -> Bool {
        return isFavorite!
    }
    
    func isMatching(_ str : String) -> Bool {
        return getTitleD()!.lowercased().contains(str.lowercased())
    }
    
    func invertFavorite() {
        //nothing to do here
    }
    func isFav() -> Bool {
        return isFavorite!
    }
    
}

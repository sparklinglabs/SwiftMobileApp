//
//  CellDataProtocol.swift
//  devoxxApp
//
//  Created by maxday on 24.12.15.
//  Copyright © 2015 maximedavid. All rights reserved.
//

import Foundation
import CoreData
import UIKit

@objc public protocol CellDataPrococol : NSObjectProtocol {
    
    func getFirstInformation() -> String
    func getSecondInformation() -> String
    func getThirdInformation() -> String
    func getForthInformation(_ useTwitter : Bool) -> String
    func getPrimaryImage() -> UIImage?
    func getColor() -> UIColor?
    func getElement() -> NSManagedObject
    func getUrl() -> String?
    func isSpecial() -> Bool
    func getObjectID() -> NSManagedObjectID
    
    init()
    
}


protocol CellDataDisplayPrococol {

    func getFirstInformation() -> String?
    func getPrimaryImage() -> UIImage?
    func getUrl() -> String?
    func getObjectID() -> NSManagedObjectID?
    
}

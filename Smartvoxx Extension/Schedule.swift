//
//  Schedule.swift
//  Smartvoxx
//
//  Created by Sebastien Arbogast on 04/10/2015.
//  Copyright © 2015 Epseelon. All rights reserved.
//

import Foundation
import CoreData

class Schedule: NSManagedObject {

    var purgedTitle:String {
        if let title = self.title {
            return title.replacingOccurrences(of: "Schedule for ", with: "").replacingOccurrences(of: "Journée du ", with: "")
        } else {
            return ""
        }
    }

}

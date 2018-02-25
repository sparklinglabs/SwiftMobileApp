//
//  TalkTypeService.swift
//  My_Devoxx
//
//  Created by Maxime on 13/03/16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import CoreData

class TalkTypeService : AbstractService {
    
    static let sharedInstance = TalkTypeService()
    
    override func getHelper() -> DataHelperProtocol {
        return TalkTypeHelper()
    }
    
     override func updateWithHelper(_ helper : [DataHelperProtocol], completionHandler : @escaping (_ msg: CallbackProtocol) -> Void) {
        AttributeService.sharedInstance.updateWithHelper(helper, completionHandler: completionHandler)
    }
    
    override func hasBeenAlreadyFed() -> Bool {
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Attribute")
            let predicateEvent = NSPredicate(format: "cfp.id = %@", super.getCfpId())
            let predicateType = NSPredicate(format: "type = %@", "TalkType")
            fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateEvent, predicateType])
            let results = try self.privateManagedObjectContext.fetch(fetchRequest)
            return results.count > 0
        }
        catch {
            return false
        }
    }
    
}

//
//  EducationDoneData.swift
//  TravellersStatus
//
//  Created by Siva Cherukuri on 08/02/17.
//  Copyright © 2017 ithaka. All rights reserved.
//

import UIKit

class EducationDoneData: NSObject {

    var travellerId: String?
    var travellerName: String?
    var travelDate: String?
    var travelStatus: String?
    var travelColorCode: String?
    
    override init () {
        
    }
    
    convenience init(_ travelData: Dictionary<String, AnyObject>)
    {
        
        self.init()
        
        self.travellerId = travelData["_id"] as? String
        self.travellerName = travelData["name"] as? String
        self.travelDate = travelData["tripDate"] as? String
        self.travelStatus = travelData["status"] as? String
        self.travelColorCode = travelData["colorCode"] as? String
        
        
    }

}

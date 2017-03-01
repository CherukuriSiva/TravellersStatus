//
//  TravelersManager.swift
//  TravellersStatus
//
//  Created by Siva Cherukuri on 08/02/17.
//  Copyright © 2017 ithaka. All rights reserved.
//

import Foundation

class TravelersManager {
    
    //MARK: Shared Instance
    
    static let sharedInstance : TravelersManager = {
        let instance = TravelersManager()
        return instance
    }()
    
    //MARK: Local Variable
    
    var localTravelData : TravelersData? = nil
    
    //MARK: Init
    
    convenience init(travelSharedData : TravelersData)
    {
        self.init()
        
        self.localTravelData = travelSharedData
    }

}

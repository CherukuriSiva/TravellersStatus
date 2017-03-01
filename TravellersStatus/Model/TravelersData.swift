//
//  TravelersData.swift
//  TravellersStatus
//
//  Created by Siva Cherukuri on 08/02/17.
//  Copyright © 2017 ithaka. All rights reserved.
//

import UIKit

class TravelersData: NSObject
{

    var onBoardingDataArray = Array<Any>()
    var educationDataArray = Array<Any>()
    var planDoneArray = Array<Any>()
    var hotelDoneArray = Array<Any>()
    
    override init () {
        
    }
    
    convenience init(_ travelersData: Array<Any>)
    {
        
        self.init()

        for travelerObj in travelersData {
            
            var travelData:Dictionary<String, Any> = travelerObj as! Dictionary<String, Any>
            
            let status:String = travelData["status"] as! String
            
            if status == "onboarding" {
            
                onBoardingDataArray.append(OnBardingDoneData(travelData as Dictionary<String, AnyObject>))
                
            }else if status == "education" {
                
                educationDataArray.append(EducationDoneData(travelData as Dictionary<String, AnyObject>))

            }else if status == "planned" {
                
                planDoneArray.append(PlanDoneData(travelData as Dictionary<String, AnyObject>))

            }else if status == "complete" {
                
                hotelDoneArray.append(HotelDoneData(travelData as Dictionary<String, AnyObject>))

            }else
            {
                //print("Got Other Data")
            }
            
        }
        
    }
}

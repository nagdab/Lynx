//
//  Coupon.swift
//  LynxApp
//
//  Created by Yifan Xu on 2/22/17.
//  Copyright © 2017 Yifan & Bhavik. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase

class Coupon
{
    let key : String
    let ID: Int
    static var nextID : Int = 0
    let ref : FIRDatabaseReference?
    let businessID : Int
    var numbersLeft : Int
    let endDate : Date
    var discount : String
    var disc : String
    
    init(key: String = "", businessID : Int, numbersLeft : Int, endDate : Date, discount: String, disc: String)
    {
        self.key = key
        Coupon.nextID += 1
        self.ID = Coupon.nextID
        self.businessID = businessID
        self.numbersLeft = numbersLeft
        self.endDate = endDate
        self.discount = discount
        self.disc = disc
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot)
    {
        self.key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        self.ID = snapshotValue["ID"] as! Int
        self.businessID = snapshotValue["businessID"] as! Int
        self.numbersLeft = snapshotValue["numbersLeft"] as! Int
        self.endDate = stringToDate(dateString: snapshotValue["endDate"] as! String)
        self.discount = snapshotValue["discount"] as! String
        self.disc = snapshotValue["disc"] as! String
        self.ref = snapshot.ref
    }
    
    func toStorage()-> Any
    {
        return [
            "id" : ID,
            "businessID" : businessID,
            "numbersLeft" : numbersLeft,
            "endDate" : dateToString(dateData: endDate),
            "discount" : discount,
            "disc" : disc
        ]
    }
    
}

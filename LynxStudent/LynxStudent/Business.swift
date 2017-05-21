//
//  Business.swift
//  LynxStudent
//
//  Created by Yifan Xu on 3/5/17.
//  Copyright © 2017 Yifan & Bhavik. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase


class Business: Hashable
{
    var key: String
    var name: String
    var address: String
    var photoURL: String
    var rating : [String: Double] = ["default" : 5.0]
    var comments : [String: String] = ["default" : ""]
    var profilePic: UIImage?
    
    var overallRating: Double {
        get {
            let allRatings = Array(rating.values)
            return allRatings.reduce(0.0, {$0 + Double($1)})/Double(allRatings.count)
        }
    }
    
    var numOfRating: Int {
        get {
            let allRatings = Array(rating.values)
            return allRatings.count
        }
    }
    
    // reference to its position at firebase database
    let ref: FIRDatabaseReference?
    
    init(key: String = "", name: String, address: String, photoURL: String = "")
    {
        self.key = key
        self.name = name
        self.address = address
        self.photoURL = photoURL
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot)
    {
        self.key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        self.name = snapshotValue["name"] as! String
        self.address = snapshotValue["address"] as! String
        self.photoURL = snapshotValue["photoURL"] as! String
        self.rating = snapshotValue["rating"] as! [String: Double]
        self.comments = snapshotValue["comments"] as! [String : String]
        self.ref = snapshot.ref
    }
    
    func toStorage()-> [String : Any]
    {
        return [
            "name" : self.name,
            "address" : self.address,
            "photoURL" : self.photoURL,
            "rating" : self.rating,
            "comments" : self.comments
        ]
    }
    
    var hashValue: Int
    {
        return name.characters.count
    }
}

func == (left: Business, right: Business) -> Bool
{
    return left.name == right.name
}

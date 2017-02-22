//
//  DataService.swift
//  Social_App
//
//  Created by Gabriel Benbow on 1/24/16.
//  Copyright © 2016 Gabriel Benbow. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseAnalytics
import FirebaseDatabase

let BASE_URL = "https://ph-watch.firebaseio.com"

class DataService {
	
	static let ds = DataService()
    
    var ref: FIRDatabaseReference! = FIRDatabase.database().reference()
    
    
	fileprivate var _REF_BASE = FIRDatabase.database().reference()
	fileprivate var _REF_POSTS = FIRDatabase.database().reference().child("posts")
	fileprivate var _REF_USERS = FIRDatabase.database().reference().child("users")
	fileprivate var _REF_USERNAMES = FIRDatabase.database().reference().child("usernames")
	
	var REF_BASE: FIRDatabaseReference {
		return _REF_BASE
	}
	
	var REF_POSTS: FIRDatabaseReference {
		return _REF_POSTS
	}
	
	var REF_USERS: FIRDatabaseReference {
		return _REF_USERS
	}
	
	var REF_USERNAMES: FIRDatabaseReference {
		return _REF_USERNAMES
	}
	
	func createFirebaseUser(_ uid: String, user: Dictionary<String, String>) {
		REF_USERS.child(byAppendingPath: uid).setValue(user)
	}
	
	var REF_USER_CURRENT: FIRDatabaseReference {
		let uid = UserDefaults.standard.value(forKey: KEY_UID) as! String
		let user = Firebase(url: "\(REF_USERS)").childByAppendingPath(uid)
		return user!
	}
	
	
	
}

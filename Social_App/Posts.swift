//
//  Posts.swift
//  Social_App
//
//  Created by Gabriel Benbow on 1/25/16.
//  Copyright © 2016 Gabriel Benbow. All rights reserved.
//

import Foundation
import Firebase

class Post {
	fileprivate var _postDescription: String!
	fileprivate var _imageURL: String?
	fileprivate var _username: String?
	fileprivate var _likes: Int!
	fileprivate var _postKey: String!
	fileprivate var _profileImageURL: String?
	fileprivate var _date: String!
	fileprivate var _userKey: String!
	
	
	
	fileprivate var _postRef: Firebase!
	
	var date: String {
		return _date
	}
	
	var postDescription: String {
		return _postDescription
	}
	
	
	var imageURL: String? {
		return _imageURL
	}
	
	var likes: Int {
		return _likes
	}
	
	var username: String? {
		return _username
	}
	
	var postKey: String {
		return _postKey
	}
	var profileImageURL: String? {
		return _profileImageURL
	}
	
	var userKey: String! {
		return _userKey
	}
	
	init(description: String, imageURL: String, likes: Int, date: String, userKey: String) {
		self._postDescription = description
		self._likes = likes
		self._imageURL = imageURL
		self._date = date
		self._userKey = userKey
	}
	
	init(postKey: String, dictionary: Dictionary<String, AnyObject>) {
		self._postKey = postKey
		
		if let date = dictionary["date"] as? String {
			self._date = date
		}
		
		if let likes = dictionary["likes"] as? Int {
			self._likes = likes
		}
		
		if let imgURL = dictionary["imageURL"] as? String {
			self._imageURL = imgURL
		}
		
		if let desc = dictionary["description"] as? String {
			self._postDescription = desc
		}
		
		if let userKey = dictionary["userKey"] as? String {
			self._userKey = userKey
		}
		
		self._postRef = DataService.ds.REF_POSTS.childByAppendingPath(self.postKey)
	}
	
	func adjustLikes(_ addLike: Bool) {
		
		if addLike {
			_likes = _likes + 1
		} else {
			_likes = _likes - 1
		}
		
		_postRef.childByAppendingPath("likes").setValue(_likes)
		
	}

	
	
}


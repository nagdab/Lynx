//
//  SearchVC.swift
//  InstaClone
//
//  Created by Gabriel Benbow on 2/10/16.
//  Copyright © 2016 Gabriel Benbow. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class SearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

	@IBOutlet weak var searchbar: UISearchBar!
	
	@IBOutlet weak var SearchTableView: UITableView!
	
	var users = [String]()
	var filteredUsers = []
	

	
	var searchActive = false
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		SearchTableView.delegate = self
		SearchTableView.dataSource = self
		searchbar.delegate = self
		
		
		
		
    }
	
	func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
		searchActive = true
	}
	
	func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
		searchActive = false
		UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)

		
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		searchActive = false
		self.users = []
		self.SearchTableView.reloadData()
		
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		searchActive = false
		UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
	}
	
	
	
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		if searchBar.text == "" || searchBar.text == nil {
			searchActive = false
			self.users = []
			SearchTableView.reloadData()
		} else {
			searchActive = true
			let lowercase = searchText.lowercased()
			
			self.getSearchData(lowercase)
			self.users = []

			
			
		}
	}
	
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if searchActive {
		return self.users.count
		}
		else {
			return 0
		}
	}
	
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let user = users[indexPath.row]
		if let cell = SearchTableView.dequeueReusableCell(withIdentifier: "profilecell") as? ProfileCell {
			
			
			cell.configureCell(user)
			return cell
			
		} else {
			
		return UITableViewCell()
		}
	}
	

	
	func getSearchData(_ searchText: String) {
		
		let ref = Firebase(url: "https://ph-watch.firebaseio.com/usernames")
		
		ref.queryOrderedByKey().queryStartingAtValue(searchText).queryEndingAtValue("\(searchText)\u{f8ff}").observeEventType(.ChildAdded, withBlock: { snapshot in
			
			if snapshot != nil {
			
				let value = snapshot.value as! String
				self.users.append(value)
			}
			self.SearchTableView.reloadData()
		})
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "showProfile" {
			let destination = segue.destination as? ProfileVC
			let cell = sender as! ProfileCell
			let selected = SearchTableView.indexPath(for: cell)
			let userkey = users[(selected?.row)!]
			destination!.userKey = userkey
		}
	}
}



//
//  CommentDisplayController.swift
//  LynxStudent
//
//  Created by Yifan Xu on 5/5/17.
//  Copyright © 2017 Yifan & Bhavik. All rights reserved.
//

import Foundation
import UIKit

class CommentDisplayController: UITableViewController
{
    var coupon: Coupon!
    
    var business: Business!
    
    var comments: [String : String] = ["" : ""]
    
    var users = [String]()
    
    var userComments = [String]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        users = [String]()
        userComments = [String]()
        
        users.append(business.name)
        userComments.append(coupon.disc)
        
        for (user, comment) in comments
        {
            if user != business.name
            {
                users.append(user)
            }
            if comment != coupon.disc
            {
                userComments.append(comment)
            }
        }
    }
    
    override func tableView(_: UITableView, numberOfRowsInSection: Int) -> Int
    {
        return comments.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell",
                                                 for: indexPath) as! CommentCell
        cell.userName.text = users[indexPath.row]
        
        cell.commentField.text = userComments[indexPath.row]

        
        return cell
    }
}

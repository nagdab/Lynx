//
//  detailViewController.swift
//  LynxStudent
//
//  Created by Yifan Xu on 4/14/17.
//  Copyright © 2017 Yifan & Bhavik. All rights reserved.
//

import Foundation
import Foundation
import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase
import FBSDKLoginKit
import Cosmos


class DetailViewController: UIViewController
{
    var coupon: Coupon!
    var business: Business!
    
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var businessName: UILabel!
    
    @IBOutlet weak var businessRating: CosmosView!
    
    @IBOutlet weak var discount: UILabel!
    
    @IBOutlet weak var amountLeft: UILabel!
    
    @IBOutlet weak var address: UILabel!
    
    @IBOutlet weak var endDate: UILabel!
    
    @IBOutlet weak var newComment: UITextView!
    
    @IBOutlet weak var newRating: CosmosView!
    
    
    
    // firebase reference to the coupons
    let ref = FIRDatabase.database().reference(withPath: "coupon")
    
    // firebase reference to the businesses
    let businessRef = FIRDatabase.database().reference(withPath: "business")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        businessName.text = business.name
        businessRating.rating = business.overallRating
        businessRating.settings.updateOnTouch = false
        discount.text = "$" + coupon.discount
        amountLeft.text = String(coupon.numbersLeft) + " left"
        address.text = business.address
        endDate.text = dateToString(dateData: coupon.endDate)
        
        let session = URLSession(configuration: .default)
        
        let propicURL = URL(string: business.photoURL)!
        
        let downloadPicTask = session.dataTask(with: propicURL) { (data, response, error) in
            // The download has finished.
            if let e = error
            {
                print("Error downloading cat picture: \(e)")
            }
            else
            {
                // No errors found.
                // It would be weird if we didn't have a response, so check for that too.
                if let imageData = data
                {
                    // Finally convert that Data into an image and do what you wish with it.
                    let image = UIImage(data: imageData)
                    // set the profile picture
                    self.profilePic.image = image
                }
                else
                {
                    print("Couldn't get image: Image is nil")
                }
                
            }
        }

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let commentDisplay = segue.destination as! CommentDisplayController
        commentDisplay.comments = business.comments
        commentDisplay.coupon = coupon
        commentDisplay.business = business
    }
    
    
    @IBAction func submit(_ sender: Any)
    {
        let userComment = newComment.text
        let userRating = newRating.rating
        
        let user = FIRAuth.auth()?.currentUser
        let id = user!.displayName
        
        business.comments[id!] = userComment
        business.rating[user!.uid] = userRating
        
        business.ref!.updateChildValues([
            "rating": business.rating,
            "comments": business.comments
            ])
    }
    

}

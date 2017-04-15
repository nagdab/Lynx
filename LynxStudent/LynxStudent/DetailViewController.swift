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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(coupon.numbersLeft)
        print(business.name)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//
//  CouponCell.Swift
//  LynxStudent
//
//  Created by Yifan Xu on 3/6/17.
//  Copyright © 2017 Yifan & Bhavik. All rights reserved.
//

import Foundation
import UIKit
import Cosmos

class CouponCell: UITableViewCell
{
    
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var businessName: UILabel!
    
    @IBOutlet weak var couponDescription: UILabel!
    
    @IBOutlet weak var numLeft: UILabel!
    
    @IBOutlet weak var endDate: UILabel!
    
    @IBOutlet weak var discount: UILabel!
    
    @IBOutlet weak var ratingView: CosmosView!

    @IBOutlet weak var detailButton: UIButton!
    
    @IBOutlet weak var remainingExpiry: UILabel!
    
    var coupon: Coupon!
    
    var business: Business!
    
    // set up the cell's font and other information. 
    func cellSetUp()
    {
        
   //     let bodyFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        
   //     let captionFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption1)
        
   //     numLeft.font = bodyFont
        
   //     endDate.font = bodyFont
        
   //     businessName.font = captionFont
    }
    
    
    
}

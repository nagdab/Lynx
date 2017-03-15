//
//  CouponCell.Swift
//  LynxStudent
//
//  Created by Yifan Xu on 3/6/17.
//  Copyright © 2017 Yifan & Bhavik. All rights reserved.
//

import Foundation
import UIKit

class CouponCell: UITableViewCell
{
    
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var businessName: UILabel!
    
    @IBOutlet weak var couponDescription: UITextView!
    
    @IBOutlet weak var numLeft: UILabel!
    
    @IBOutlet weak var endDate: UILabel!
    
    // set up the cell's font and other information. 
    func cellSetUp()
    {
        couponDescription.isEditable = false
        
        let bodyFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        
        let captionFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption1)
        
        numLeft.font = bodyFont
        
        endDate.font = bodyFont
        
        businessName.font = captionFont
    }
}

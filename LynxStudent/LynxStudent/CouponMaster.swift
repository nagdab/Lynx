//
//  CouponMaster.swift
//  LynxStudent
//
//  Created by Yifan Xu on 3/5/17.
//  Copyright © 2017 Yifan & Bhavik. All rights reserved.
//

import Foundation

// this class holds data for the tableViewController. This class is also responsible for all the sorting of the data
class CouponMaster
{
    var coupons : [Coupon]
    
    var sortedCoupons : [Coupon]{
        get {
            var result = coupons
            for option in availableOptions.values
            {
                switch option
                {
                    case .twoCoupons(let a):
                        result = result.sorted{a($0, $1)}
                    case .oneCouponOneSet(let a):
                        result = result.sorted{a($0, selected) && (!a($1, selected))}
                }
            }
            return result
        }
    }
    
    var orderedOptions = ["sort by date", "sort by numbers left", "sort by business", "selected coupon always on top"]
    
    var options : [String : couponSorterOptions] = [
        "sort by date" : couponSorterOptions.twoCoupons(sortByDate),
        "sort by numbers left" : couponSorterOptions.twoCoupons(sortByNumber),
        "sort by business" : couponSorterOptions.twoCoupons(sortByBusiness),
        "selected coupon always on top": couponSorterOptions.oneCouponOneSet(sortBySelected)
    ]
    
    var availableOptions = [String : couponSorterOptions]()
    
    var selected = Set<Coupon>()
    
    init()
    {
        self.coupons = [Coupon]()
    }
}

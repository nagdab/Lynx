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
    
    var orderedOptions = ["Sort By Date", "Sort By Numbers Left", "Sort By Business", "Selected Coupon Always On Top"]
    
    var options : [String : couponSorterOptions] = [
        "Sort By Date" : couponSorterOptions.twoCoupons(sortByDate),
        "Sort By Numbers Left" : couponSorterOptions.twoCoupons(sortByNumber),
        "Sort By Business" : couponSorterOptions.twoCoupons(sortByBusiness),
        "Selected Coupon Always On Top": couponSorterOptions.oneCouponOneSet(sortBySelected)
    ]
    
    var availableOptions = [String : couponSorterOptions]()
    
    var selected = Set<Coupon>()
    
    init()
    {
        self.coupons = [Coupon]()
    }
}

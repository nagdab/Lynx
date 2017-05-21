//
//  CouponSorting.swift
//  LynxStudent
//
//  Created by Yifan Xu on 3/14/17.
//  Copyright © 2017 Yifan & Bhavik. All rights reserved.
//

import Foundation


func sortByDate(left: Coupon, right: Coupon) -> Bool
{
    return left.endDate > right.endDate
}

func sortByNumber(left: Coupon, right: Coupon) -> Bool
{
    return left.numbersLeft < right.numbersLeft
}

func sortByBusiness(left: Coupon, right: Coupon) -> Bool
{
    return left.businessID > right.businessID
}

func sortBySelected(coupon: Coupon, collection: Set<Coupon>) -> Bool
{
    return collection.contains(coupon)
}

enum couponSorterOptions
{
    case twoCoupons((Coupon, Coupon)->Bool)
    case oneCouponOneSet((Coupon, Set<Coupon>) -> Bool)
}



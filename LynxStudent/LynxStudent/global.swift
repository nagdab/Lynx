//
//  global.swift
//  LynxApp
//
//  Created by Yifan Xu on 2/22/17.
//  Copyright © 2017 Yifan & Bhavik. All rights reserved.
//

import Foundation

// here are the global functions

func stringToDate(dateString: String)-> Date
{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM dd yyyy hh:mm:ss"
    return dateFormatter.date(from: dateString)!
}

func dateToString(dateData: Date)-> String
{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM dd yyyy hh:mm:ss"
    return dateFormatter.string(from: dateData)
}

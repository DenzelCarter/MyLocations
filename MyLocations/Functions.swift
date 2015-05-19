//
//  Functions.swift
//  MyLocations
//
//  Created by Denzel Carter on 5/18/15.
//  Copyright (c) 2015 BearBrosDevelopment. All rights reserved.
//

import Foundation
import Dispatch


func afterDelay(seconds: Double, closure: () -> ()) {
    let when = dispatch_time(DISPATCH_TIME_NOW,
        Int64(seconds * Double(NSEC_PER_SEC)))
    dispatch_after(when, dispatch_get_main_queue(), closure)
}
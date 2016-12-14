//
//  Double+RoundTo.swift
//  TrackMyTread
//
//  Created by Joshua Schipull on 12/12/16.
//  Copyright © 2016 Joshua Schipull. All rights reserved.
//

import Foundation

extension Double {
    // Round to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

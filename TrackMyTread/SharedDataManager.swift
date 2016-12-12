//
//  SharedDataManager.swift
//  TrackMyTread
//
//  Created by Joshua Schipull on 12/11/16.
//  Copyright © 2016 Joshua Schipull. All rights reserved.
//

import Foundation
import CoreLocation

class SharedDataManager {
    static let sharedInstance = SharedDataManager()
    var sharedElapsedTime: String = ""
    var sharedDistance: String = ""
    var sharedlocationArray: [CLLocationCoordinate2D] = []
}

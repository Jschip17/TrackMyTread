//
//  MainViewController.swift
//  TrackMyTread
//
//  Created by Joshua Schipull on 12/8/16.
//  Copyright © 2016 Joshua Schipull. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MainViewController: UIViewController, CLLocationManagerDelegate {
    
    //Outlets
    @IBOutlet weak var btnShoe: UIButton!
    @IBOutlet weak var btnTire: UIButton!
    @IBOutlet weak var txtTime: UITextField!
    @IBOutlet weak var txtDistance: UITextField!
    @IBOutlet weak var errorBox: UILabel!
    
    //Local
    let clrLime = UIColor(red: 128, green: 255, blue: 0)
    let clrSilver = UIColor(red: 204, green: 204, blue: 204)
    var distanceFilter = 10.0
    var timer = Timer()
    var startTime = TimeInterval()
    var storedElapsedTime = TimeInterval()
    var totalElapsedTime = TimeInterval()
    
    var locationManager: CLLocationManager!
    var locationArray: [CLLocationCoordinate2D] = []
    var lastLocation: CLLocation!
    var storedDistance: CLLocationDistance = 0.0
    var totalDistance: CLLocationDistance = 0.0
    var distanceFormatter = MKDistanceFormatter()
    
    //Actions
    @IBAction func btnShoeClick(_ sender: AnyObject) {
        btnShoe.backgroundColor = clrLime
        btnTire.backgroundColor = clrSilver
        distanceFilter = 10.0
        
        if locationManager != nil {
            locationManager.stopUpdatingLocation()
            locationManager = nil
        }
        timer.invalidate()
        storedElapsedTime = 0.0
        setTimeText(Elapsed: storedElapsedTime)
    }
    
    @IBAction func btnTireClick(_ sender: AnyObject) {
        btnShoe.backgroundColor = clrSilver
        btnTire.backgroundColor = clrLime
        distanceFilter = 20.0
        
        if locationManager != nil {
            locationManager.stopUpdatingLocation()
            locationManager = nil
        }
        timer.invalidate()
        storedElapsedTime = 0.0
        setTimeText(Elapsed: storedElapsedTime)
    }
    
    @IBAction func btnStartClick(_ sender: AnyObject) {
        if !timer.isValid {
            let aSelector : Selector = #selector(MainViewController.updateTime)
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: aSelector,     userInfo: nil, repeats: true)
            startTime = NSDate.timeIntervalSinceReferenceDate
            
            if locationManager == nil {
                locationManager = CLLocationManager()
                locationManager.delegate = self
                locationManager.distanceFilter = distanceFilter
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.requestWhenInUseAuthorization()
            }
            
            lastLocation = locationManager.location
            locationManager.startUpdatingLocation()
        }
    }
    
    @IBAction func btnStopClick(_ sender: AnyObject) {
        storedElapsedTime = totalElapsedTime
        timer.invalidate()
        
        if locationManager != nil {
            locationManager.stopUpdatingLocation()
        }
        
        storedDistance = totalDistance
    }
    
    @IBAction func btnResetClick(_ sender: AnyObject) {
        storedElapsedTime = 0.0
        setTimeText(Elapsed: storedElapsedTime)
        
        storedDistance = 0.0
        setDistanceText(Distance: storedDistance)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setTimeText(Elapsed: storedElapsedTime)
        
        distanceFormatter.units = .imperial
        distanceFormatter.unitStyle = .abbreviated
        
        setDistanceText(Distance: storedDistance)
        
        if (CLLocationManager.locationServicesEnabled() == false) {
            errorBox.text = "Location Disabled"
            errorBox.isHidden = false
        }
    }
    
    func updateTime() {
        let currentTime = NSDate.timeIntervalSinceReferenceDate
        
        //Find the difference between current time and start time.
        let elapsedTime: TimeInterval = currentTime - startTime
        totalElapsedTime = elapsedTime + storedElapsedTime
        
        setTimeText(Elapsed: totalElapsedTime)
    }
    
    func setTimeText(Elapsed : TimeInterval) {
        var elapsedTime: TimeInterval = Elapsed
        
        //calculate the minutes in elapsed time.
        let minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (TimeInterval(minutes) * 60)
        
        //calculate the seconds in elapsed time.
        let seconds = UInt8(elapsedTime)
        elapsedTime -= TimeInterval(seconds)
        
        //find out the fraction of milliseconds to be displayed.
        let fraction = UInt8(elapsedTime * 100)
        
        //add the leading zero for minutes, seconds and millseconds and store them as string constants
        
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strFraction = String(format: "%02d", fraction)
        
        //concatenate minuets, seconds and milliseconds as assign it to the UILabel
        txtTime.text = "\(strMinutes):\(strSeconds):\(strFraction)"
    }
    
    func setDistanceText(Distance : CLLocationDistance) {
        txtDistance.text = distanceFormatter.string(fromDistance: Distance)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location:CLLocation = locations[locations.endIndex-1] as CLLocation
        let distance: CLLocationDistance = location.distance(from: lastLocation)
        totalDistance = distance + storedDistance
        
        setDistanceText(Distance: totalDistance)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        errorBox.text = "failed with error \(error.localizedDescription)"
        errorBox.isHidden = false
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  MapViewController.swift
//  TrackMyTread
//
//  Created by Joshua Schipull on 12/8/16.
//  Copyright © 2016 Joshua Schipull. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var txtMapTime: UITextField!
    @IBOutlet weak var txtMapDistance: UITextField!
    
    var timer: Timer!
    var timerMap: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        mapView.delegate = self
        
        let centerPoint: CLLocationCoordinate2D = SharedDataManager.sharedInstance.sharedlocationArray.last!
        let coordinateSpan = MKCoordinateSpanMake(0.03, 0.03)
        let coordinateRegion = MKCoordinateRegionMake(centerPoint, coordinateSpan)
        
        mapView.setRegion(coordinateRegion, animated: false)
        mapView.regionThatFits(coordinateRegion)
        
        update()
        updateMap()
        
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(MapViewController.update), userInfo: nil, repeats: true)
        self.timerMap = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(MapViewController.updateMap), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func update() {
        txtMapTime.text = SharedDataManager.sharedInstance.sharedElapsedTime
        txtMapDistance.text = SharedDataManager.sharedInstance.sharedDistance
    }
    
    func updateMap() {
        mapView.removeOverlays(mapView.overlays)
        let myPolyline = MKPolyline(coordinates: &SharedDataManager.sharedInstance.sharedlocationArray, count: SharedDataManager.sharedInstance.sharedlocationArray.count)
        mapView.add(myPolyline)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

        let lineView = MKPolylineRenderer(overlay: overlay)
        lineView.strokeColor = UIColor.blue.withAlphaComponent(0.5)
        lineView.lineWidth = 3
            
        return lineView

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

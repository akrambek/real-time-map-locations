//
//  MapKitReceiveViewController.swift
//  TrackerFullMaptoolkit
//
//  Created by Norvan Sahiner on 1/14/15.
//  Copyright (c) 2015 Norvan Sahiner. All rights reserved.
//

import UIKit
import MapKit

class MapKitReceiveViewController: AbstractMapKitViewController {
    
    // MARK: - Properties
    
    var currentPositionMarker = MKPointAnnotation()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        
        // Start Pubnub
        self.startPubnub()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // Edit navigation controller and toolbar
        self.title = "View your friend's commute"
        self.navigationController?.toolbarHidden = true
    }
    
    // MARK: - PubNub Delegate
    
    func pubnubClient(client: PubNub!, didReceiveMessage message: PNMessage!) {
        
        // Extract content from received message
        let receivedMessage = message.message as! [NSString : Double]
        let lng : CLLocationDegrees! = receivedMessage["lng"]
        let lat : CLLocationDegrees! = receivedMessage["lat"]
        let alt : CLLocationDegrees! = receivedMessage["alt"]
        let newLocation2D = CLLocationCoordinate2DMake(lat, lng)
        let newLocation = CLLocation(coordinate: newLocation2D, altitude: alt, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: nil)
        self.locations.append(newLocation)
        self.coordinateList.append(newLocation.coordinate)
        
        // Drawing the line
        self.updateOverlay()
        
        // Focuing on the new postition
        self.updateMapFrame()
        
        // Update Marker Position
        self.updateCurrentPositionMarker(newLocation)
    }
    
    func updateMapFrame() {
        println(self.locations.last!)
        let currentPosition = self.locations.last!
        let latitudeSpan = CLLocationDistance(500)
        let longitudeSpan = latitudeSpan
        let region = MKCoordinateRegionMakeWithDistance(currentPosition.coordinate, latitudeSpan, longitudeSpan)
        println("Position: \(currentPosition.coordinate.longitude) - \(currentPosition.coordinate.latitude)")
        println("Center: \(region.center.longitude) - \(region.center.latitude)")
        println("Deltas: \(region.span.longitudeDelta) - \(region.span.latitudeDelta)")
        self.mapView.setRegion(region, animated: true)
    }
    
    func updateCurrentPositionMarker(currentLocation: CLLocation) {
        self.currentPositionMarker.coordinate = currentLocation.coordinate
        self.mapView.addAnnotation(self.currentPositionMarker)
    }
}
//
//  GmapReceiveViewController.swift
//  TrackerFullMaptoolkit
//
//  Created by Norvan Sahiner on 1/14/15.
//  Copyright (c) 2015 Norvan Sahiner. All rights reserved.
//

import UIKit

class GmapReceiveViewController: AbstractGmapViewController {
    
    // MARK : - Properties
    
    var currentPositionMarker = GMSMarker()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        self.title = "View the commute"
        self.startPubnub()
        self.path = GMSMutablePath(path: path)
    }
    
    // MARK: - PubNub Delegate
    
    func pubnubClient(client: PubNub!, didReceiveMessage message: PNMessage!) {
        
        // Extract content from received message
        let receivedMessage = message.message as! [NSString : Double]
        let lng : CLLocationDegrees! = receivedMessage["lng"]
        let lat : CLLocationDegrees! = receivedMessage["lat"]
        let alt : CLLocationDegrees! = receivedMessage["alt"]
        let newLocation2D = CLLocationCoordinate2DMake(lat, lng)
        let newLocation = CLLocation(coordinate: newLocation2D, altitude: alt, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp:nil)
        self.locations.append(newLocation)
        
        // Initilize the polyline
        if (self.isFirstMessage) {
            self.initializePolylineAnnotation()
            self.isFirstMessage = false
        }
        
        // Drawing the line
        self.updateOverlay(newLocation)
        
        // Update the map frame
        self.updateMapFrame(newLocation, zoom: 17.0)
        
        // Update Marker position
        self.updateCurrentPositionMarker(newLocation)
    }
    
    // MARK: - Map View Editor
    func updateCurrentPositionMarker(currentLocation: CLLocation) {
        self.currentPositionMarker.map = nil
        self.currentPositionMarker = GMSMarker(position: currentLocation.coordinate)
        self.currentPositionMarker.icon = GMSMarker.markerImageWithColor(UIColor.cyanColor())
        self.currentPositionMarker.map = self.mapView
    }
}

////
////  MapBoxReceiveViewController.swift
////  TrackerFullMaptoolkit
////
////  Created by Norvan Sahiner on 1/14/15.
////  Copyright (c) 2015 Norvan Sahiner. All rights reserved.
////
//
//import UIKit
//
//class MapBoxReceiveViewController: AbstractMapBoxViewController {
//    
//    // MARK: - Properties
//    
//    private var currentLocation = CLLocation()
//    private var isFirstMessage = true
//    private var currentPositionAnnotation = RMPointAnnotation()
//    
//    // MARK: - View Life Cycle
//    
//    override func viewDidLoad() {
//        
//        // Start PubNub
//        self.startPubnub()
//    }
//    
//    override func viewWillAppear(animated: Bool) {
//        
//        // Edit navigation controller and toolbar
//        self.title = "View your friend's commute"
//        self.navigationController?.toolbarHidden = true
//    }
//    
//    // MARK: - PubNub Delegate
//    
//    func pubnubClient(client: PubNub!, didReceiveMessage message: PNMessage!) {
//        
//        // Extract content from received message
//        let receivedMessage = message.message as! [NSString : Double]
//        let lng : CLLocationDegrees! = receivedMessage["lng"]
//        let lat : CLLocationDegrees! = receivedMessage["lat"]
//        let alt : CLLocationDegrees! = receivedMessage["alt"]
//        let newLocation2D = CLLocationCoordinate2DMake(lat, lng)
//        self.currentLocation = CLLocation(coordinate: newLocation2D, altitude: alt, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: nil)
//        self.locations.append(self.currentLocation)
//        
//        // Initilize the polyline
//        if (self.isFirstMessage) {
//            self.initializePolylineAnnotation()
//            self.isFirstMessage = false
//        }
//        
//        // Drawing the line
//        self.updateOverlay()
//        
//        // Focuing on the new postition
//        self.updateMapFrame()
//        
//        // Update Marker Position
//        self.updateCurrentPositionMarker()
//    }
//    
//    // MARK: - MapView Editor
//    
//    func updateOverlay() {
//        // Update Polyline annotation and center the frame
//        (self.polylineAnnotation.layer as RMShape).addLineToCoordinate(self.currentLocation.coordinate)
//    }
//    
//    func updateMapFrame() {
//        self.mapView.centerCoordinate = self.currentLocation.coordinate
//    }
//    
//    func updateCurrentPositionMarker() {
//        
//        // Remove position marker if it exists
//        self.mapView.removeAnnotation(self.currentPositionAnnotation)
//        
//        // Update position marker
//        self.currentPositionAnnotation = RMPointAnnotation(mapView: self.mapView, coordinate: self.currentLocation.coordinate, andTitle: nil)
//        self.mapView.addAnnotation(self.currentPositionAnnotation)
//    }
//}
////
////  MapBoxSendViewController.swift
////  TrackerFullMaptoolkit
////
////  Created by Norvan Sahiner on 1/14/15.
////  Copyright (c) 2015 Norvan Sahiner. All rights reserved.
////
//
//import UIKit
//
//class MapBoxSendViewController: AbstractMapBoxViewController, CLLocationManagerDelegate {
//    
//    // MARK: - Properties
//    
//    private var startStopButton = UIBarButtonItem()
//    private let locationManager = CLLocationManager()
//    private var isRecordingActive = Bool()
//    private var filePath = NSString()
//    
//    // MARK: - View Life Cycle
//    
//    override func viewDidLoad() {
//        
//        // Initialize tracking
//        self.mapView.userTrackingMode = RMUserTrackingModeFollowWithHeading
//        self.locationManager.delegate = self
//        self.locationManager.requestAlwaysAuthorization()
//        
//        // Start PubNub
//        self.startPubnub()
//    }
//    
//    override func viewWillAppear(animated: Bool) {
//        
//        // Create the buttons on the toolbar
//        let flexibleItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
//        self.startStopButton = UIBarButtonItem(title: "Start Sharing", style: UIBarButtonItemStyle.Bordered, target: self, action: Selector("startStopButtonToggle"))
//        self.toolbarItems = [ flexibleItem, self.startStopButton, flexibleItem]
//        
//        // Edit navigation
//        self.title = "Share your commute"
//    }
//    
//    override func viewDidAppear(animated: Bool) {
//        
//        // Add the toolbar with animation
//        self.navigationController!.setToolbarHidden(false, animated: true)
//    }
//    
//    // MARK: - Button Delegate
//    
//    func startStopButtonToggle() {
//        self.isRecordingActive = !self.isRecordingActive
//        self.startStopButton.title = self.isRecordingActive ? "Stop Sharing" : "Start Sharing"
//        self.title = self.isRecordingActive ? "Sharing your commute" : "Share your commute"
//        self.isRecordingActive ? self.startRecording(kCLLocationAccuracyBest) : self.locationManager.stopUpdatingLocation()
//    }
//    
//    func startRecording(accuracy: CLLocationAccuracy) {
//        
//        // Initialize the locatioins list
//        self.locations = [CLLocation]()
//        self.locations.append(self.locationManager.location)
//        
//        // Initialize the polyline
//        self.initializePolylineAnnotation()
//        
//        // Setup & start the location manager
//        self.locationManager.desiredAccuracy = accuracy
//        self.locationManager.startUpdatingLocation()
//    }
//    
//    // MARK: - Location Manager Delegate
//    
//    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
//        println("didFailWithError: \(error)")
//        let errorAlert = UIAlertView(title: "Error", message: "Failed to Get Your Location", delegate: nil, cancelButtonTitle: "Ok")
//        errorAlert.show()
//    }
//    
//    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
//        let newLocation : CLLocation = locations.last as! CLLocation
//        println("current position : \(newLocation.coordinate.longitude) , \(newLocation.coordinate.latitude)")
//        self.locations.append(newLocation)
//        
//        // Drawing the line
//        (self.polylineAnnotation.layer as RMShape).addLineToCoordinate(newLocation.coordinate)
//        
//        // Building the kml file, building the message and pushing it
//        let message = "{\"lat\":\(newLocation.coordinate.latitude),\"lng\":\(newLocation.coordinate.longitude), \"alt\": \(newLocation.altitude)}"
//        println(message)
//        PubNub.sendMessage(message, toChannel: self.channel, compressed: true)
//    }
//}
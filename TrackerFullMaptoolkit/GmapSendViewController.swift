//
//  GmapSendViewController.swift
//  TrackerFullMaptoolkit
//
//  Created by Norvan Sahiner on 1/14/15.
//  Copyright (c) 2015 Norvan Sahiner. All rights reserved.
//

import UIKit

class GmapSendViewController: AbstractGmapViewController, CLLocationManagerDelegate {
    
    // MARK: - Properties
    
    private var startStopButton = UIBarButtonItem()
    private let locationManager = CLLocationManager()
    private var isRecordingActive = Bool()
    private var filePath = NSString()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        
        // Set Tracking
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.mapView.myLocationEnabled = true
        
        // Start location manager
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
        
        // Start PubNub
        self.startPubnub()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // Create the buttons on the toolbar
        let flexibleItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        self.startStopButton = UIBarButtonItem(title: "Start Sharing", style: UIBarButtonItemStyle.Bordered, target: self, action: Selector("startStopButtonToggle"))
        self.toolbarItems = [ flexibleItem, self.startStopButton, flexibleItem]
        
        // Edit navigation controller
        self.title = "Share your commute"
    }
    
    override func viewDidAppear(animated: Bool) {
        
        // Add the toolbar with animation
        self.navigationController!.setToolbarHidden(false, animated: true)
    }
    
    // MARK: - Button Delegate
    
    func startStopButtonToggle() {
        self.isRecordingActive = !self.isRecordingActive
        self.startStopButton.title = self.isRecordingActive ? "Stop Sharing" : "Start Sharing"
        self.title = self.isRecordingActive ? "Sharing your commute" : "Share your commute"
        if (self.isRecordingActive) {
            self.startRecording()
        }
    }
    
    func startRecording() {
        
        // Initialize the locations list
        self.locations = [CLLocation]()
        
        // Initialize path
        self.path = GMSMutablePath()
        self.mapView.clear()
    }
    
    // MARK: - Location Manager Delegate
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("didFailWithError: \(error)")
        let errorAlert = UIAlertView(title: "Error", message: "Failed to Get Your Location", delegate: nil, cancelButtonTitle: "OK")
        errorAlert.show()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let newLocation = locations.last as! CLLocation
        
        // Update the map frame
        self.updateMapFrame(newLocation, zoom: 17.0)
        
        if (self.isRecordingActive) {
            println("current position: \(newLocation.coordinate.longitude) , \(newLocation.coordinate.latitude)")
            self.locations.append(newLocation)
            
            // Drawing the line
            self.updateOverlay(newLocation)
            
            // Building the message and pushing it
            let message = "{\"lat\":\(newLocation.coordinate.latitude),\"lng\":\(newLocation.coordinate.longitude), \"alt\": \(newLocation.altitude)}"
            print(message)
            PubNub.sendMessage(message, toChannel: self.channel, compressed: true)
        }
    }
}
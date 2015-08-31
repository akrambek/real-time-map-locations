//
//  AbstractGmapViewController.swift
//  TrackerFullMaptoolkit
//
//  Created by Norvan Sahiner on 1/14/15.
//  Copyright (c) 2015 Norvan Sahiner. All rights reserved.
//

import UIKit

class AbstractGmapViewController: UIViewController, GMSMapViewDelegate, PNDelegate {
    
    // MARK: - Properties
    
    var mapView : GMSMapView!
    var locations = [CLLocation]()
    var channel = PNChannel()
    var path = GMSMutablePath()
    var isFirstMessage = true
    var polyline = GMSPolyline()
    
    // MARK: - Constructors
    
    required init(coder aDecoder: NSCoder) {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(channel:PNChannel) {
        self.channel = channel
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: - View Life Cycle
    
    override func loadView() {
        
        // Building a view
        let screenFrame = UIScreen.mainScreen().applicationFrame
        let contentView = UIView(frame: screenFrame)
        
        // Add Map
        GMSServices.provideAPIKey("AIzaSyA5tyQrE2hw_F15NjrA1qZvU17LZakqNQ8")
        self.mapView = GMSMapView(frame: screenFrame)
        self.mapView.delegate = self
        contentView.addSubview(self.mapView)
        
        // Set the built view as our view
        self.view = contentView
    }
    
    // MARK: - PubNub Configuration & Connection
    
    func startPubnub() {
        let config = PNConfiguration(publishKey: "pub-c-a5a725f6-f6bc-406f-9588-11c8eb6f83a8", subscribeKey: "sub-c-0c557bb2-4f9e-11e5-854b-02ee2ddab7fe", secretKey: nil)
        PubNub.setDelegate(self)
        PubNub.setConfiguration(config)
        PubNub.connect()
        PubNub.subscribeOnChannel(self.channel)
    }
    
    // MARK: - Polyline and Screen Position Updaters
    
    func updateOverlay(currentPosition: CLLocation) {
        self.path.addCoordinate(currentPosition.coordinate)
        self.polyline.path = self.path
    }
    
    func updateMapFrame(newLocation: CLLocation, zoom: Float) {
        let camera = GMSCameraPosition.cameraWithTarget(newLocation.coordinate, zoom: zoom)
        self.mapView.animateToCameraPosition(camera)
    }
    
    func initializePolylineAnnotation() {
        self.polyline.strokeColor = UIColor.blueColor()
        self.polyline.strokeWidth = 5.0
        self.polyline.map = self.mapView
    }
}
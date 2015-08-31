//
//  AbstractMapKitViewController.swift
//  TrackerFullMaptoolkit
//
//  Created by Norvan Sahiner on 1/14/15.
//  Copyright (c) 2015 Norvan Sahiner. All rights reserved.
//

import UIKit
import MapKit

class AbstractMapKitViewController: UIViewController, PNDelegate, MKMapViewDelegate {
    
    // MARK: - Properties
    
    var mapView = MKMapView()
    var channel = PNChannel()
    var locations = [CLLocation]()
    var coordinateList = [CLLocationCoordinate2D]()
    var isFirstMessage = Bool()
    
    // MARK: - Constructors
    
    required init(coder aDecoder: NSCoder) {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(channel:PNChannel) {
        self.channel = channel
        super.init(nibName: nil, bundle: nil)
    }
    
    // Mark: - View Life Cycle
    
    override func loadView() {
        
        // Building a view
        let screenFrame = UIScreen.mainScreen().applicationFrame
        let contentView = UIView(frame: screenFrame)
        
        // Add Map
        self.mapView = MKMapView(frame: screenFrame)
        self.mapView.delegate = self
        contentView.addSubview(self.mapView)
        
        // Set the built view as our view
        self.view = contentView
    }
    
    // MARK: - PubNub Configuration & Connection
    
    func startPubnub() {
        let config = PNConfiguration(publishKey: "demo", subscribeKey: "demo", secretKey: nil)
        PubNub.setDelegate(self)
        PubNub.setConfiguration(config)
        PubNub.connect()
        PubNub.subscribeOnChannel(self.channel)
    }
    
    // MARK: - MapView Editor
    
    func updateOverlay() {
        
        // Build the overlay
        let line = MKPolyline(coordinates: &self.coordinateList, count: self.coordinateList.count)
        // Replace overlay
        if !self.isFirstMessage {
            self.mapView.removeOverlays(self.mapView.overlays)
        }
        
        self.mapView.addOverlay(line)
    }
    
    // MARK: - MapView Delegate
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        let overlayRenderer = MKPolylineRenderer(overlay: overlay)
        overlayRenderer.strokeColor = UIColor.blueColor()
        overlayRenderer.lineWidth = 5.0
        
        return overlayRenderer
    }
}
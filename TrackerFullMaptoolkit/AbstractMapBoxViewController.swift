////
////  AbstractMapBoxViewController.swift
////  TrackerFullMaptoolkit
////
////  Created by Norvan Sahiner on 1/14/15.
////  Copyright (c) 2015 Norvan Sahiner. All rights reserved.
////
//
//import UIKit
//
//class AbstractMapBoxViewController: UIViewController, RMMapViewDelegate, PNDelegate {
//    
//    // MARK: - Properties
//    
//    var mapView = RMMapView()
//    var locations = [CLLocation]()
//    var channel = PNChannel()
//    var polylineAnnotation = RMPolylineAnnotation()
//    
//    // MARK: - Constructors
//    
//    required init(coder aDecoder: NSCoder) {
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    init(channel:PNChannel) {
//        self.channel = channel
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    // MARK: - View Life Cycle
//    
//    override func loadView() {
//        
//        // Building a view
//        let screenFrame = UIScreen.mainScreen().applicationFrame
//        let contentView = UIView(frame: screenFrame)
//        
//        // Add Map
//        let titleSource = RMMapboxSource(mapID: "{Insert Your Map ID}")
//        self.mapView = RMMapView(frame: screenFrame, andTilesource: titleSource)
//        self.mapView.delegate = self
//        contentView.addSubview(self.mapView)
//        
//        // Set the built view as our view
//        self.view = contentView
//    }
//    
//    // MARK: - PubNub configuration & connection
//    
//    func startPubnub() {
//        let config = PNConfiguration(publishKey: "demo", subscribeKey: "demo", secretKey: nil)
//        PubNub.setDelegate(self)
//        PubNub.setConfiguration(config)
//        PubNub.connect()
//        PubNub.subscribeOnChannel(self.channel)
//    }
//    
//    // MARK: - MapView Editor
//    
//    func initializePolylineAnnotation() {
//        self.mapView.removeAllAnnotations()
//        self.polylineAnnotation = RMPolylineAnnotation(mapView: self.mapView, points: self.locations)
//        (self.polylineAnnotation.layer as RMShape).lineColor = UIColor.blueColor()
//        (self.polylineAnnotation.layer as RMShape).lineWidth = 5.0
//        self.mapView.addAnnotation(self.polylineAnnotation)
//    }
//}

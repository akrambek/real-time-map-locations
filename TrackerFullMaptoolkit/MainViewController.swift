//
//  MainViewController.swift
//  TrackerFullMaptoolkit
//
//  Created by Norvan Sahiner on 01/14/15.
//  Copyright (c) 2014 Norvan Sahiner. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    var channel : PNChannel!
    var channelTextField = UITextField()
    var mapSegment = UISegmentedControl()
    
    // MARK: - View Life Cycle
    
    override func loadView() {
        
        // Building a view
        let screenFrame = UIScreen.mainScreen().applicationFrame
        let contentView = UIView(frame: screenFrame)
        
        // Setting the background
        contentView.backgroundColor = UIColor.whiteColor()
        
        // Build the Buttons & labels dimensions and origin
        let buttonWidth : CGFloat = screenFrame.width * 0.6
        let segmentWidth: CGFloat = screenFrame.width * 0.8
        let buttonHeight : CGFloat = screenFrame.height * (1/8)
        let segmentHeight : CGFloat = screenFrame.height * (1/16)
        let titleLabelWidth : CGFloat = screenFrame.width * (3/8)
        let channelLabelWidth : CGFloat = screenFrame.width - titleLabelWidth
        let labelHeight : CGFloat = screenFrame.height * (1/8)
        let xOriginTitleLabel : CGFloat = 0
        let xOriginChannelLabel : CGFloat = xOriginTitleLabel + titleLabelWidth
        let xOrigin : CGFloat = screenFrame.width * 0.2
        let xOriginSegment : CGFloat = screenFrame.width * 0.1
        let yOriginLabel : CGFloat = screenFrame.height * (3/16)
        let yOriginSendButton : CGFloat = screenFrame.height * (6/16)
        let yOriginViewButton : CGFloat = screenFrame.height * (9/16)
        let yOriginMapSegment : CGFloat = screenFrame.height * (12/16)
        
        // Build the frames for the buttons & labels
        let shareButtonFrame = CGRectMake(xOrigin, yOriginSendButton, buttonWidth, buttonHeight)
        let viewButtonFrame = CGRectMake(xOrigin, yOriginViewButton, buttonWidth, buttonHeight)
        let titleLabelFrame = CGRectMake(xOriginTitleLabel, yOriginLabel, titleLabelWidth, labelHeight)
        let channelLabelFrame = CGRectMake(xOriginChannelLabel, yOriginLabel, channelLabelWidth, labelHeight)
        let mapSegmentFrame = CGRectMake(xOriginSegment, yOriginMapSegment, segmentWidth, segmentHeight)
        
        // Create the button & label instances
        let shareButton = UIButton(frame: shareButtonFrame)
        let viewButton = UIButton(frame: viewButtonFrame)
        let titleLabel = UILabel(frame: titleLabelFrame)
        self.channelTextField = UITextField(frame: channelLabelFrame)
        
        // Segmented Control
        let segmentChoice = ["GMaps", "MapKit"]  //"MapBox",
        self.mapSegment = UISegmentedControl(items: segmentChoice)
        self.mapSegment.frame = mapSegmentFrame
        self.mapSegment.selectedSegmentIndex = 1
        self.mapSegment.tintColor = UIColor.blueColor()
        
        // Customize buttons & labels
        shareButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        shareButton.setTitle("Share my location", forState: UIControlState.Normal)
        viewButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        viewButton.setTitle("View friend\'s location", forState: UIControlState.Normal)
        
        titleLabel.text = "Channel : "
        titleLabel.textAlignment = NSTextAlignment.Right
        titleLabel.textColor = UIColor.blackColor()
        
        self.channelTextField.textAlignment = NSTextAlignment.Left
        self.channelTextField.textColor = UIColor.redColor()
        (self.channel == nil) ? (self.channelTextField.placeholder = " Please enter a channel") : (self.channelTextField.text = " \"\(self.channelTextField.text!)\"")
        
        // Wire them to methods
        shareButton.addTarget(self, action: "didTapShareButton", forControlEvents: UIControlEvents.TouchUpInside)
        viewButton.addTarget(self, action: "didTapViewButton", forControlEvents: UIControlEvents.TouchUpInside)
        self.channelTextField.delegate = self
        
        // Add the buttons to the view
        contentView.addSubview(shareButton)
        contentView.addSubview(viewButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(self.mapSegment)
        contentView.addSubview(self.channelTextField)
        
        // Set the built view as the main view
        self.view = contentView
    }
    
    override func viewDidLoad() {
        
        // Add gestures
        let tap = UITapGestureRecognizer(target: self, action: Selector("dismissKeyboard"))
        self.view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // Edit navigation controller
        self.title = "PubNub Location Tracker"
        self.navigationController?.toolbarHidden = true
    }
    
    // MARK: - Keyboard Delegate
    
    func dismissKeyboard() {
        self.channelTextField.resignFirstResponder()
        if (self.channelTextField.text == "" || self.channelTextField.text == nil) {
            return
        }
        self.channel = PNChannel.channelWithName(self.channelTextField.text) as! PNChannel
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.dismissKeyboard()
        return true
    }
    
    // MARK: - Button & Segment Delegate
    
    func didTapShareButton() {
        if (!isChannelValid()) {
            return;
        }
        switch self.mapSegment.selectedSegmentIndex {
        case 0:
            self.navigationController?.pushViewController(GmapSendViewController(channel: self.channel), animated: true)
//        case 1:
//            self.navigationController?.pushViewController(MapBoxSendViewController(channel: self.channel), animated: true)
        case 1:
            self.navigationController?.pushViewController(MapKitSendViewController(channel: self.channel), animated: true)
        default:
            break
        }
    }
    
    func didTapViewButton() {
        if (!isChannelValid()) {
            return;
        }
        switch self.mapSegment.selectedSegmentIndex {
        case 0:
            self.navigationController?.pushViewController(GmapReceiveViewController(channel: self.channel), animated: true)
//        case 1:
//            self.navigationController?.pushViewController(MapBoxReceiveViewController(channel: self.channel), animated: true)
        case 1:
            self.navigationController?.pushViewController(MapKitReceiveViewController(channel: self.channel), animated: true)
        default:
            break
        }
    }
    
    func isChannelValid() -> Bool {
        if (self.channel == nil || self.channelTextField.text == "") {
            let errorAlert = UIAlertView(title: "Error", message: "Please Enter a Valid Channel", delegate: nil, cancelButtonTitle: "Ok")
            errorAlert.show()
            return false
        }
        return true
    }
}

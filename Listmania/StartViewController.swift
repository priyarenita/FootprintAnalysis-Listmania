//
//  StartViewController.swift
//  Listmania
//
//  Created by Renita Priya on 11/19/16.
//  Copyright © 2016 Renita Priya. All rights reserved.
//

import Foundation
import Firebase
import FootprintAnalytics


class StartViewController: UIViewController {
    
     let footprint:FootprintAnalytics = FootprintAnalytics(appName: "iPhone6", view: "StartViewController")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        footprint.addApp()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func getStartedButtonTouched(_ sender: Any) {
        print("started")
        footprint.addTracking(name: "get started button", type: "tap", time: Date())

    }
    
}

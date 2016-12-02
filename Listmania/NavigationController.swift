//
//  NavigationController.swift
//  Listmania
//
//  Created by Renita Priya on 11/19/16.
//  Copyright © 2016 Renita Priya. All rights reserved.
//


import Foundation
import Firebase


class NavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationBar.tintColor = UIColor.white
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
   
}

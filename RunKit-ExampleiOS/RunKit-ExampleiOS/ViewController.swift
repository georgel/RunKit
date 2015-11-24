//
//  ViewController.swift
//  RunKit-ExampleiOS
//
//  Created by baga on 11/24/15.
//  Copyright © 2015 Niteco. All rights reserved.
//

import UIKit
import RunKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Run.background {
            print("Running in \(qos_class_self().description) - expected Background")
            }.main {
                print("Running in \(qos_class_self().description) - expected Main")
            }.userInitiated { () -> Void in
                print("Running in \(qos_class_self().description) - expected UserInitiated")
            }.userInteractive { () -> Void in
                print("Running in \(qos_class_self().description) - expected userInteractive")
            }.utility { () -> Void in
                print("Running in \(qos_class_self().description) - expected utility")
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


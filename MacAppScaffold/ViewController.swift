//
//  ViewController.swift
//  MacAppScaffold
//
//  Created by Howard Oakley on 02/04/2017.
//  Copyright © 2017 EHN & DIJ Oakley. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    // upper text input boxes

    @IBOutlet var textIn1: NSTextField!
    @IBOutlet var textIn2: NSTextField!
    
    // lower text output boxes
    
    @IBOutlet var textOut1: NSTextField!
    @IBOutlet var textScroll1: NSScrollView!
    @IBOutlet var textScrollContent1: NSTextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    // two action buttons, left and right
    
    @IBAction func buttonClick1(_ sender: Any) {
    }

    @IBAction func buttonClick2(_ sender: Any) {
    }
    
}


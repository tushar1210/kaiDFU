//
//  SecondViewController.swift
//  kai
//
//  Created by Tushar Singh on 23/03/19.
//  Copyright © 2019 Tushar Singh. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialProgressView

class SecondViewController: UIViewController {

    @IBOutlet weak var progressView: MDCProgressView!
    var updateTimer:Timer?
    
    
    override func viewDidAppear(_ animated: Bool) {
        kai.downloadFirmware(api:downloadAPI)
        //kai.performDFU()
        startAndShowProgressView()
        updateTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateTheProgressBar), userInfo: nil, repeats: true)
    }
    
    
    
    @objc func updateTheProgressBar() {
        let a:Float = kai.percentageDone / 100.0
        progressView.setProgress(a, animated: true) { (finished) in
            if kai.percentageDone == 100 {
                self.completeAndHideProgressView()
            }
        }
    }
    
    func startAndShowProgressView() {
        progressView.progress = 0
    }
    
    func completeAndHideProgressView() {
        progressView.setProgress(1, animated: true) { (finished) in
            if kai.uploadStatus == "disconnecting" {
                kai.percentageDone = 0
                self.updateTimer?.invalidate()
                self.updateTimer = nil
                if success == true {
                    self.performSegue(withIdentifier: "threeSuccess", sender: nil)
                } else {
                    self.performSegue(withIdentifier: "threeFailure", sender: nil)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.hidesBackButton = true;
        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false;
        //self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false;
    }
}

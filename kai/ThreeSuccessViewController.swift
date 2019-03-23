//
//  ThreeSuccessViewController.swift
//  kai
//
//  Created by Tushar Singh on 23/03/19.
//  Copyright © 2019 Tushar Singh. All rights reserved.
//

import UIKit

class ThreeSuccessViewController: UIViewController {

    @IBAction func finishAction(_ sender: Any) {
        inDFU = false
        success = true
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBOutlet weak var finishButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.hidesBackButton = true;
        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false;
//        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false;
    }
}


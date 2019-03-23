//
//  FirstViewController.swift
//  kai
//
//  Created by Tushar Singh on 23/03/19.
//  Copyright © 2019 Tushar Singh. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var continueButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        kai.setTheDelegate()
        kai.scanForTheKai()
    }
    

    func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func continueAction(_ sender: Any) {
        if inDFU == true {
            self.performSegue(withIdentifier: "two", sender: self)
        } else {
            presentAlert(title: "No Kai Detected", message: "Put the Kai in the DFU mode to update the firmware.")
        }
    }
}

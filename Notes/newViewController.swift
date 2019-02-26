//
//  newViewController.swift
//  Notes
//
//  Created by IMCS2 on 2/14/19.
//  /Users/IMCS2/Library/Autosave Information/Notes/Notes/ArchivedViewController.swiftCopyright © 2019 IMCS2. All rights reserved.
//

import UIKit

class newViewController: UIViewController {
    @IBOutlet weak var input: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let firstVC  = segue.destination as! ViewController
        firstVC.receivedString = input.text!
       // print("ip: \(input.text)")
    }

   

}

//
//  SecondViewController.swift
//  home-security-system
//
//  Created by admin on 5/1/18.
//  Copyright © 2018 Francesca Bueti. All rights reserved.
//

import UIKit
import Alamofire

class SecondViewController: UIViewController, DataEnteredDelegate {
    
    var ip: String!
    func passData(name: String, ip: String) {
        sensorName.text = name
        self.ip = ip
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let firstViewController = segue.destination as! ViewController
        firstViewController.delegate = self
    }
    
    @IBOutlet weak var sensorName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

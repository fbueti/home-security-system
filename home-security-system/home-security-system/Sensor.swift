//
//  Sensor.swift
//  home-security-system
//
//  Created by admin on 4/3/18.
//  Copyright © 2018 Fran and Zach. All rights reserved.
//

import Foundation

class Sensor {
    var name: String
    var ip: String
    
    init(name:String, ip: String){
        self.name = name
        self.ip = ip
    }
    
    public var description: String { return "\(name), \(ip)" }
}

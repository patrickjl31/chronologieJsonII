//
//  Chronologie.swift
//  chronologieJson
//
//  Created by patrick lanneau on 31/01/2018.
//  Copyright © 2018 patrick lanneau. All rights reserved.
//

import UIKit

struct Chronologie: Codable, Equatable {
    static func ==(lhs: Chronologie, rhs: Chronologie) -> Bool {
        return lhs.intitule == rhs.intitule
    }
    
    
    var intitule:String = ""
    var typeLongTerme:Bool = true
    var mesEvenements:[Evenement] = []
    
    

}

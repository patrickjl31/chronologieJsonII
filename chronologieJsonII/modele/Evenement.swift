//
//  Evenement.swift
//  chronologieJson
//
//  Created by patrick lanneau on 31/01/2018.
//  Copyright © 2018 patrick lanneau. All rights reserved.
//

import UIKit

class Evenement: Codable, Equatable {
    static func ==(lhs: Evenement, rhs: Evenement) -> Bool {
        return lhs.id == rhs.id
    }
    
    var intitule:String = ""
    //un identificateur unique généré automatiquement
    var id:Int = Int(Date().timeIntervalSince1970)
    var commentaire:String = ""
    var dateDeb:Date = Date()
    var dateFin:Date = Date()
    var ponctuel:Bool = true
    var typeLongTerme:Bool = true
    
    func setValues(titre : String, comment:String, dDeb:Date, dFin:Date, ponct:Bool, lgTerme:Bool) {
        self.intitule = titre
        self.commentaire = comment
        self.dateDeb = dDeb
        self.dateFin = dFin
        self.ponctuel = ponct
        self.typeLongTerme = lgTerme
    }

}

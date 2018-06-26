//
//  Alerte.swift
//  chronologies
//
//  Created by patrick lanneau on 25/06/2018.
//  Copyright © 2018 patrick lanneau. All rights reserved.
//

import UIKit

class Alerte {
    
    static let shared = Alerte()
    
    func erreur(message: String, controller: UIViewController) {
        let unTitre = NSLocalizedString("Error", comment: "erreur")
        messageSimple(titre:unTitre, message: message, controller: controller)
    }
    
    
    
    func messageSimple(titre: String, message: String, controller: UIViewController) {
        let alerte = UIAlertController(title: titre, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alerte.addAction(ok)
        controller.present(alerte, animated: true, completion: nil)
    }
    
}

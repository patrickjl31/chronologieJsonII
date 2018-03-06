//
//  friseViewController.swift
//  chronologieJson
//
//  Created by patrick lanneau on 31/01/2018.
//  Copyright © 2018 patrick lanneau. All rights reserved.
//

import UIKit

class FriseViewController: UIViewController {
    
    public var lesChronos: GestionChronologie?
    public var laChrono: [Evenement]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
     */
     
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ponctuels" {
            let vc = segue.destination as! VueEvtPonctuelsViewController
            vc.mesChronos = lesChronos
            
        }
    }
    
    // gérer l'affichage des postit des événements
    /*
    @objc func handleTap(_ sender: Any) {
        print("Hello World")
        
        let vc = PostItViewController()
        vc.comment.text = (sender as! EvenementBoxView).commentaire
        vc.commentaire = (sender as! EvenementBoxView).commentaire
        vc.modalPresentationStyle = .popover
        vc.popoverPresentationController?.delegate = self as! UIPopoverPresentationControllerDelegate
        vc.popoverPresentationController?.sourceView = sender as! EvenementBoxView
        self.present(vc, animated: true, completion: nil)
        
        /*
         present(vc, animated: true, completion: nil)
         vc.popoverPresentationController?.sourceView = view
         vc.popoverPresentationController?.sourceRect = sender.frame
         */
        
    }
    */

}

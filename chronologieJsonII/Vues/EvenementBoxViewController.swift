//
//  EvenementBoxViewController.swift
//  chronologieJsonII
//
//  Created by patrick lanneau on 06/03/2018.
//  Copyright © 2018 patrick lanneau. All rights reserved.
//

import UIKit

class EvenementBoxViewController: UIViewController {
    var ui_leNom = UILabel()
    var ui_date = UILabel()
    var commentaire: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func  addLabels()  {
        self.view.backgroundColor = UIColor.cyan
        self.view.layer.cornerRadius = CGFloat(5)
        self.view.layer.borderWidth = 2.0
        self.view.layer.borderColor = UIColor.gray.cgColor
        
        ui_leNom.frame = CGRect(x: 5, y: 5, width: self.view.frame.width - 10, height: 40)
        ui_leNom.backgroundColor = UIColor.white
        ui_leNom.textAlignment = NSTextAlignment.center
        
        ui_leNom.text = "Evenement"
        ui_leNom.adjustsFontSizeToFitWidth = true
        ui_leNom.numberOfLines = 2
        self.view.addSubview(ui_leNom)
        
        ui_date.frame = CGRect(x: 5, y: 50, width: self.view.frame.width - 10, height: 21)
        ui_date.backgroundColor = UIColor.white
        ui_date.textAlignment = NSTextAlignment.center
        ui_date.text = "Date"
        ui_date.adjustsFontSizeToFitWidth = true
        self.view.addSubview(ui_date)
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        
        
        self.view.addGestureRecognizer(tap)
        
        self.view.isUserInteractionEnabled = true
        
        //self.addSubview(view)
        
        
    }
    
    // function which is triggered when handleTap is called
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        print("Hello World")
        //let detailEvtCntroller = UIStoryboard.
        //let vc:detailEvenementViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailEvenementVC") as! detailEvenementViewController
        //self.p
        //let vc = mainStoryboard.instantiateViewController(withIdentifier: "DetailEvenementVC")
        //self.showViewController(vc as! detailEvenementViewController, sender: self)
        let vc = PostItViewController()
        vc.comment.text = commentaire
        vc.commentaire = commentaire
        vc.modalPresentationStyle = .popover
        present(vc, animated: true, completion: nil)
        vc.popoverPresentationController?.sourceView = view
        vc.popoverPresentationController?.sourceRect = sender.view!.frame
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

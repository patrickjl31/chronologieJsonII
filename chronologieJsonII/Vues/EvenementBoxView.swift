//
//  EvenementBoxView.swift
//  chronologieJson
//
//  Created by patrick lanneau on 31/01/2018.
//  Copyright © 2018 patrick lanneau. All rights reserved.
//

import UIKit

class EvenementBoxView: UIView {
    var ui_leNom = UILabel()
    var ui_date = UILabel()
    var commentaire: String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addLabels()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func  addLabels()  {
        self.backgroundColor = UIColor.cyan
        self.layer.cornerRadius = CGFloat(5)
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.gray.cgColor
        
        ui_leNom.frame = CGRect(x: 5, y: 5, width: self.frame.width - 10, height: 40)
        ui_leNom.backgroundColor = UIColor.white
        ui_leNom.textAlignment = NSTextAlignment.center
        
        ui_leNom.text = "Evenement"
        ui_leNom.adjustsFontSizeToFitWidth = true
        ui_leNom.numberOfLines = 2
        self.addSubview(ui_leNom)
        
        ui_date.frame = CGRect(x: 5, y: 50, width: self.frame.width - 10, height: 21)
        ui_date.backgroundColor = UIColor.white
        ui_date.textAlignment = NSTextAlignment.center
        ui_date.text = "Date"
        ui_date.adjustsFontSizeToFitWidth = true
        self.addSubview(ui_date)
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        
        
        self.addGestureRecognizer(tap)
        
        self.isUserInteractionEnabled = true
        
        //self.addSubview(view)
        
        
    }
    
    // function which is triggered when handleTap is called
    /*   */
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
        /*
        present(vc, animated: true, completion: nil)
        vc.popoverPresentationController?.sourceView = view
        vc.popoverPresentationController?.sourceRect = sender.frame
 
   */
    }
 

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}


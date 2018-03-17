//
//  LongPeriodBoxView.swift
//  chronologieJsonII
//
//  Created by patrick lanneau on 13/03/2018.
//  Copyright © 2018 patrick lanneau. All rights reserved.
//

import UIKit

class LongPeriodBoxView: UIView {
    var ui_leNom = UILabel()
    var ui_date = UILabel()
    var commentaire: String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //autoresizesSubviews = true
        //sizeToFit()
        addLabels()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func  addLabels()  {
        self.backgroundColor = UIColor(red: 150 / 255, green: 210 / 255, blue: 210 / 255, alpha: 0.5)//UIColor.cyan.withAlphaComponent(0.5)
        //backgroundColor = UIColor(red: 150, green: 210, blue: 210, alpha: 1)//UIColor.cyan.withAlphaComponent(0.5)
        self.layer.cornerRadius = CGFloat(5)
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.lightGray.cgColor
        
        //ui_leNom.frame = CGRect(x: 5, y: 5, width: self.frame.width - 10, height: 40)
        ui_leNom.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        ui_leNom.textAlignment = NSTextAlignment.center
        ui_leNom.textColor = UIColor.black
        
        ui_leNom.text = "Evenement"
        ui_leNom.adjustsFontSizeToFitWidth = true
        ui_leNom.numberOfLines = 2
        self.addSubview(ui_leNom)
        
        //ui_date.frame = CGRect(x: 5, y: 50, width: self.frame.width - 10, height: 21)
        ui_date.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        ui_date.textAlignment = NSTextAlignment.center
        ui_date.textColor = UIColor.black
        ui_date.text = "Date"
        ui_date.adjustsFontSizeToFitWidth = true
        self.addSubview(ui_date)
        
        
    }
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

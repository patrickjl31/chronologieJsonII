//
//  PostItViewController.swift
//  chronologieJsonII
//
//  Created by patrick lanneau on 05/03/2018.
//  Copyright © 2018 patrick lanneau. All rights reserved.
//

import UIKit

class PostItViewController: UIViewController {
    
    var commentaire: String = ""
    //var comment = UILabel()
    @IBOutlet weak var comment: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //addLabels()
        comment.text = commentaire
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func quitter(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func  addLabels()  {
        //self.view.backgroundColor = UIColor.yellow
        //self.view.layer.cornerRadius = CGFloat(5)
        self.view.layer.borderWidth = 1.0
        self.view.layer.borderColor = UIColor.gray.cgColor
        
        //comment.frame = CGRect(x: 5, y: 5, width: self.view.frame.width - 10, height: self.view.frame.width - 40)
        //comment.backgroundColor = UIColor.black 
        //self.view.addSubview(comment)
      
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

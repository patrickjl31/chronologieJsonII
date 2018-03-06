//
//  VueEvenements.swift
//  chronologieJson
//
//  Created by patrick lanneau on 31/01/2018.
//  Copyright © 2018 patrick lanneau. All rights reserved.
//



// La vue en haut de la vue frise où sont affichés les événements.

import UIKit

class VueEvenements: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    // La taille des boites evenement
    let L_EVT: CGFloat = 100.0
    let H_EVT: CGFloat = 80.0
    
    // marge basse
    let MARGE_BASSE:CGFloat = 20
    
    
    
    // Un stock de vues déjà créées
    //var evenementViewsFree: [EvenementView] = []
    var evenementViewsFree: [EvenementBoxView] = []
    
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        let context = UIGraphicsGetCurrentContext()
        //context!.saveGState()
        //        context?.setLineWidth(2.0)
        //        context?.setStrokeColor(UIColor.blue.cgColor)
        //        context?.move(to: CGPoint(x: 30, y: 30))
        //        context?.addLine(to: CGPoint(x: 300, y: 400))
        //        context?.strokePath()
        
        //UIGraphicsEndImageContext()
        //context!.restoreGState()
        // Quelques constantes de la vue
        // Longueur et hauteur de la vue
        let LView = rect.width
        let HView = rect.height
        // On positionne les vues evenement par leur centre
        let DebUtile: CGFloat = L_EVT / 2
        let Milieu:CGFloat = LView / 2
        let FinUtile: CGFloat = LView - L_EVT
        // la zone de positionnement possible de centres des boxes
        let zoneCentrale = LView - L_EVT
        let Niveau1: CGFloat = HView - (H_EVT / 2) - MARGE_BASSE
        // Nombre de boites à afficher
        let nombreEvenements = 5//GlobalVariables.chronologieCourante.listeEvenements.count
        
        
        if nombreEvenements > 0 {
            // On crée les vues manquantes éventuellement
            updateNumberEvenementViews(upTo: nombreEvenements)
            
            // On met à jour le contenu des boites et on calcule leur position
            if nombreEvenements < 2 {
                
                //self.evenementViewsFree[0].ui_date.text = "\(GlobalVariables.chronologieCourante.listeEvenements [0].date)"
                //self.evenementViewsFree[0].ui_date.text = dateAffichable(date: GlobalVariables.chronologieCourante.listeEvenements [0].date)
                //self.evenementViewsFree[0].ui_leNom.text = GlobalVariables.chronologieCourante.listeEvenements[0].intitule
                self.evenementViewsFree[0].center = CGPoint(x: Milieu, y: Niveau1)
                
                // On relie la boite à la flèche
                // Onrécupère un contexte graphique et des paramètres
                let context = UIGraphicsGetCurrentContext()
                context?.setLineWidth(2.0)
                context?.setStrokeColor(UIColor.blue.cgColor)
                //context?.move(to: CGPoint(x: Milieu, y: (HView - MARGE_BASSE)))
                //context?.addLine(to: CGPoint(x: Milieu, y: HView))
                context?.move(to: CGPoint(x: Milieu, y: (HView - MARGE_BASSE)))
                context?.addLine(to: CGPoint(x: Milieu, y: HView))
                context?.strokePath()
                //UIGraphicsEndImageContext()
                
                
            } else {
                // On calcule les limites temporelles de la liste
                //let firstDate = GlobalVariables.chronologieCourante.listeEvenements[0].date
                //let lastDate = GlobalVariables.chronologieCourante.listeEvenements.last?.date
                //let ecartDate = lastDate?.timeIntervalSince(firstDate)
                
                // On place chaque boite
                for i in 0..<nombreEvenements{
                    //self.evenementViewsFree[i].ui_date.text = "\(GlobalVariables.chronologieCourante.listeEvenements [i].date)"
                    //self.evenementViewsFree[i].ui_date.text = dateAffichable(date: GlobalVariables.chronologieCourante.listeEvenements [i].date)
                    //self.evenementViewsFree[i].ui_leNom.text = GlobalVariables.chronologieCourante.listeEvenements[i].intitule
                    //let distanceEvenementFromFirstEvenement = GlobalVariables.chronologieCourante.listeEvenements [i].date.timeIntervalSince(firstDate)
                    // On positionne
                    let position = 100// Double(zoneCentrale) / ecartDate! * 1//distanceEvenementFromFirstEvenement
                    let posX = CGFloat(position * i) + DebUtile
                    // On positionne la vue par son centre
                    self.evenementViewsFree[i].center = CGPoint(x: posX, y: Niveau1)
                    // On attache l'événement à la flèche des temps
                    // sur le centre, y de centre - hauteur à HView
                    //// Onrécupère un contexte graphique et des paramètres
                    let context = UIGraphicsGetCurrentContext()
                    context?.setLineWidth(2.0)
                    context?.setStrokeColor(UIColor.blue.cgColor)
                    context?.move(to: CGPoint(x: posX, y: (HView - MARGE_BASSE)))
                    context?.addLine(to: CGPoint(x: posX, y: HView))
                    //context?.move(to: CGPoint(x: 30 + (i * 10), y: 30))
                    //context?.addLine(to: CGPoint(x: 300, y: 400))
                    
                    context?.strokePath()
                    //UIGraphicsEndImageContext()
                    //self.view = UIGraphicsGetImageFromCurrentImageContext()
                    //imageView.alpha = opacity
                    // UIGraphicsEndImageContext()
                    
                }
            }
            
            // On montre les boites
            for i in 0 ..< nombreEvenements {
                evenementViewsFree[i].isHidden = false
            }
            
            //context?.strokePath()
            // UIGraphicsEndImageContext()
        }
    }
    
    // Des utilitaires
    func updateNumberEvenementViews(upTo:Int) {
        let nombreEvenements = upTo//GlobalVariables.chronologieCourante.listeEvenements.count
        let tailleEvenementViewsFree = evenementViewsFree.count
        if  nombreEvenements > tailleEvenementViewsFree {
            for i in tailleEvenementViewsFree ..< nombreEvenements {
                let nouvelleVue = EvenementBoxView(frame: CGRect(x: 0, y: 0, width: L_EVT, height: H_EVT))
                self.evenementViewsFree.append(nouvelleVue)
                // on l'ajoute à la view
                self.addSubview(self.evenementViewsFree[i])
            }
        }
        //On cache tout
        for i in 0 ..< evenementViewsFree.count {
            evenementViewsFree[i].isHidden = true
        }
    }
    
    func dateAffichable(date: Date) -> String {
        let dateformater = DateFormatter()
        dateformater.dateFormat = "dd/MM/yyyy"
        dateformater.dateStyle = .full
        return dateformater.string(from: date)
    }
    


}

//
//  VueEvtPonctuelsViewController.swift
//  chronologieJson
//
//  Created by patrick lanneau on 03/02/2018.
//  Copyright © 2018 patrick lanneau. All rights reserved.
//

import UIKit

struct Box {
    var box:EvenementBoxView
    //var box : EvenementBoxViewController
    var ligne:UIView
}

class VueEvtPonctuelsViewController: UIViewController {
    
    // Les variables transférées
    // MaChrono a déjà été filtrée
    public var mesChronos: GestionChronologie?
    
    private var chronoCourante: Chronologie?
    // Les événements de la chronologie courante
    private var vraiChronoCourante: [Evenement] = []
    private var titre:String = ""
    
    // La taille des boites evenement
    let L_EVT: CGFloat = 100.0
    let H_EVT: CGFloat = 80.0
    
    // marge basse
    let MARGE_BASSE:CGFloat = 20
    
    
    
    // Un stock de vues déjà créées
    //var evenementViewsFree: [EvenementBoxView] = []
    var evenementViewsFree:[Box] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // On vérifie que l'on possède les données
        if let index = mesChronos?.indexChronoCourante {
            if index > -1 {
                chronoCourante = mesChronos?.lesChronologies[index]
                titre = (chronoCourante?.intitule)!
                vraiChronoCourante = (chronoCourante?.mesEvenements)!
                // On extrait les evenements ponctuels
                let listeEvtPonctuels = listeEvenementsPonctuels(listeG: vraiChronoCourante)
                // On vérifie qu'il y a des evenements
                if listeEvtPonctuels.count > 0 {
                    // Test
                    affichageTitres(liste: listeEvtPonctuels)
                    // On prépare les boites d'affichage
                    updateNumberEvenementViews(upTo: listeEvtPonctuels.count)
                    // On affiche au moins 1 evenement
                    afficherBoxes(listeEvt: listeEvtPonctuels)
                    
                }
            }
        }
        // dessine()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Lister les evenements ponctuels
    func listeEvenementsPonctuels(listeG:[Evenement]) -> [Evenement] {
        var result: [Evenement] = []
        for unEvenement in listeG {
            if unEvenement.ponctuel {
                result.append(unEvenement)
            }
        }
        result.sort(by: {$0.dateDeb < $1.dateDeb})
        return result
    }
    // Pour vérification
    func affichageTitres(liste:[Evenement]){
        for evt in liste{
            print("\(evt.intitule)")
        }
    }
    
    // Afficher les box des evenements
    func afficherBoxes(listeEvt:[Evenement]){
        // Longueur et hauteur de la vue
        let LView = self.view.frame.width
        let HView:CGFloat = self.view.frame.height
        // On positionne les vues evenement par leur centre
        let DebUtile: CGFloat = (L_EVT / 2) + 10 //L_EVT / 2
        let Milieu:CGFloat = LView / 2
        let FinUtile: CGFloat = LView - (L_EVT / 2) - 10
        let Niveau1: CGFloat = HView - (H_EVT / 2) - MARGE_BASSE
        let basNiveau1:CGFloat = HView - MARGE_BASSE
        // Calculer l'amplitude chronologique des evénements
        
        // On prépare les boites d'affichage si ce n'est fait avant
        //updateNumberEvenementViews(upTo: listeEvt.count)
        // Un evt, on le place au milieu
        if listeEvt.count == 1 {
            affiche1Box(unEvt: listeEvt[0], dansBox: evenementViewsFree[0], xEvt: Milieu, yEvt: Niveau1, yBase: basNiveau1, yArr: HView)
        } else {
            // 2 evenements, on les place aux é extrémités
            // On affiche le premier
            //print("\(listeEvt.count) elements à afficher")
            affiche1Box(unEvt: listeEvt[0], dansBox: evenementViewsFree[0], xEvt: DebUtile, yEvt: Niveau1, yBase: basNiveau1, yArr: HView)
            // On prépare de l'information pour déterminer l'étage d'affichage des boxes
            //Niveau stoke les valeurs de y en pixel selon le niveau
            // Y est la position du centre de la box
            let HAUTEUR_LEVEL: CGFloat = H_EVT + 20
            let Niveau = [Niveau1, Niveau1 - HAUTEUR_LEVEL, Niveau1 - (HAUTEUR_LEVEL * 2), Niveau1 - (HAUTEUR_LEVEL * 3)]
            // On mémorise la position (X) la plus avancée à chaque étage
            var lastLocationByLevel:[CGFloat] = [DebUtile,-200,-200,-200]
            // curLevel permet de balayer les niveaux
            var curLevel = 0
            
            if listeEvt.count > 2 {
                //Il y en a plus de 2
                //affiche1Box(unEvt: listeEvt[0], dansBox: evenementViewsFree[0], xEvt: DebUtile, yEvt: Niveau1, yBase: basNiveau1, yArr: HView)
                //affiche1Box(unEvt: listeEvt[1], dansBox: evenementViewsFree[1], xEvt: FinUtile, yEvt: Niveau1, yBase: basNiveau1, yArr: HView)
                //Il y en a plus de 2 on va calculer les places dans une boucle
                let amplitudeTemps = Double(listeEvt.last!.dateDeb.timeIntervalSince1970) - Double(listeEvt.first!.dateDeb.timeIntervalSince1970)
                let amplitudeFrise = FinUtile - DebUtile
                let rapportTempsFrise = amplitudeTemps / Double(amplitudeFrise)
                let debTemps = listeEvt[0].dateDeb.timeIntervalSince1970
                // Pour calculer l'étage d'affichage de la boite
                // Nombre d'étages pour les boites
                let MAX_LEVEL = 3
                
                for laBox in 1..<(listeEvt.count - 1) {
                    let posX = (CGFloat((listeEvt[laBox].dateDeb.timeIntervalSince1970 - debTemps ) / amplitudeTemps) * amplitudeFrise) + DebUtile
                    /*
                    // On calcule l'étage de positionnement de la boite en fonction des précédentes
                    // On utilise les paramètres et variables définis plus haut
                    // Variables de service
                    var fini = false
                    var optimalLevel = 0
                    var distance:CGFloat = 0
                    var distanceMax:CGFloat = 0
                    repeat {
                        distance = posX - lastLocationByLevel[curLevel]
                        if distance > L_EVT {
                            fini = true
                        } else {
                            if distanceMax < distance {
                                distanceMax = distance
                                optimalLevel = curLevel
                            }
                            curLevel += 1
                            if curLevel > MAX_LEVEL {
                                fini = true
                                curLevel = optimalLevel
                            }
                        }
                    } while !fini
                    print("courant : \(curLevel), optimal: \(optimalLevel)")
                    */
                    let calculNiveau = calculerNiveau(posX: posX, lastLocationByLevel: lastLocationByLevel, DebUtile: DebUtile)
                    lastLocationByLevel[calculNiveau] = posX
                    //affiche1Box(unEvt: listeEvt[laBox], dansBox: evenementViewsFree[laBox], xEvt: posX, yEvt: Niveau1, yBase: basNiveau1, yArr: HView)
                    
                    
                    affiche1Box(unEvt: listeEvt[laBox], dansBox: evenementViewsFree[laBox], xEvt: posX, yEvt: Niveau[calculNiveau], yBase: Niveau[calculNiveau], yArr: HView)
                }
            // On affiche le dernier
            affiche1Box(unEvt: listeEvt.last!, dansBox: evenementViewsFree[listeEvt.count - 1], xEvt: FinUtile, yEvt: Niveau1, yBase: basNiveau1, yArr: HView)
                
            }
        }
        
    }
    
    func calculerNiveau(posX: CGFloat, lastLocationByLevel:[CGFloat], DebUtile:CGFloat ) -> Int {
        var niveau = 0
        // Pour calculer l'étage d'affichage de la boite
        // Nombre d'étages pour les boites
        let MAX_LEVEL = 3
        let HView:CGFloat = self.view.frame.height
        let Niveau1: CGFloat = HView - (H_EVT / 2) - MARGE_BASSE
        //Niveau stoke les valeurs de y en pixel selon le niveau
        // Y est la position du centre de la box
        let HAUTEUR_LEVEL: CGFloat = H_EVT + 20
        let Niveau = [Niveau1, Niveau1 + HAUTEUR_LEVEL, Niveau1 + (HAUTEUR_LEVEL * 2), Niveau1 + (HAUTEUR_LEVEL * 3)]
        // On mémorise la position (X) la plus avancée à chaque étage
        //var lastLocationByLevel:[CGFloat] = [DebUtile,-200,-200,-200]
        // Ces valeurs sont tenues à jour et gérées par l'appelant
        // curLevel permet de balayer les niveaux
        var curLevel = 0
        // Variables de service
        var fini = false
        var optimalLevel = 0
        var distance:CGFloat = 0
        var distanceMax:CGFloat = 0
        repeat {
            distance = posX - lastLocationByLevel[curLevel]
            if distance > L_EVT {
                fini = true
            } else {
                if distanceMax < distance {
                    distanceMax = distance
                    optimalLevel = curLevel
                }
                curLevel += 1
                if curLevel > MAX_LEVEL {
                    fini = true
                    curLevel = optimalLevel
                }
            }
        } while !fini
        print("fonction externe : courant : \(curLevel), optimal: \(optimalLevel)")
        niveau = curLevel
        return niveau
    }
    
    // Affiche une boite et son lien à la base de la vue (flèche du temps)
    // reçoit l'évenement, la boite créée pour lui, les coordonnées du centre de la boite
    // le point haut et le point bas de la ligne
    func affiche1Box(unEvt:Evenement,dansBox:Box, xEvt:CGFloat, yEvt:CGFloat, yBase:CGFloat, yArr:CGFloat) {
        // On met à jour les champs de la boite
        dansBox.box.ui_leNom.text = unEvt.intitule
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-YYYY"
        dansBox.box.ui_date.text = "\(formatter.string(from: unEvt.dateDeb))"
        dansBox.box.commentaire = unEvt.commentaire
        dansBox.box.center = CGPoint(x: xEvt, y: yEvt)
        dansBox.ligne.frame = CGRect(x: xEvt-1, y: yBase, width: 3, height: yArr - yBase)
        dansBox.box.isHidden = false
        dansBox.ligne.isHidden = false
        // Trace
        print("\(formatter.string(from: unEvt.dateDeb)) : \(unEvt.intitule), en \(xEvt)")
    }

    // Test graphique
    func dessine(){
        // On vérifie que l'on dispose d'une chronologie
        
        
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
        let LView = self.view.frame.width
        let HView:CGFloat = self.view.frame.height
        // On positionne les vues evenement par leur centre
        let DebUtile: CGFloat = L_EVT / 2
        let Milieu:CGFloat = LView / 2
        let FinUtile: CGFloat = LView - L_EVT
        // la zone de positionnement possible de centres des boxes
        let zoneCentrale = LView - L_EVT
        let Niveau1: CGFloat = HView - (H_EVT / 2) - MARGE_BASSE
        let basNiveau1:CGFloat = HView - MARGE_BASSE
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
                self.evenementViewsFree[0].box.center = CGPoint(x: Milieu, y: Niveau1)
                
                // On relie la boite à la flèche
                // Onrécupère un contexte graphique et des paramètres
                dessineLiaisonDepuis(posX: Milieu, yDep: basNiveau1, yArr: HView)
                
                //context?.move(to: CGPoint(x: 30 + (i * 10), y: 30))
                //context?.addLine(to: CGPoint(x: 300, y: 400))
                
                
                
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
                    let posX = CGFloat((position + 20) * i) + DebUtile
                    // On positionne la vue par son centre
                    self.evenementViewsFree[i].box.center = CGPoint(x: posX, y: Niveau1)
                    // Trace
                    //print("box \(i) : \(Niveau1)")
                    // On attache l'événement à la flèche des temps
                    // sur le centre, y de centre - hauteur à HView
                    self.evenementViewsFree[i].ligne.frame = CGRect(x: posX - 1, y: basNiveau1, width: 2, height: HView)
                    //dessineLiaisonDepuis(posX: posX, yDep: basNiveau1, yArr: HView)
            
                    //context?.move(to: CGPoint(x: 30 + (i * 10), y: 30))
                    //context?.addLine(to: CGPoint(x: 300, y: 400))
                    
                    //imageView.alpha = opacity
                    // UIGraphicsEndImageContext()
                    
                    // On met à jour le contenu de la boite
                    self.evenementViewsFree[i].box.ui_leNom.text = "Il s'agit de l'événement \(i) "
                    self.evenementViewsFree[i].box.ui_date.text = "sur \(vraiChronoCourante.count)"
                    
                }
            }
            
            // On montre les boites
            for i in 0 ..< nombreEvenements {
                evenementViewsFree[i].box.isHidden = false
                 evenementViewsFree[i].ligne.isHidden = false
            }
            
            //context?.strokePath()
            // UIGraphicsEndImageContext()
        }
    }
    // Dessin des liaisons graphiques entre la box et la flèche
    func dessineLiaisonDepuis(posX : CGFloat, yDep:CGFloat, yArr:CGFloat) {
        UIGraphicsBeginImageContext(self.view.frame.size)
        if let context = UIGraphicsGetCurrentContext() {
            context.setLineWidth(4)
            context.setStrokeColor(UIColor.black.cgColor)
            context.setFillColor(UIColor.black.cgColor)
            context.move(to: CGPoint(x: posX, y: yDep))  //(HView - MARGE_BASSE)
            context.addLine(to: CGPoint(x: posX, y: yArr))
            context.strokePath()
            //print("vu")
        }
        let line = UIView(frame: CGRect(x: posX-1, y: yDep, width: 2, height: yArr - yDep))
        line.backgroundColor = UIColor.black
        self.view.addSubview(line)
        
        /* Added
        UIColor.black.setFill()
        UIColor.black.setStroke()
        let graphPath = UIBezierPath()
        graphPath.move(to: CGPoint(x: posX, y: yDep))
        graphPath.addLine(to: CGPoint(x: posX, y: yArr))
        graphPath.lineWidth = 4
        graphPath.stroke()
       */
        
        
        //print("\(yDep) to \(yArr)")
    }
    
    // Des utilitaires
    func updateNumberEvenementViews(upTo:Int) {
        let nombreEvenements = upTo//GlobalVariables.chronologieCourante.listeEvenements.count
        let tailleEvenementViewsFree = evenementViewsFree.count
        
        if  nombreEvenements > tailleEvenementViewsFree {
            
            for i in tailleEvenementViewsFree ..< nombreEvenements {
                let nouvelleVue = EvenementBoxView(frame: CGRect(x: 0, y: 0, width: L_EVT, height: H_EVT))
                let nouvelleLigne = UIView(frame: CGRect(x: 0, y: 0, width: 2, height: 10))
                nouvelleLigne.backgroundColor = UIColor.black
                //nouvelleLigne.layer.borderWidth = 2.0
                //nouvelleLigne.layer.borderColor = UIColor.gray.cgColor
                let nouvelleBoite = Box(box: nouvelleVue, ligne: nouvelleLigne)
                self.evenementViewsFree.append(nouvelleBoite)
                // on l'ajoute à la view
                //self.view.addSubview(self.evenementViewsFree[i].box)
                self.view.addSubview(self.evenementViewsFree[i].ligne)
                
            }
            for i in tailleEvenementViewsFree ..< nombreEvenements {
                
                // on ajoute la boite à la view
                self.view.addSubview(self.evenementViewsFree[i].box)
                
            }
            
        }
        //On cache tout
        for i in 0 ..< evenementViewsFree.count {
            evenementViewsFree[i].box.isHidden = true
            evenementViewsFree[i].ligne.isHidden = true
        }
    }
    
    func dateToDouble(uneDate:Date)-> Double{
        return uneDate.timeIntervalSince1970
    }
    
    func dateAffichable(date: Date) -> String {
        let dateformater = DateFormatter()
        dateformater.dateFormat = "dd/MM/yyyy"
        dateformater.dateStyle = .full
        return dateformater.string(from: date)
    }
    


}

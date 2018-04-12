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

class VueEvtPonctuelsViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    // Les variables transférées
    // MaChrono a déjà été filtrée
    public var mesChronos: GestionChronologie?
    
    //les bornes temporelles de la frise
    public var debutTemps:Date?
    public var finTemps :Date?
    //Taille frise contiendra la ytaille temporelle de la frise
    var tailleFrise:Double = 0
    // Taille mini d'un evenement long
    let RAPPORT_TAILLE_MINI_DUREE_TOTALE = 0.05
    
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
                // On calcule les extrèmes
                let extrems = datesExtremes(listeEvt: vraiChronoCourante)
                debutTemps = extrems.deb
                finTemps = extrems.fin
                // On calcule l'espace temporel entre les événements extrèmes
                tailleFrise = finTemps!.timeIntervalSince1970 - debutTemps!.timeIntervalSince1970
                // On extrait les evenements ponctuels et brefs
                let listeEvtPonctuels = listeEvenementsPonctuels(listeG: vraiChronoCourante)
                // On vérifie qu'il y a des evenements
                if listeEvtPonctuels.count > 0 {
                    // Test
                    //affichageTitres(liste: listeEvtPonctuels)
                    // On prépare les boites d'affichage
                    updateNumberEvenementViews(upTo: listeEvtPonctuels.count)
                    // On affiche au moins 1 evenement
                    afficherBoxes(listeEvt: listeEvtPonctuels)
                    
                }
            }
        }
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
            } else {
                let duree = unEvenement.dateFin.timeIntervalSince1970 - unEvenement.dateDeb.timeIntervalSince1970
                if (duree / tailleFrise) < RAPPORT_TAILLE_MINI_DUREE_TOTALE {
                    result.append(unEvenement)
                }
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
        //let Milieu:CGFloat = LView / 2
        let FinUtile: CGFloat = LView - (L_EVT / 2) - 10
        let Niveau1: CGFloat = HView - (H_EVT / 2) - MARGE_BASSE
        //let basNiveau1:CGFloat = HView - MARGE_BASSE
        // Calculer l'amplitude chronologique des evénements
        
        // On prépare les boites d'affichage si ce n'est fait avant
        //updateNumberEvenementViews(upTo: listeEvt.count)
        
        // On prépare de l'information pour déterminer l'étage d'affichage des boxes
        //Niveau stoke les valeurs de y en pixel selon le niveau
        // Y est la position du centre de la box
        let HAUTEUR_LEVEL: CGFloat = H_EVT + 20
        let Niveau = [Niveau1, Niveau1 - HAUTEUR_LEVEL, Niveau1 - (HAUTEUR_LEVEL * 2), Niveau1 - (HAUTEUR_LEVEL * 3)]
        // On mémorise la position (X) la plus avancée à chaque étage
        var lastLocationByLevel:[CGFloat] = [-200,-200,-200,-200]
        // curLevel permet de balayer les niveaux
        //var curLevel = 0
        
        let amplitudeTemps =  Double((finTemps?.timeIntervalSince1970)! - (debutTemps?.timeIntervalSince1970)!)
        let amplitudeFrise = FinUtile - DebUtile
        let rapportTempsFrise = amplitudeTemps / Double(amplitudeFrise)
            //let debTemps = listeEvt[0].dateDeb.timeIntervalSince1970
        let debTemps = debutTemps?.timeIntervalSince1970
            // Pour calculer l'étage d'affichage de la boite
        
            for laBox in 0..<(listeEvt.count) {
                let posX = (CGFloat((listeEvt[laBox].dateDeb.timeIntervalSince1970 - debTemps! ) / amplitudeTemps) * amplitudeFrise) + DebUtile
                let calculNiveau = calculerNiveau(posX: posX, lastLocationByLevel: lastLocationByLevel, DebUtile: DebUtile)
                lastLocationByLevel[calculNiveau] = posX
                affiche1Box(unEvt: listeEvt[laBox], dansBox: evenementViewsFree[laBox], xEvt: posX, yEvt: Niveau[calculNiveau], yBase: Niveau[calculNiveau], yArr: HView)
            }
        
        
        
    }
    
    func calculerNiveau(posX: CGFloat, lastLocationByLevel:[CGFloat], DebUtile:CGFloat ) -> Int {
        var niveau = 0
        // Pour calculer l'étage d'affichage de la boite
        // Nombre d'étages pour les boites
        let MAX_LEVEL = 3
        let HView:CGFloat = self.view.frame.height
        //let Niveau1: CGFloat = HView - (H_EVT / 2) - MARGE_BASSE
        //Niveau stoke les valeurs de y en pixel selon le niveau
        // Y est la position du centre de la box
        
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
        //print("fonction externe : courant : \(curLevel), optimal: \(optimalLevel)")
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
        var dates = "\(formatter.string(from: unEvt.dateDeb))"
        // Les evenements brefs ne sont pas réellement poctuels, il faut afficher les bornes
        if !unEvt.ponctuel {
            let fin = "\(formatter.string(from: unEvt.dateFin))"
            let inter = " to "
            dates = dates + inter + fin
        }
        dansBox.box.ui_date.text = dates
        dansBox.box.commentaire = unEvt.commentaire
        dansBox.box.center = CGPoint(x: xEvt, y: yEvt)
        dansBox.ligne.frame = CGRect(x: xEvt-1, y: yBase, width: 3, height: yArr - yBase)
        dansBox.box.isHidden = false
        dansBox.ligne.isHidden = false
        // Trace
        //print("\(formatter.string(from: unEvt.dateDeb)) : \(unEvt.intitule), en \(xEvt)")
    }

    //------------------------------------------------
    
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
        
    }
    
    // Des utilitaires
    func updateNumberEvenementViews(upTo:Int) {
        let nombreEvenements = upTo//GlobalVariables.chronologieCourante.listeEvenements.count
        let tailleEvenementViewsFree = evenementViewsFree.count
        
        if  nombreEvenements > tailleEvenementViewsFree {
            
            for i in tailleEvenementViewsFree ..< nombreEvenements {
                let nouvelleVue = EvenementBoxView(frame: CGRect(x: 0, y: 0, width: L_EVT, height: H_EVT))
                //let nouvelleVue = EvenementBoxViewController()
                //On crée une gesture
                let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
                // On l'associe à la boite
                nouvelleVue.addGestureRecognizer(gesture)
                // On crée le vue étroite qui sevira de ligne de la boite à la flèche
                let nouvelleLigne = UIView(frame: CGRect(x: 0, y: 0, width: 2, height: 10))
                nouvelleLigne.backgroundColor = UIColor.black
                //nouvelleLigne.layer.borderWidth = 2.0
                //nouvelleLigne.layer.borderColor = UIColor.gray.cgColor
                let nouvelleBoite = Box(box: nouvelleVue, ligne: nouvelleLigne)
                self.evenementViewsFree.append(nouvelleBoite)
                // on l'ajoute à la view
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
    
    // -----------------
    //l'ouverture du post it lorsqu'on touche une box
    @objc func checkAction(sender : UITapGestureRecognizer) {
        // Do what you want
        //print("touche")
        ouvrirPop(sender.view)
    }
    
    func ouvrirPop(_ sender: Any) {
        let postVC = storyboard?.instantiateViewController(withIdentifier: "postit") as! PostItViewController
        // On passe les valeurs
        let laBoite = sender as! EvenementBoxView
        let leCommentaire = laBoite.commentaire
        postVC.commentaire = leCommentaire
        
        postVC.modalPresentationStyle = .popover
        let pvc = postVC.popoverPresentationController
        pvc?.delegate = (self as UIPopoverPresentationControllerDelegate)
        pvc?.permittedArrowDirections = .any
        pvc?.sourceView = (sender as! UIView)
        pvc?.sourceRect = CGRect(x: (sender as AnyObject).bounds.origin.x , y: (sender as AnyObject).bounds.origin.y, width: 100, height: 100)//sender.bounds
        postVC.preferredContentSize = CGSize(width: 200, height: 200)
        present(postVC, animated: true, completion: nil)
        
    }
   
    
    //-------------------------
    // reprise de la fonction de l'appelant pour définir les bornes d'affichage
    // renvoie les dates extrèmes de la base
    func datesExtremes(listeEvt : [Evenement]) -> (deb: Date, fin: Date) {
        // listeEvt est déjà trié par dateDeb
        if listeEvt.count == 0 {
            return (Date(), Date())
        } else {
            var debut = listeEvt.first?.dateDeb
            var fin = listeEvt.first?.dateFin
            if listeEvt.count > 1 {
                for evt in listeEvt {
                    if evt.dateFin > fin! {
                        fin = evt.dateFin
                    }
                }
                
                return (debut!, fin!)
            } else {
                if listeEvt.count == 1 {
                    if listeEvt[0].ponctuel {
                        let dureeAnnee:TimeInterval = 60 * 60 * 24 * 365.24
                        //let df = DateFormatter()
                        debut = Date(timeIntervalSince1970: (debut?.timeIntervalSince1970)! - dureeAnnee)//debut.timeIntervalSince1970 - dureeAnnee
                        fin = Date(timeIntervalSince1970: (debut?.timeIntervalSince1970)! + dureeAnnee + dureeAnnee)
                        return(debut!, fin!)
                    } else {
                        return (listeEvt[0].dateDeb, listeEvt[0].dateFin)
                    }
                }
                return (Date(), Date())
            }
        }
       
    }
    
    
    
    
    
    
    
    
    
    //-----------------------------------------------
    
    
   
        
    
    
    
    
    
    
    
}

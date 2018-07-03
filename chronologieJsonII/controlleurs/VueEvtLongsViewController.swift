//
//  VueEvtLongsViewController.swift
//  chronologieJsonII
//
//  Created by patrick lanneau on 15/03/2018.
//  Copyright © 2018 patrick lanneau. All rights reserved.
//

import UIKit

class VueEvtLongsViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    // Les variables transférées
    // MaChrono a déjà été filtrée
    public var mesChronos: GestionChronologie?
    
    //les bornes temporelles de la frise
    public var debutTemps:Date?
    public var finTemps :Date?
    //Taille frise contiendra la ytaille temporelle de la frise
    var tailleFrise:Double = 0
    // Taille mini d'un evenement long
    let RAPPORT_TAILLE_MINI_DUREE_TOTALE = 0.03
    
    private var chronoCourante: Chronologie?
    // Les événements de la chronologie courante
    private var vraiChronoCourante: [Evenement] = []
    private var titre:String = ""
    
    // La taille des boites evenement
    //let L_EVT: CGFloat = 100.0
    let H_EVT: CGFloat = 55.0
    
    
    
    // marge basse
    //let MARGE_BASSE:CGFloat = 20
    
    // Un stock de vues déjà créées
    //var evenementViewsFree: [EvenementBoxView] = []
    var evenementViewsFree:[LongPeriodBoxView] = []
    

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
                // On extrait les evenements longs
                let listeEvtLongs = listeEvenementsLongs(listeG: vraiChronoCourante)
                // On vérifie qu'il y a des evenements
                if listeEvtLongs.count > 0 {
                    // Test
                    //affichageTitres(liste: listeEvtPonctuels)
                    // On prépare les boites d'affichage
                    updateNumberEvenementViews(upTo: listeEvtLongs.count)
                    // On affiche au moins 1 evenement
                    afficheLongBoxes(listeEvt: listeEvtLongs)
                    
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //-----------------------------------
    //Lister les evenements longs
    func listeEvenementsLongs(listeG:[Evenement]) -> [Evenement] {
        var result: [Evenement] = []
        for unEvenement in listeG {
            if !unEvenement.ponctuel {
                let duree = unEvenement.dateFin.timeIntervalSince1970 - unEvenement.dateDeb.timeIntervalSince1970
                if (duree / tailleFrise) >= RAPPORT_TAILLE_MINI_DUREE_TOTALE {
                    result.append(unEvenement)
                }
            }
        }
        result.sort(by: {$0.dateDeb < $1.dateDeb})
        return result
    }
    
    
    //---------- Affichage des boite -------------
    // Les boites s'affichent toutes en haut de la zone des événements longs et éventuellement se chevauchent
    func  afficheLongBoxes(listeEvt:[Evenement])  {
        // Longueur et hauteur de la vue
        let LView = self.view.frame.width
        //let HView:CGFloat = self.view.frame.height
        // On positionne les vues evenement par leur centre
        let DebUtile: CGFloat = 10//(L_EVT / 2) + 10 //L_EVT / 2
        //let Milieu:CGFloat = LView / 2
        let FinUtile: CGFloat = LView -  10
        //let Niveau1: CGFloat = H_EVT / 2
        //let basNiveau1:CGFloat = HView - MARGE_BASSE
        // Calculer l'amplitude chronologique des evénements
        
        // On prépare les boites d'affichage si ce n'est fait avant
        //updateNumberEvenementViews(upTo: listeEvt.count)
        
        // On prépare de l'information pour déterminer l'étage d'affichage des boxes
        //Niveau stoke les valeurs de y en pixel selon le niveau
        // Y est la position du centre de la box
        //let HAUTEUR_LEVEL: CGFloat = H_EVT + 20
        //let Niveau = [Niveau1, Niveau1 - HAUTEUR_LEVEL, Niveau1 - (HAUTEUR_LEVEL * 2), Niveau1 - (HAUTEUR_LEVEL * 3)]
        // On mémorise la position (X) la plus avancée à chaque étage
        //var lastLocationByLevel:[CGFloat] = [-200,-200,-200,-200]
        // curLevel permet de balayer les niveaux
        //var curLevel = 0
        
        // On trie par longueur d'evt
        let listeEvtTriee = listeEvt.sorted { dureeEvenement(evt: $0) > dureeEvenement(evt: $1)}
        
        let amplitudeTemps =  Double((finTemps?.timeIntervalSince1970)! - (debutTemps?.timeIntervalSince1970)!)
        let amplitudeFrise = FinUtile - DebUtile
        //let rapportTempsFrise = amplitudeTemps / Double(amplitudeFrise)
        //let debTemps = listeEvt[0].dateDeb.timeIntervalSince1970
        let debTemps = debutTemps?.timeIntervalSince1970
        // Pour calculer l'étage d'affichage de la boite
        var tabNiv: [Int] = []
        
        for laBox in 0..<(listeEvtTriee.count) {
            let tailleBox = CGFloat(listeEvtTriee[laBox].dateFin.timeIntervalSince1970 - listeEvtTriee[laBox].dateDeb.timeIntervalSince1970)  / CGFloat(amplitudeTemps) * amplitudeFrise
            let milieuBox =  (listeEvtTriee[laBox].dateFin.timeIntervalSince1970 + listeEvtTriee[laBox].dateDeb.timeIntervalSince1970) / 2
            let posX = (CGFloat((milieuBox - debTemps! ) / amplitudeTemps) * amplitudeFrise) + DebUtile
            // On calcule le niveau d'affichage
            
            let niveau = calculerNiveau(evt: listeEvtTriee[laBox], dans: listeEvtTriee, jusquA: laBox, tabNiv: tabNiv)
            tabNiv.append(niveau)
            
            //let niveau = 0
            affiche1LongBox(unEvt: listeEvt[laBox], dansBox: evenementViewsFree[laBox], xEvt: posX, largeur: tailleBox, auNiveau: niveau)
        }
        
    }
    
    // ----Afficher une boite ----------------
    // Affiche une boite et son lien en haut de la vue (flèche du temps)
    // reçoit l'évenement, la boite créée pour lui, les coordonnées du centre de la boite
    func affiche1LongBox(unEvt:Evenement, dansBox:LongPeriodBoxView, xEvt:CGFloat, largeur:CGFloat, auNiveau: Int) {
        // On positionne la boite
        let yGrec = H_EVT * CGFloat(auNiveau)
        
        dansBox.center = CGPoint(x: xEvt, y: yGrec + H_EVT / 2)
        dansBox.frame.size.width = largeur
        // On met à jour les champs de la boite
        dansBox.ui_leNom.numberOfLines = 0
        dansBox.ui_leNom.text = unEvt.intitule
        dansBox.ui_leNom.frame = CGRect(x: 5, y: 5, width: dansBox.frame.width - 10, height: 20)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-YYYY"
        let dateDeb = "\(formatter.string(from: unEvt.dateDeb))"
        let dateFin = "\(formatter.string(from: unEvt.dateFin))"
        dansBox.ui_date.numberOfLines = 0
        dansBox.ui_date.text = dateDeb + " to " + dateFin
        dansBox.ui_date.frame = CGRect(x: 5, y: 30, width: dansBox.frame.width - 10, height: 21)
        dansBox.commentaire = unEvt.commentaire
        
        //trace
        //print("\(unEvt.intitule) en \(xEvt) sur \(largeur)")
        //dansBox.ligne.frame = CGRect(x: xEvt-1, y: yBase, width: 3, height: yArr - yBase)
        dansBox.isHidden = false
        //dansBox.ligne.isHidden = false
    }
    

    //-------------------------
    //-------utilitaires----------
    // Des utilitaires
    func updateNumberEvenementViews(upTo:Int) {
        let nombreEvenements = upTo//GlobalVariables.chronologieCourante.listeEvenements.count
        let tailleEvenementViewsFree = evenementViewsFree.count
        
        if  nombreEvenements > tailleEvenementViewsFree {
            
            for _ in tailleEvenementViewsFree ..< nombreEvenements {
                let nouvelleVue = LongPeriodBoxView(frame: CGRect(x: 0, y: 0, width: 100, height: H_EVT))
                //let nouvelleVue = EvenementBoxViewController()
                //On crée une gesture
                let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
                // On l'associe à la boite
                nouvelleVue.addGestureRecognizer(gesture)
                
                self.evenementViewsFree.append(nouvelleVue)
                self.view.addSubview(nouvelleVue)
            }
        }
        //On cache tout
        for i in 0 ..< evenementViewsFree.count {
            evenementViewsFree[i].isHidden = true
        }
    }
    
    // -----------------
    //l'ouverture du post it lorsqu'on touche une box
    @objc func checkAction(sender : UITapGestureRecognizer) {
        // Do what you want
        //print("touche")
        ouvrirPop(sender.view!)
    }
    
    func ouvrirPop(_ sender: Any) {
        let postVC = storyboard?.instantiateViewController(withIdentifier: "postit") as! PostItViewController
        // On passe les valeurs
        let laBoite = sender as! LongPeriodBoxView
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
    
    //----------------------------
    //-----Utilitaires pour régler l'étagement des boites
    //-----et éviter les chevauchements-----------
    func dureeEvenement(evt : Evenement) -> Double {
        return (evt.dateFin.timeIntervalSince1970 - evt.dateDeb.timeIntervalSince1970)
    }
    
    func empiete(unEvenement: Evenement, sur: Evenement) -> Bool {
        return (unEvenement.dateDeb < sur.dateFin) && (unEvenement.dateFin > sur.dateDeb)
    }
    
    func calculerNiveau(evt: Evenement, dans: [Evenement], jusquA: Int, tabNiv:[Int]) -> Int {
        if jusquA == 0 {
            return 0
        }
        var niv = 0
        for elem in 0..<jusquA {
            if empiete(unEvenement: evt, sur: dans[elem]) {
                niv = tabNiv[elem] + 1
            }
        }
        return niv
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

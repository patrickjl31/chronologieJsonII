//
//  ViewController.swift
//  chronologieJson
//
//  Created by patrick lanneau on 31/01/2018.
//  Copyright © 2018 patrick lanneau. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var ui_titreFrise: UITextField!
    
    @IBOutlet weak var currentFriseTitle: UILabel!
    
    @IBOutlet weak var createFrise: UIButton!
    @IBOutlet weak var modifyFrise: UIButton!
    
    
    @IBOutlet weak var friseTableView: UITableView!
    @IBOutlet weak var currentTableView: UITableView!
    @IBOutlet weak var eventTableView: UITableView!
    
    
    @IBOutlet weak var voirFiseButton: UIButton!
    
    @IBOutlet weak var copyToFriseButton: UIButton!
    @IBOutlet weak var observeButton: UIButton!
    
    // Les objets qui serviront au transfert de données vers les autres pages
    // le flag qui permet d'ouvrirnouvelEnregistrementController en lecture seule ou écriture
    var flagPermitSaveNouvelEvenement: Bool = true
    //l'événement à créer ou modifier
    var evenemenATransferer: Evenement?
    
    // L'accès aux données chronologiques
    let chronos = GestionChronologie()
    
    // L'index courant de chaque table
    var indexTable:[Int] = [-1,-1,-1]

    //---------------------------------------------------------
    //MARK:----- Les fonctions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // On ouvre les fichiers
        chronos.openEvents()
        chronos.openChronologies()
        
        // On gère les tables
        friseTableView.dataSource = self
        friseTableView.delegate = self
        friseTableView.allowsSelection = true
        
        currentTableView.dataSource = self
        currentTableView.delegate = self
        currentTableView.allowsSelection = true
        
        eventTableView.dataSource = self
        eventTableView.delegate = self
        eventTableView.allowsSelection = true
        
        friseTableView.reloadData()
        currentTableView.reloadData()
        eventTableView.reloadData()
        
        // On gère les apprences des boutons
        observeButton.isHidden = true
        copyToFriseButton.isHidden = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        friseTableView.reloadData()
        currentTableView.reloadData()
        eventTableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        friseTableView.reloadData()
        currentTableView.reloadData()
        eventTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK : Gérer affichage
    func gererAffichage() {
        //colonne frises (chronologie)
        if chronos.lesChronologies.count > 0,
            let lgNom = ui_titreFrise.text?.count,
            lgNom > 0{
            modifyFrise.isHidden = false
        } else {
            modifyFrise.isHidden = true
        }
        if let len = ui_titreFrise.text?.count {
            if len > 0 {
                modifyFrise.isHidden = false
            } else {
                modifyFrise.isHidden = true
            }
        } else {
            modifyFrise.isHidden = true
        }
        let courante = chronos.indexChronoCourante
        if courante > -1 {
            if chronos.lesChronologies[courante].mesEvenements.count > 0 {
                voirFiseButton.isHidden = false
            } else {
                voirFiseButton.isHidden = true
            }
        } else {
            voirFiseButton.isHidden = true
        }
        
        
    }
    
    // MARK : le tableau des événements ---------
    // Les actions des boutons
    @IBAction func saveEvents(_ sender: UIButton) {
         chronos.saveData()
    }
    
   
    
    @IBAction func createEvent(_ sender: UIButton) {
        // Show nouvel evenement
        flagPermitSaveNouvelEvenement = true
        // On positionne l'index selectionné à -1
        indexTable[2] = -1
        // on crée l'événement à informer
        evenemenATransferer = Evenement()
    }
    
    @IBAction func observeEvent(_ sender: UIButton) {
        // Show evenement sans bouton save
        if indexTable[2] > -1 {
            flagPermitSaveNouvelEvenement = false
            evenemenATransferer =
               chronos.lesEvenements[indexTable[2]]
            // On utilise la segue de newevent
            performSegue(withIdentifier: "newEvent", sender: sender)
        }
       
        
    }
    
    @IBAction func addEventToFrise(_ sender: UIButton) {
        // Ajoute l'événement à la frise courante
        // quel est l'événement sélectionné ?
        let numEvt = indexTable[2]
        if numEvt > -1 {
            let evt = chronos.lesEvenements[numEvt]
            // S'il existe une chronologie courante
            //let chronoCour = chronos.chronoCourante
            if chronos.indexChronoCourante > -1 {
                // On lui ajoute l'événement
                let nchrono = chronos.addEventToChronologie(unEvenement: evt, chrono: chronos.lesChronologies[chronos.indexChronoCourante])
                chronos.lesChronologies[chronos.indexChronoCourante] = nchrono
                // On sauvegarde les frises
                chronos.saveChronologies()
                // On met la table à jour
                currentTableView.reloadData()
                friseTableView.reloadData()
            }
            
        }
    }
    
    // MARK : le tableau de la frise courante
    
    @IBAction func VoirFriseGraphique(_ sender: UIButton) {
        //Creer un tableau d'événements ponctuels et un tableau d'événenents longs
        /*
        let indexChrono = chronos.indexChronoCourante
        if indexChrono > -1 {
            let
        }
 */
    }
    
     // MARK : le tableau des frises
    
    // Cet objet me semble inutile...
    //@IBOutlet weak var nomFriseField: UITextField!
   
    @IBAction func modifierFriseButton(_ sender: Any) {
    }
    
    @IBAction func creerFrise(_ sender: UIButton) {
        if let leTitre = ui_titreFrise.text {
            if leTitre.count > 0 {
                //let uneFrise = Chronologie(intitule: leTitre, typeLongTerme: true, mesEvenements: [])
                chronos.addChronologie(nom: leTitre, longterme: true)
                friseTableView.reloadData()
                
            }
        }
    }
    
    
    // -------------------------
    //------------
    // MARK: -  Gestion des tables
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of items in the sample data structure.
        
        var count:Int?
        
        if tableView == self.friseTableView {
            count = chronos.lesChronologies.count
        }
        
        if tableView == self.currentTableView {
            if chronos.indexChronoCourante > -1 {
                count = chronos.lesChronologies[chronos.indexChronoCourante].mesEvenements.count
            } else {
                count =  0
            }
            //count = 5
        }
        if tableView == self.eventTableView {
            count =  chronos.lesEvenements.count
        }
        
        return count!
        
    }
    //------------
    
    func  tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        
        if tableView == self.friseTableView {
            //cell = tableView.dequeueReusableCell(withIdentifier: "chronoCell", for: indexPath as IndexPath)
            cell = tableView.dequeueReusableCell(withIdentifier: "frise-cell")
            if cell == nil {
                cell = UITableViewCell(style: .subtitle, reuseIdentifier: "frise-cell")
            }
           
            let uneChronologie = chronos.lesChronologies[indexPath.row]
            cell!.textLabel!.text = uneChronologie.intitule
            let taille = uneChronologie.mesEvenements.count
            cell!.detailTextLabel?.text = "\(taille) événement(s)."
            
        }
        
        if tableView == self.currentTableView {
           
            cell = tableView.dequeueReusableCell(withIdentifier: "current-cell")
            if cell == nil {
                cell = UITableViewCell(style: .subtitle, reuseIdentifier: "current-cell")
            }
            /*
            if chronos.indexChronoCourante > -1 {
                let laChrono = chronos.lesChronologies[chronos.indexChronoCourante]
                let evenementAAfficher = laChrono.mesEvenements[indexPath.row]
                cell!.textLabel!.text = "Evt = " +  evenementAAfficher.intitule//"current"
                //let saDate = "le \(listeEvenements[indexPath.row].date)"
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy"
                dateFormatter.dateStyle = .medium
                let saDate = dateFormatter.string(from: evenementAAfficher.dateDeb)
                //print (saDate)
                cell!.detailTextLabel?.text = "Date :\(saDate)"
            }
            */
            let indexCourant = chronos.indexChronoCourante
            if indexCourant > -1 {
                let courant = chronos.lesChronologies[indexCourant]
                let unEvenement = courant.mesEvenements[indexPath.row]
                cell?.textLabel?.text = unEvenement.intitule
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy"
                dateFormatter.dateStyle = .medium
                let saDateDeb = dateFormatter.string(from: unEvenement.dateDeb)
                var saDateFin = "."
                if !unEvenement.ponctuel {
                    saDateFin = " to " + dateFormatter.string(from: unEvenement.dateFin)
                }
                cell!.detailTextLabel?.text = "\(saDateDeb)" + "\(saDateFin)"
            } else {
                    cell?.textLabel?.text = ""
                }
        }
        
        if tableView == self.eventTableView {
            //cell = tableView.dequeueReusableCell(withIdentifier: "currentCell", for: indexPath as IndexPath)
            cell = tableView.dequeueReusableCell(withIdentifier: "event-cell")
            if cell == nil {
                cell = UITableViewCell(style: .subtitle, reuseIdentifier: "event-cell")
            }
            /*
             //let previewDetail = sampleData1[indexPath.row]
             cell!.textLabel!.text = "event"
             let dateFormatter = DateFormatter()
             dateFormatter.dateFormat = "dd-MM-yyyy"
             dateFormatter.dateStyle = .medium
             let saDate = dateFormatter.string(from: Date())
             //print (saDate)
             */
            let unEvenement = chronos.lesEvenements[indexPath.row]
            cell?.textLabel?.text = unEvenement.intitule
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            dateFormatter.dateStyle = .medium
            let saDateDeb = dateFormatter.string(from: unEvenement.dateDeb)
            var saDateFin = "."
            if !unEvenement.ponctuel {
                saDateFin = " to " + dateFormatter.string(from: unEvenement.dateFin)
            }
            cell!.detailTextLabel?.text = "\(saDateDeb)" + "\(saDateFin)"
            
        }
        return cell!
    }
    
    //---------
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let index: Int = indexPath.row
        if tableView == self.friseTableView {
            //index = indexPath.row
            //chronologieSelected = -1
            indexTable[0] = -1 //typeTables.frise.rawValue
        }
        
        if tableView == self.currentTableView {
            //index = indexPath.row
            //evenementSelected = -1
            //tableView.deselectRow(at: indexPath, animated: false)
            //let cell = tableView.cellForRow(at: indexPath)
            //cell?.setHighlighted(false, animated: true)
            indexTable[1] = -1  //typeTables.current.rawValue
        }
        if tableView == self.eventTableView {
            //index = indexPath.row
            indexTable[2] = -1  //typeTables.evenement.rawValue
            observeButton.isHidden = true
            copyToFriseButton.isHidden = true
        }
        //tableView.deselectRow(at: indexPath, animated: false)
        //print("Déselection de \(indexTable)")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var index: Int = indexPath.row
        //print("selection : \(index)")
        if tableView == self.friseTableView {
            indexTable[0] = indexPath.row
            ui_titreFrise.text = chronos.lesChronologies[indexPath.row].intitule
            currentFriseTitle.text = chronos.lesChronologies[indexPath.row].intitule
            // On met à jour la chronologie courante dans le modèle
            chronos.chronoCourante = chronos.lesChronologies[indexPath.row]
            chronos.indexChronoCourante = index
            //changementChronologie(newIndex: index)
            currentTableView.reloadData()
        }
        
        if tableView == self.currentTableView {
            index = indexPath.row
            //evenementSelected = index
            indexTable[1] = indexPath.row
        }
        if tableView == self.eventTableView {
            index = indexPath.row
            indexTable[2] = indexPath.row
            observeButton.isHidden = false
            copyToFriseButton.isHidden = false
        }
        //print("Sélection : \(indexTable)")
        //print("did select:      \(indexPath.row)  ")
    }
    
    // - modification des tables
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let index = indexPath.row
        if tableView == self.friseTableView {
            if editingStyle == .delete {
                // On delete dans la table
                //let badChrono = GlobalVariables.listeChronologie[index]
                
                //GlobalVariables.listeChronologie.remove(at: index)
                self.friseTableView.reloadData()
            }
            
        }
        
        if tableView == self.currentTableView {
            if editingStyle == .delete {
                // On delete dans la table
                let badEvt = chronos.lesChronologies[chronos.indexChronoCourante].mesEvenements[index]
                if chronos.indexChronoCourante > -1 {
                    //chronos.lesChronologies[chronos.indexChronoCourante]
                    
                    let laChrono = chronos.deleteEventFromChronologie(unEvenement: badEvt, fromChronologie: chronos.lesChronologies[chronos.indexChronoCourante])
                    chronos.lesChronologies[chronos.indexChronoCourante] = laChrono
                }
                
                //GlobalVariables.listeEvenements.remove(at: index)
                self.friseTableView.reloadData()
                self.currentTableView.reloadData()
            }
            
        }
        if tableView == self.eventTableView {
            if editingStyle == .delete {
                // On delete dans la table
                let eventToKill = chronos.lesEvenements[index]
                // On delete dans l'instance de la classe
                chronos.deleteEvent(evt: eventToKill)
                self.eventTableView.reloadData()
                // On cache les boutons de la colone
                copyToFriseButton.isHidden = true
                observeButton.isHidden = true
            }
        }
        //print("\(indexTable)")
    }
    
    // Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "newEvent") || (segue.identifier == "newEvent1"){
            let vc = segue.destination as! NouvelEvenementViewController
            vc.chronologies = chronos
            vc.permitSaveValues = flagPermitSaveNouvelEvenement
            vc.indexEvenement = indexTable[2]
            vc.unEvent = evenemenATransferer
            vc.instanceOfViewController = self
            //if indexTable[2] >
            eventTableView.reloadData()
        }
        if segue.identifier == "voirFrise"{
            let vc = segue.destination as! FriseViewController
            vc.lesChronos = chronos
            let ind_courante = chronos.indexChronoCourante
            if ind_courante > -1 {
                vc.laChrono = chronos.lesChronologies[ind_courante].mesEvenements
            } else {
                vc.laChrono = []
            }
            
        }
    }
    



}


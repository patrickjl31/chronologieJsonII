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
    @IBOutlet weak var ui_titrePage: UILabel!
    
    @IBOutlet weak var createFrise: UIButton!
    @IBOutlet weak var modifyFrise: UIButton!
    
    
    @IBOutlet weak var friseTableView: UITableView!
    @IBOutlet weak var currentTableView: UITableView!
    @IBOutlet weak var eventTableView: UITableView!
    
    
    @IBOutlet weak var voirFiseButton: UIButton!
    
    @IBOutlet weak var copyToFriseButton: UIButton!
    @IBOutlet weak var observeButton: UIButton!
    
    // Les objets qui serviront au transfert de données vers les autres pages
    // le flag qui permet d'ouvrir nouvelEnregistrementController en lecture seule ou écriture
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
        
        // On ouvre les fichiers directement à l'initialisation de chronos
        //chronos.openEvents()
        //chronos.openChronologies()
        
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
        
        rafraichirTables()
        
        // On gere l'édition de la liste d'événements
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
        //eventTableView.setEditing(true, animated: true)
        
        // On gère les apprences des boutons
        gererAffichage()
        /*
        observeButton.isHidden = true
        copyToFriseButton.isHidden = true
        voirFiseButton.isHidden = true
        modifyFrise.isHidden = true
        // et des labels
        currentFriseTitle.text = ""
        */
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        rafraichirTables()
        /*
        // On gère les apprences des boutons
        //observeButton.isHidden = true
        copyToFriseButton.isHidden = true
        //voirFiseButton.isHidden = true
        modifyFrise.isHidden = true
        // et des labels
        //currentFriseTitle.text = ""
        if chronos.indexChronoCourante > -1 {
            print("\(chronos.lesChronologies[chronos.indexChronoCourante].intitule)")
        }
        */
        gererAffichage()
    }
    override func viewWillAppear(_ animated: Bool) {
        rafraichirTables()
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
            ui_titreFrise.text = ""
            currentFriseTitle.text = ""
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
        //events
        if chronos.lesEvenements.count > 0 {
            observeButton.isHidden = false
            observeButton.setTitle("edit", for: .normal)
            eventTableView.setEditing(false, animated: true)
        } else {
            observeButton.isHidden = true
            eventTableView.setEditing(false, animated: true)
        }
        copyToFriseButton.isHidden = true
        // Titre page
        let baseTitre = NSLocalizedString("Timeline", comment: "Chronologie")
        let monTitre = chronos.currentWorkFileName
        if monTitre != "" {
            self.title = baseTitre + " : " + monTitre
        } else {
            self.title = baseTitre
        }
        
    }
    
    //-------------------------------------------
    //--------- gestion de fichiers--------------
    @IBAction func fileNew(_ sender: Any) {
        if chronos.currentWorkFileName.count > 0 {
            //On demande si on sauve
            chronos.saveAllAs()
        }
        chronos.reinitialisation()
        rafraichirTables()
        gererAffichage()
    }
    
    @IBAction func fileSave(_ sender: Any) {
        if chronos.currentWorkFileName.count == 0 {
            inputFileName()
            
        }
        chronos.saveAllAs()
    }
    
    @IBAction func fileSaveAs(_ sender: Any) {
        inputFileName()
        chronos.saveAllAs()
    }
    
    @IBAction func fileOpen(_ sender: Any) {
        // appel de poplistfil...
        // qui ouvre et met à jour
        
        rafraichirTables()
        gererAffichage()
    }
    
    // mise à jour des listes
    func rafraichirTables()  {
        friseTableView.reloadData()
        currentTableView.reloadData()
        eventTableView.reloadData()
    }
    
    //----------------------------------------------
    //---------dialogue d'entrée de nom de fichier
    //----------------------------------------------
    // Inputfilename : demande un nom de fichier. S'il est fourni, il est vérifié, enregistré, et le fichier sauvé
    func inputFileName(){
        let dialog = UIAlertController(title: "Save as :", message: "Use only letters, numbers or - or _ )", preferredStyle: .alert)
        //let confirm = UIAlertAction
        let textAction = UIAlertAction(title: "OK", style: .default) { (alertAction) in
            let textField = dialog.textFields![0] as UITextField
            if let nf = textField.text {
                var nomFic = nf //textField.text
                // On remplace les espace par des underscores
                nomFic = nomFic.replacingOccurrences(of: " ", with: "_")
                //On filtre
                let tiret = CharacterSet.init(charactersIn: "-_")
                var authorizedSet = CharacterSet.alphanumerics
                authorizedSet = authorizedSet.union(tiret)
                nomFic = String((nomFic.unicodeScalars.filter {authorizedSet.contains($0)}))
                // On enregistre ce nom dans le modèle
                self.chronos.currentWorkFileName = nomFic
                self.chronos.setCurrentFileName(to: nomFic)
                // On sauve sous ce nom
                self.chronos.saveAllAs()
                //print("rename \(nomFichier) to \(nomFic)")
                
            }
        }
        dialog.addTextField { (textField) in
            textField.placeholder = "my_file"
        }
        dialog.addAction(textAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        //let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        dialog.addAction(cancelAction)
        //dialog.addAction(okAction)
        self.present(dialog, animated: true)
    }
    
    // -------- dialog OK
    
    
    // MARK : le tableau des événements ---------
    // Les actions des boutons
    @IBAction func saveEvents(_ sender: UIButton) {
         chronos.saveData(inFile: "")
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
        if sender.title(for: .normal) == "edit" {
            sender.setTitle("done", for: .normal)
            eventTableView.setEditing(true, animated: true)
        } else {
            sender.setTitle("edit", for: .normal)
            eventTableView.setEditing(false, animated: true)
        }
        
        /*
        if indexTable[2] > -1 {
            //modify... on permet la sauvegarde
            flagPermitSaveNouvelEvenement = true
            evenemenATransferer =
               chronos.lesEvenements[indexTable[2]]
            // On utilise la segue de newevent
            performSegue(withIdentifier: "newEvent", sender: sender)
        }
 */
        
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
                chronos.saveChronologies(inFile: "")
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
        if let leTitre = ui_titreFrise.text {
            if leTitre.count > 0, chronos.indexChronoCourante > -1 {
                //let laChrono = chronos.chronoCourante
                //let uneFrise = Chronologie(intitule: leTitre, typeLongTerme: true, mesEvenements: [])
                chronos.lesChronologies[chronos.indexChronoCourante].intitule = leTitre
                friseTableView.reloadData()
                // On modifie dans la table courante
                currentFriseTitle.text = leTitre
                currentTableView.reloadData()
                
            }
        }
    }
    
    @IBAction func creerFrise(_ sender: UIButton) {
        if let leTitre = ui_titreFrise.text {
            if leTitre.count > 0 {
                //let uneFrise = Chronologie(intitule: leTitre, typeLongTerme: true, mesEvenements: [])
                let res = chronos.addChronologie(nom: leTitre, longterme: true)
                if res.count > 0 {
                    Alerte.shared.erreur(message: res, controller: self)
                }
                friseTableView.reloadData()
                
            }else {
                let mes = NSLocalizedString("Give title for your timeline", comment: "Donnez un nom pour la frise")
                Alerte.shared.erreur(message: mes, controller: self)
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
                    let motTo = NSLocalizedString("to", comment: "to")
                    saDateFin = " " + motTo + " " + dateFormatter.string(from: unEvenement.dateFin)
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
            
            let unEvenement = chronos.lesEvenements[indexPath.row]
            cell?.textLabel?.text = unEvenement.intitule
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            dateFormatter.dateStyle = .medium
            let saDateDeb = dateFormatter.string(from: unEvenement.dateDeb)
            var saDateFin = "."
            if !unEvenement.ponctuel {
                let motTo = NSLocalizedString("to", comment: "to")
                saDateFin = " " + motTo + " " + dateFormatter.string(from: unEvenement.dateFin)
            }
            cell!.detailTextLabel?.text = "\(saDateDeb)" + "\(saDateFin)"
            
        }
        return cell!
    }
    
    //---------
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        //let index: Int = indexPath.row
        if tableView == self.friseTableView {
            //index = indexPath.row
            //chronologieSelected = -1
            indexTable[0] = -1 //typeTables.frise.rawValue
            // On met à jour l'affichage des boutons
            voirFiseButton.isHidden = true
            modifyFrise.isHidden = true
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
            // Par sécurité, on trie la chronologie selectionnée
            chronos.lesChronologies[indexPath.row].mesEvenements.sort(by: {$0.dateDeb < $1.dateDeb})
            // On met à jour la chronologie courante dans le modèle
            chronos.chronoCourante = chronos.lesChronologies[indexPath.row]
            chronos.indexChronoCourante = index
            // On montre les boutons
            voirFiseButton.isHidden = false
            modifyFrise.isHidden = false
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
            if chronos.indexChronoCourante > -1 {
                copyToFriseButton.isHidden = false
            } else {
                copyToFriseButton.isHidden = true
            }
            
            if indexTable[0] > -1 {
                copyToFriseButton.isHidden = false
            }
            //eventTableView.setEditing(true, animated: true)
            
        }
        //print("Sélection : \(indexTable)")
        //print("did select:      \(indexPath.row)  ")
    }
    
    // - modification des tables
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let index = indexPath.row
        if tableView == self.friseTableView {
            if editingStyle == .delete {
                // Si cette chronologie est la chrono courante, on met la chrono courante à nil
                if index == chronos.indexChronoCourante {
                    indexTable[1] = -1
                    currentFriseTitle.text = ""
                    
                }
                // On delete dans la table
                chronos.deleteChronologie(laChrono: chronos.lesChronologies[index])
                //GlobalVariables.listeChronologie.remove(at: index)
                //self.friseTableView.reloadData()
                friseTableView.deleteRows(at: [indexPath], with: .automatic)
                currentTableView.reloadData()
                //currentTableView.deleteRows(at: [indexPath], with: .automatic)
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
                //self.currentTableView.reloadData()
                currentTableView.deleteRows(at: [indexPath], with: .automatic)
            }
            
        }
        if tableView == self.eventTableView {
            if editingStyle == .delete {
                // On delete dans la table
                let eventToKill = chronos.lesEvenements[index]
                // On delete dans l'instance de la classe
                chronos.deleteEvent(evt: eventToKill)
                //self.eventTableView.reloadData()
                eventTableView.deleteRows(at: [indexPath], with: .automatic)
                // On cache les boutons de la colonne
                copyToFriseButton.isHidden = true
                observeButton.isHidden = false
                self.friseTableView.reloadData()
                self.currentTableView.reloadData()
                //currentTableView.deleteRows(at: [indexPath], with: .automatic)
            }
            /*
            if editingStyle == .insert {
                // Show nouvel evenement
                flagPermitSaveNouvelEvenement = false
                // On positionne l'index selectionné à -1
                indexTable[2] = -1
                // on crée l'événement à informer
                evenemenATransferer = Evenement()
            }
            */
        }
        //print("\(indexTable)")
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        //print("move : \(sourceIndexPath.row)")
        if indexTable[2] > -1 {
            //modify... on permet la sauvegarde
            flagPermitSaveNouvelEvenement = false
            evenemenATransferer =
                chronos.lesEvenements[indexTable[2]]
            // On utilise la segue de newevent
            performSegue(withIdentifier: "newEvent", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        /*
        print ("Touche :")
        if indexTable[2] > -1 {
            //modify... on permet la sauvegarde
            flagPermitSaveNouvelEvenement = true
            evenemenATransferer =
                chronos.lesEvenements[indexTable[2]]
            //evenemenATransferer =
                chronos.lesEvenements[indexPath.row]
            // On utilise la segue de newevent
            performSegue(withIdentifier: "newEvent", sender: nil)
        }
 */
        flagPermitSaveNouvelEvenement = true
        evenemenATransferer =
            chronos.lesEvenements[indexPath.row]
        // On utilise la segue de newevent
        performSegue(withIdentifier: "newEvent", sender: nil)
    }
    
    // Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "newEvent") || (segue.identifier == "newEvent1"){
            let vc = segue.destination as! NouvelEvenementViewController
            vc.chronologies = chronos
            vc.nouvelEvenementASauver = flagPermitSaveNouvelEvenement
            vc.indexEvenement = indexTable[2]
            vc.unEvent = evenemenATransferer
            vc.instanceOfViewController = self
            //if indexTable[2] >
            //eventTableView.reloadData()
            //chronos.chronoCourante = chronos.lesChronologies[chronos.indexChronoCourante]
            //currentTableView.reloadData()
        }
        if segue.identifier == "voirFrise"{
            let vc = segue.destination as! FriseViewController
            vc.lesChronos = chronos
            let ind_courante = chronos.indexChronoCourante
            if ind_courante > -1 {
                vc.laChrono = chronos.lesChronologies[ind_courante].mesEvenements
                vc.monTitre = chronos.lesChronologies[ind_courante].intitule
            } else {
                vc.laChrono = []
            }
            
            vc.view.setNeedsLayout()
            vc.view.layoutIfNeeded()
            
        }
        if segue.identifier == "listFiles" {
            let vc = segue.destination as! PopListFileTableViewController
            vc.chrono = chronos
            vc.pere = self
        }
    }
    



}


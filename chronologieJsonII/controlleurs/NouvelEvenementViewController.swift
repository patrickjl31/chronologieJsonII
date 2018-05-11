//
//  NouvelEvenementViewController.swift
//  chronologieJson
//
//  Created by patrick lanneau on 31/01/2018.
//  Copyright © 2018 patrick lanneau. All rights reserved.
//

import UIKit

class NouvelEvenementViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var ui_titre: UITextField!
    @IBOutlet weak var ui_comment: UITextView!
    @IBOutlet weak var ui_Date: UILabel!
    
    // Les zones de saisie de date
    
    @IBOutlet weak var ui_jour: UITextField! /*{
        didSet {
            ui_jour?.addDoneCancelToolbar(onDone: (target: self, action: #selector(doneButtonTappedForMyNumericTextField)), onCancel: (target: self, action: #selector(cancelButtonTappedForMyNumericTextField)))
            // Penser à écrire la fonction doneButtonTappedForMyNumericTextField
        }
    }*/
    @IBOutlet weak var ui_mois: UITextField! /*{
        didSet {
            ui_mois?.addDoneCancelToolbar(onDone: (target: self, action: #selector(doneButtonTappedForMyNumericTextField)), onCancel: (target: self, action: #selector(cancelButtonTappedForMyNumericTextField)))
            // Penser à écrire la fonction doneButtonTappedForMyNumericTextField
        }
    }*/
    @IBOutlet weak var ui_an: UITextField! /*{
        didSet {
            ui_an?.addDoneCancelToolbar(onDone: (target: self, action: #selector(doneButtonTappedForMyNumericTextField)), onCancel: (target: self, action: #selector(cancelButtonTappedForMyNumericTextField)))
            // Penser à écrire la fonction doneButtonTappedForMyNumericTextField
        }
    }*/
    
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var ui_DatePicker: UIDatePicker!
    
    var laDate = Date()
    var dateDeb = Date(timeIntervalSince1970: 0)
    var dateFin = Date(timeIntervalSince1970: 0)
    var datEnCours = "deb"
    var evtPonctuel = true
    
    
    // Les données globales envoyées par le viewController
    var chronologies:GestionChronologie?
    var permitSaveValues:Bool = true
    var indexEvenement:Int = -1
    var unEvent:Evenement?
    var instanceOfViewController:ViewController!
    
    // Les données de travail
    var textSaved = ""
    // Doit-on ajouter l'événement ou simplement le modifier ?
    var nouvelEvenementASauver = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if permitSaveValues {
            saveButton.isHidden = false
            cancelButton.isHidden = false
            
        } else {
            saveButton.isHidden = true
            cancelButton.isHidden = true
            //
        }
        /*
        ui_jour.delegate = self
        ui_an.delegate = self
        ui_mois.delegate = self
        */
        // On gère les deux dates, début et fin
        datEnCours = "deb"
        
        // A-t-on passé un événement à afficher ?
        if let emptyEvt = unEvent?.intitule.count {
            if emptyEvt > 0 {
                nouvelEvenementASauver = false
                ui_titre.text = unEvent?.intitule
                ui_comment.text = unEvent?.commentaire
                laDate = (unEvent?.dateDeb)!
                dateDeb = (unEvent?.dateDeb)!
                dateFin = (unEvent?.dateFin)!
                updateDate()
            }
         else {
            nouvelEvenementASauver = true
            ui_jour.text = "1"
            ui_mois.text = "1"
            ui_an.text = ""
        }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func debutFin(_ sender: UISegmentedControl) {
        if datEnCours == "deb" {
            dateDeb = laDate
        } else {
            dateFin = laDate
        }
        // Si on enregistre une date de fin, l'evt n'est pas ponctuel..
        evtPonctuel = false
        
        switch  sender.selectedSegmentIndex {
        case 0:
            // Début
            datEnCours = "deb"
        case 1:
            datEnCours = "fin"
        default:
            datEnCours = "deb"
        }
        // On met à jour les champs textes
        updateDate()
    }
    
    
    
    @IBAction func datePickerAction(_ sender: UIDatePicker) {
        self.laDate = sender.date
        updateDate()
    }
    func updateDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let laDateS = dateFormatter.string(from: self.laDate)
        self.ui_Date.text = laDateS
        //let laDateString = laDateS
        // Les trois éléments
        let calendar = Calendar.current
        let year = calendar.component(.year, from: laDate)
        ui_an.text = "\(year)"
        let month = calendar.component(.month, from: laDate)
        ui_mois.text = "\(month)"
        let day = calendar.component(.day, from: laDate)
        ui_jour.text = "\(day)"
        
        ui_DatePicker.setDate(laDate, animated: true)
        
    }
    
    @IBAction func ui_dateEnTexte(_ sender: UITextField) {
        if ui_jour.text == ""{
            ui_jour.text = "1"
        }
        var day:Int = Int(ui_jour.text!)!
        if (day < 1) || (day > 31) {
            day = 1
        }
        let dayS = String(format: "%02i", day)
        if ui_mois.text == ""{
            ui_mois.text = "1"
        }
        var month:Int = Int(ui_mois.text!)!
        if (month < 1) || (month > 12) {
            month = 1
        }
        let monthS = String(format: "%02i", month)
        if ui_an.text == ""{
            ui_an.text = "1"
        }
        let year:Int = Int(ui_an.text!)!
        let yearS = String(format: "%02i", year)
        let dateStringToTest = "\(dayS)/\(monthS)/\(yearS)"
        //let calendrier = Calendar.current
        
        //        Gestion de la validité de la date proposée
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateTested = dateFormatter.date(from: dateStringToTest)
        if dateTested != nil {
            laDate = dateTested!
            ui_DatePicker.setDate(laDate, animated: true)
            ui_Date.text = NSLocalizedString("Date :", comment: "Date de l'événement : ") + dateFormatter.string(from: laDate)
        }
        
    }
    
    
    @IBAction func cancelAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        
       //_ = navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        // On valide les choix de dates
        if datEnCours == "deb" {
            dateDeb = laDate
        } else {
            dateFin = laDate
        }
        // si l'événement est ponctuel, on égalise des dates de début et de fin
        if evtPonctuel{
            dateFin = dateDeb
        } 
        
        if let titre = ui_titre.text{
            //let date = ui_Date.text
            //unEvent = Evenement()
            unEvent?.intitule = titre
            unEvent?.commentaire = ui_comment.text
            unEvent?.dateDeb = dateDeb
            unEvent?.dateFin = dateFin
            
            unEvent?.ponctuel = evtPonctuel
            unEvent?.typeLongTerme = true
            if nouvelEvenementASauver {
                chronologies?.lesEvenements.append(unEvent!)
            }
            
            // On trie
            chronologies?.lesEvenements.sort(by: {$0.dateDeb < $1.dateDeb})
            
            // On enregistre
            chronologies?.saveData(inFile: "")
            // On recharge sur le viewController
            instanceOfViewController.eventTableView.reloadData()
            // On quitte
            dismiss(animated: true, completion: nil)
            //_ = navigationController?.popViewController(animated: true)
        }
        
    }
    
    // delegate des champs textes
    func textFieldDidBeginEditing(_ textField: UITextField) {    //delegate method
        textSaved = (textField.text)!
        textField.becomeFirstResponder()
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {  //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        
        return true
    }
    
    // Gestion des boutons du clavier
    /*
    @objc func doneButtonTappedForMyNumericTextField(_ textField: UITextField!) {
        print("Done");
        //textField.text = textSaved
        textField.resignFirstResponder()
    }
    
    @objc func cancelButtonTappedForMyNumericTextField(_ textField: UITextField!) {
        textField.resignFirstResponder()
    }
    */
    
}


/*
extension UITextField {
    func addDoneCancelToolbar(onDone: (target: Any, action: Selector)? = nil, onCancel: (target: Any, action: Selector)? = nil) {
        let onCancel = onCancel ?? (target: self, action: #selector(cancelButtonTapped))
        let onDone = onDone ?? (target: self, action: #selector(doneButtonTapped))
        
        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: onCancel.target, action: onCancel.action),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "OK", style: .done, target: onDone.target, action: onDone.action)
        ]
        toolbar.sizeToFit()
        
        self.inputAccessoryView = toolbar
    }
    
    // Default actions:
    @objc func doneButtonTapped() { self.resignFirstResponder() }
    @objc func cancelButtonTapped() { self.resignFirstResponder() }

}
*/

//
//  HelpViewController.swift
//  chronologieJsonII
//
//  Created by patrick lanneau on 19/04/2018.
//  Copyright © 2018 patrick lanneau. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {

    @IBOutlet weak var help: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.preferredContentSize = CGSize(width: 300, height: 420)
        
        let prefferedLanguage = Locale.preferredLanguages[0] as String
        //print(prefferedLanguage)
        let textHelp_fr = """
Chronologies

Frises Chronologiques

Frises Chronologiques gère des événements et permet de les organiser en chronologies. Ces chronologies peuvent être affichées sous la forme de frises graphiques.
 
Je remercie Clément C., celui de mes anciens élèves qui m'a demandé de lui écrire cette application et en a donc eu le premier l'idée ! Elle s'adresse d'abord aux enseignants et aux élèves qui pourront manipuler plus facilement  les chronologies historiques et surtout le représenter plus facilement.

L'écran principal présente 3 listes.
- A droite, la liste des événements. Ils sont rangés par ordre chronologique.
- A gauche, la liste des chronologies
- au centre, la chronologie courante en cours de construction.

Evénements -> Nouvel Evénement : permet de créer un nouvel événement. Par défaut, un événement est ponctuel. Si il a une durée, renseigner la date de fin. Un événement doit avoir au moins un titre.

Un événement sélectionné peut être détruit, édité (modifié) ou bien glissé dans une chronologie si une chronologie est sélectionnée dans le liste centrale

Chronologies -> Créer : Crée une chronologie. Elle doit avoir un titre.
Une chronologie sélectionnée est détaillée dans la liste centrale.  Si elle contient des événements, elle permet d'afficher une frise graphique.

D'autres séries d'événement... Les boutons sur la gauche de la barre supérieur de l'écran d'accueil permettent :
+ : Créer une nouvelle série d'événements
Enregistrer : sauvegarder la série courante
Enregistrer sous... : Sauvegarder sous un nouvel identificateur
Ouvrir : ouvrir une série déjà enregistrée.
Export... : exporter la série courant.


L'écran Frise Graphique. Toucher un événement affiche le commentaire correspondant.
Le bouton 'Enregistrer en PDF' permet d'enregistrer une image PDF de l'écran sous le nom 'default.pdf'.
Le bouton d'envoi sur la barre supérieure permet d'envoyer ce fichier par tous moyens (Airdrop, mail...)

Les fichiers d'événement et les chronologies sont enregistrées au format JSON et récupérable par l'intermédiaire d'iTunes.



"""
        let textHelp_en = """
English

Chronologies

Timelines

Chronologies manages events and organizes them in chronologies. These timelines can be displayed as graphic friezes.
 
I thank Clement C., the one of my former students who asked me to write this application and had the first idea! It is primarily for teachers and students who will be able to manipulate historical chronologies more easily and especially to represent it more easily.

Main screen presents 3 lists.

- On the right, the list of events. They are arranged in chronological order.
- On the left, the list of chronologies
- in the center, the current chronology under construction.

Events -> Create Event: Create a new event. By default, an event is punctual. If it has a duration, fill in the end date. An event must have at least one title.

A selected event can be destroyed, edited or dragged into a timeline if a timeline is selected in the central list

Chronologies -> Create: Create a timeline. Timeline must have a title.
A selected timeline is detailed in the central list. If it contains events, it displays a graphic frieze.

Other series of events ... Buttons on the left of the top bar of the home screen allow:
+ : Create  new series of events
Save: save the current series
Save as...: Save as a new identifier
Open...: open an already recorded series.
Export... : export currents events.


The graphic frieze screen. Touching an event displays the corresponding comment.

The 'save to PDF' button saves a PDF image of the screen under the name 'default.pdf'.

The send button on the top bar allows to send PDF image file by any means (Airdrop, mail ...)

Event files and timelines are saved in JSON format and can be retrieved through iTunes.

"""
        //let contentHelp = NSLocalizedString(textHelp_en, comment: "help")
        //print("\(contentHelp)")
        if prefferedLanguage == "fr" {
            help.text = textHelp_fr
        } else {
            help.text = textHelp_en
        }
    }

    @IBAction func doneButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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

}

//
//  GestionChronologie.swift
//  chronologieJson
//
//  Created by patrick lanneau on 31/01/2018.
//  Copyright © 2018 patrick lanneau. All rights reserved.
//

import UIKit

class GestionChronologie: NSObject {
    
    var lesChronologies:[Chronologie] = []
    var lesEvenements:[Evenement] = []
    var chronoCourante:Chronologie?
    var indexChronoCourante = -1
    
    func openEvents() {
        _ = recallData()
    }
    func openChronologies()  {
        lesChronologies = recallChronos()
    }
    
    // MARK: Gérer les événements--------------------
    //-----Gérer les événements----------
    
    //--- A enrichir avec les paramètres evenementPonctuel et espaceSeculaire
    func createNewEvent() -> Evenement {
        let unEvenement = Evenement()
        unEvenement.intitule = ""
        unEvenement.commentaire = ""
        unEvenement.dateDeb = Date()
        unEvenement.dateFin = Date()
        unEvenement.ponctuel = true
        unEvenement.typeLongTerme = true
        return unEvenement
    }
    
    func searchTitreEvent(titre:String, inListEvents: [Evenement]) -> Evenement? {
        for evt in inListEvents {
            if evt.intitule == titre {
                return evt
            }
        }
        return nil
    }
    
    // Si l'événement n'existe pas, on l'enregistre et on sauve la base
    func addEvent(unEvent:Evenement)->Bool {
        if let dejaLa = searchTitreEvent(titre: unEvent.intitule, inListEvents: lesEvenements) {
            return false
        } else {
            lesEvenements.append(unEvent)
            saveData()
            return true
        }
    }
    
    func modifyEvent(intitule:String, comment:String, debut:Date, fin:Date, longTerme: Bool, ponct:Bool) {
        if intitule != "" {
            // Tester si l'événement existe
            if let existantEvt = searchTitreEvent(titre: intitule, inListEvents: lesEvenements) {
                existantEvt.intitule = intitule
                existantEvt.commentaire = comment
                existantEvt.dateDeb = debut
                existantEvt.dateFin = fin
                existantEvt.typeLongTerme = longTerme
                existantEvt.ponctuel = ponct
                // On enregistre
                saveData()
            }
        }
    }
    
    func deleteEvent(evt:Evenement) {
        var trouve = -1
        for (index,value) in lesEvenements.enumerated(){
            if evt === value {
                trouve = index
            }
        }
        if trouve > -1 {
            removeFromChronologies(event: evt)
            lesEvenements.remove(at: trouve)
            saveData()
        }
    }
    
    // MARK: Gérer les chronologies -------------------------
    //------ Gérer les chronologies
    func searchChronologie(titre:String) -> Int {
        var trouve = -1
        for (index,value) in lesChronologies.enumerated(){
            if titre == value.intitule {
                trouve = index
            }
        }
        return trouve
    }
    func addChronologie(nom:String, longterme:Bool)  {
        if nom != "" {
            let dejaLa = searchChronologie(titre: nom)
            if dejaLa < 0 {
                var newChrono = Chronologie()
                newChrono.intitule = nom
                newChrono.typeLongTerme = longterme
                newChrono.mesEvenements = []
                lesChronologies.append(newChrono)
                //lesChronologies.sort(by: {$0.intitule < $1.intitule})
                saveChronologies()
            }
        }
    }
    
    func addEventToChronologie(unEvenement:Evenement, chrono:Chronologie) ->Chronologie {
        //A vérifier...
        // Il ne modifie pas l'objet passé mais renvoie une copie modifiée
        // Voir s'il ne faut pas modifier le tableau de chronologies
        if let evt = searchTitreEvent(titre: unEvenement.intitule, inListEvents: chrono.mesEvenements){
            return chrono
        }
        var nouvelleChrono = Chronologie()
        nouvelleChrono.intitule = chrono.intitule
        var lesEvt = chrono.mesEvenements
        lesEvt.append(unEvenement)
        // On trie
        lesEvt.sort(by: {$0.dateDeb < $1.dateDeb})
        nouvelleChrono.mesEvenements = lesEvt
        // On remplace chrono dans lesChronologies par nouvelleChron
        
        return nouvelleChrono
        //saveChronologies()
    }
    
    // remplace une chronologie par une autre dans la liste des chronomogies
    func replaceInListGlobal(Chrono: Chronologie, byNewChrono:Chronologie) {
        // On cherche l'emplacement de l'ancienne chronologie
        var indexForChrono = -1
        for i in 0..<lesChronologies.count {
            if Chrono == lesChronologies[i] {
                indexForChrono = i
            }
        }
        if indexForChrono > -1 {
            lesChronologies[indexForChrono] = byNewChrono
        }
    }
    
    // Enlève un evenement d'une chronologie
    func deleteEventFromChronologie(unEvenement:Evenement, fromChronologie:Chronologie) -> Chronologie {
        
        var result:Chronologie = fromChronologie
        var indexEvent = -1
        for i in 0..<fromChronologie.mesEvenements.count {
            if unEvenement === fromChronologie.mesEvenements[i]{
                indexEvent = i
            }
        }
        if indexEvent > -1 {
            result.mesEvenements.remove(at: indexEvent)
        }
        return result
    }
    // Enlève un evenement de toutes les chronologies
    func removeFromChronologies(event:Evenement)  {
        for uneChrono in lesChronologies {
            _ = deleteEventFromChronologie(unEvenement: event, fromChronologie: uneChrono)
        }
    }
    
    
    
    // MARK: Gestion des enregistrements de données --------------------------------------
    //----- Gestion des enregistrements de données---
    //Sauvegarder les chronologies(lesChronologies)
    func saveChronologies()  {
        // Save lesEvenements in userdefault
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(lesChronologies) {
            if let json = String(data: encoded, encoding: .utf8) {
                //print(json)
                // enregistrer dans un fichier
                let fileName = "listchronologies"
                let dir = try? FileManager.default.url(for: .documentDirectory,
                                                       in: .userDomainMask, appropriateFor: nil, create: true)
                // Si on trouve le directory, on enregistre
                if let fileURL = dir?.appendingPathComponent(fileName).appendingPathExtension("txt") {
                    do{
                        try json.write(to: fileURL, atomically: true, encoding: .utf8)
                    }catch {
                        print("erreur d'écriture")
                    }
                    //print("saveChronologies fait : \(json)")
                }
            }
        }
    }
    
    func recallChronos() -> [Chronologie] {
        var recall:[Chronologie] = []
        // Récupération depuis un fichier
        let fileName = "listchronologies"
        let dir = try? FileManager.default.url(for: .documentDirectory,
                                               in: .userDomainMask, appropriateFor: nil, create: true)
        // Si on trouve le directory, on lit
        if let fileURL = dir?.appendingPathComponent(fileName).appendingPathExtension("txt") {
            // On récupère
            do {
                if  FileManager.default.fileExists(atPath: fileURL.path){
                    let data = try? FileManager.default.contents(atPath: fileURL.path)
                    let decoder = JSONDecoder()
                    if let mt = try? decoder.decode([Chronologie].self, from: data!!){
                        //print("\(mt)")
                        recall = mt
                    }
                }
                
            } catch {
                print("Failed reading from URL: \(fileURL), Error: ")
                recall = []
            }
        }
        //print("Sortie de recallIdent avec \(recall), ident = \(identConfig), \n, classes = \(listeClasses) \n")
        return recall
    }
    
    // MARK: Sauvegarder l'état actuel de la collecte des événements(lesEvenements)
    func saveData()  {
        // Save lesEvenements in userdefault
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(lesEvenements) {
            if let json = String(data: encoded, encoding: .utf8) {
                //print(json)
                // enregistrer dans un fichier
                let fileName = "totalevents"
                let dir = try? FileManager.default.url(for: .documentDirectory,
                                                       in: .userDomainMask, appropriateFor: nil, create: true)
                // Si on trouve le directory, on enregistre
                if let fileURL = dir?.appendingPathComponent(fileName).appendingPathExtension("txt") {
                    do{
                        try json.write(to: fileURL, atomically: true, encoding: .utf8)
                    }catch {
                        print("erreur d'écriture")
                    }
                    //print("saveData fait: \(json)")
                }
            }
        }
    }
    
    // MARK : Récupérer les événements et les mettre dans lesEvenements
    func recallData()->Bool {
        // recall data
        var resultat = false
        // Récupération depuis un fichier
        let fileName = "totalevents"
        let dir = try? FileManager.default.url(for: .documentDirectory,
                                               in: .userDomainMask, appropriateFor: nil, create: true)
        // Si on trouve le directory, on lit
        if let fileURL = dir?.appendingPathComponent(fileName).appendingPathExtension("txt") {
            // on lit
            //var inString = ""
            do {
                //let inString = try String(contentsOf: fileURL)
                guard let data = try FileManager.default.contents(atPath: fileURL.path) else {
                    return resultat
                }
                let decoder = JSONDecoder()
                let mt = try? decoder.decode([Evenement].self, from: data)
                
                lesEvenements = mt!
                //print("mémoire total : \(memoireTotale)")
                resultat = true
            } catch {
                //print("Failed reading from URL: \(fileURL), Error: " + error.localizedDescription)
                lesEvenements = []
            }
            //print("Read from the file: \(fileURL)")
        }
        return resultat
    }
    

}

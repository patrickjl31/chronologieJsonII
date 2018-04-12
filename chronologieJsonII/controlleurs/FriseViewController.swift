//
//  friseViewController.swift
//  chronologieJson
//
//  Created by patrick lanneau on 31/01/2018.
//  Copyright © 2018 patrick lanneau. All rights reserved.
//

import UIKit

class FriseViewController: UIViewController {
    
    @IBOutlet weak var titreFrise: UILabel!
    
    @IBOutlet weak var saveToPdfButton: UIButton!
    
    
    public var lesChronos: GestionChronologie?
    public var laChrono: [Evenement]?
    public var monTitre = ""

    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    @IBOutlet weak var label6: UILabel!
    @IBOutlet weak var label7: UILabel!
    @IBOutlet weak var label8: UILabel!
    @IBOutlet weak var label9: UILabel!
    @IBOutlet weak var label0: UILabel!
    
    
    var etiquettes : [UILabel] = []
    
    var debut = Date()
    var fin = Date()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let envoyer = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(sendPDF))
        
        navigationItem.rightBarButtonItem = envoyer
    }
    @objc func sendPDF()  {
        //print("J'envoie le PDF)")
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        var path = paths[0] as String
        path = path + "/default.pdf"
        if !FileManager.default.fileExists(atPath: path){
            // On sauve
            let monPath = createPdfFromView(aView: self.view, saveToDocumentsWithFileName: "default.pdf")
        }
        let url = NSURL(fileURLWithPath: path)
        let controller = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        controller.popoverPresentationController?.sourceView = self.view
        self.present(controller, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.title = monTitre
        titreFrise.text = monTitre
        etiquettes = [label0, label1, label2, label3, label4, label5, label6, label7, label8, label9 ]
        let bornes = datesExtremes(listeEvt: laChrono!)
        
        debut = bornes.deb
        fin = bornes.fin
        let lesLabels = decoupePeriode(En: 10, depuis: debut, jusqua: fin)
        for i in 0..<10{
            etiquettes[i].text = lesLabels[i]
            etiquettes[i].layer.borderWidth = 1
            etiquettes[i].layer.borderColor = UIColor.lightGray.cgColor
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
     */
     
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ponctuels" {
            let vc = segue.destination as! VueEvtPonctuelsViewController
            vc.mesChronos = lesChronos
            vc.debutTemps = debut
            vc.finTemps = fin
            
        }
        
        if segue.identifier == "EvtLongs" {
            let vcl = segue.destination as! VueEvtLongsViewController
            vcl.mesChronos = lesChronos
            vcl.debutTemps = debut
            vcl.finTemps = fin
        }
 
    }
    
    @IBAction func saveToPDF(_ sender: UIButton) {
        // On cache le bouton
        saveToPdfButton.isHidden = true
        // On sauve
        let monPath = createPdfFromView(aView: self.view, saveToDocumentsWithFileName: "default.pdf")
        // On rend le bouton à nouveau visible
        saveToPdfButton.isHidden = false
    }
    // gérer l'affichage des postit des événements
    
    
    // renvoie les dates extrèmes de la base
    func datesExtremes(listeEvt : [Evenement]) -> (deb: Date, fin: Date) {
        if listeEvt.count > 1 {
            let debut = listeEvt.first?.dateDeb
            var fin = debut
            for evt in listeEvt {
                if evt.ponctuel {
                    if evt.dateDeb > fin! {
                        fin = evt.dateFin
                    }
                } else {
                    if evt.dateFin > fin! {
                        fin = evt.dateFin
                    }
                }
            }
            
            return (debut!, fin!)
        } else {
            if listeEvt.count == 1 {
                if listeEvt[0].ponctuel {
                    var debut = listeEvt.first!.dateDeb
                    let dureeAnnee:TimeInterval = 60 * 60 * 24 * 365.24
                    //let df = DateFormatter()
                    debut = Date(timeIntervalSince1970: (debut.timeIntervalSince1970 - dureeAnnee))//debut.timeIntervalSince1970 - dureeAnnee
                    let fin = Date(timeIntervalSince1970: (debut.timeIntervalSince1970 + dureeAnnee + dureeAnnee))
                    return(debut, fin)
                } else {
                    return (listeEvt[0].dateDeb, listeEvt[0].dateFin)
                }
            }
            return (Date(), Date())
        }
    }
    
    // Renvoie la liste des dates des EN périodes de la frise
    // pour indiquer une échelle au lecteur.
    func decoupePeriode(En:Int, depuis:Date, jusqua:Date) -> [String] {
        var result:[String] = []
        var deb = depuis
        var fin = jusqua
        if depuis > jusqua {
            deb = jusqua
            fin = depuis
        }
        let dureeTotale = fin.timeIntervalSince1970 - deb.timeIntervalSince1970
        let portions = dureeTotale / Double(En)
        let demiPortion = portions / 2
        let dureeAnnee:TimeInterval = 60 * 60 * 24 * 365.24
        let df = DateFormatter()
        if portions > (dureeAnnee * Double(En) / 2) {
            df.dateFormat = "yyyy"
        } else {
            df.dateFormat = "MMM-yyyy"
        }
        for i in 0..<En {
            let uneDate = deb.timeIntervalSince1970 + (portions * Double(i)) + demiPortion
            let dateS = df.string(from: Date(timeIntervalSince1970: uneDate))
            result.append(dateS)
        }
        return result
    }
    
    
    //----------------------------------------------
    // ----- Transformer la vue en PDF
    // appel :     monPath = createPdfFromView(aView: self.view, saveToDocumentsWithFileName: "default.pdf")
    // --- To PDF
    func createPdfFromView(aView: UIView, saveToDocumentsWithFileName fileName: String)->String
    {
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, aView.bounds, nil)
        UIGraphicsBeginPDFPage()
        
        guard let pdfContext = UIGraphicsGetCurrentContext() else { return "echec1"}
        
        aView.layer.render(in: pdfContext)
        UIGraphicsEndPDFContext()
        
        if let documentDirectories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            let documentsFileName = documentDirectories + "/" + fileName
            debugPrint(documentsFileName)
            pdfData.write(toFile: documentsFileName, atomically: true)
            return documentsFileName
        }
        return "echec2"
    }
    


}

//
//  PopListFileTableViewController.swift
//  chronologieJsonII
//
//  Created by patrick lanneau on 17/04/2018.
//  Copyright © 2018 patrick lanneau. All rights reserved.
//

import UIKit

class PopListFileTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var fileList: UITableView!
    
    public var chrono: GestionChronologie?
    public var pere: ViewController?
    
    var laListe:[String] = ["a","b","e"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
        laListe = myDirectory()
        if laListe.count < 1 {
            // On quitte
            dismiss(animated: true, completion: nil)
        }
        
        let hTotale = laListe.count * 44
        self.preferredContentSize = CGSize(width: 200, height: hTotale)
        
        self.fileList.delegate = self
        self.fileList.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func myDirectory()->[String]{
        //let worksFiles = []
        let filemgr = FileManager.default
        let dirPath = filemgr.urls(for: .documentDirectory, in: .userDomainMask)
        let docsDir = dirPath[0].path
        var monDir = [String]()
        do{
            let fileList = try filemgr.contentsOfDirectory(atPath: docsDir)
            for file in fileList{
                let elems = extractPrefix(fileName: file)
                if elems.count > 0 {
                    if !monDir.contains(elems) {
                        monDir.append(elems)
                    }
                }
            }
        } catch{
            print(NSLocalizedString("Writing error", comment: "erreur d'écriture"))
        }
        return monDir
    }
    
    func extractPrefix(fileName:String) -> String {
        let listElems = fileName.components(separatedBy: ".")
        let lgr = listElems.count
        if lgr == 3 {
            return listElems[0]
        }
        return ""
    }
    
    // MARK: - Table view data source
    /*
     func numberOfSections(in tableView: UITableView) -> Int {
     // #warning Incomplete implementation, return the number of sections
     return 1
     }
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return laListe.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fileName", for: indexPath)
        
        // Configure the cell...
        //print("-> \(laListe[indexPath.row])")
        cell.detailTextLabel?.text = laListe[indexPath.row]
        cell.textLabel?.text = laListe[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("\(laListe[indexPath.row])")
        //fileList.setEditing(true, animated: true)
        // On enregistre le nom de la série courante
        chrono?.currentWorkFileName = laListe[indexPath.row]
        chrono?.setCurrentFileName(to: laListe[indexPath.row])
        // chrono va ouvrir
        chrono?.openFilesAs()
        pere?.rafraichirTables()
        pere?.gererAffichage()
        //print("sortie de \(laListe[indexPath.row])")
        // On quitte
        dismiss(animated: true, completion: nil)
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

//
//  ArchivedViewController.swift
//  Notes
//
//  Created by IMCS2 on 2/15/19.
//  Copyright © 2019 IMCS2. All rights reserved.
//

import UIKit
import FirebaseDatabase
class ArchivedViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var tableView: UITableView!

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return completed.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Archived_Cell") as! UITableViewCell
        //Read data from db
        
        print("Reloading : \(completed)")
        cell.textLabel?.text = completed[indexPath.row]
        
        
       // let arr:[String] = UserDefaults.standard.array(forKey: "completed") as! [String]
       // cell?.textLabel?.text = completed[indexPath.row]
        return cell
         }
    
    //ViewDid Load
    override func viewDidLoad() {
        super.viewDidLoad()
        let ref = Database.database().reference()
        ref.child("Completed").observeSingleEvent(of: .value) { (dataSnapShot) in
            var db = (dataSnapShot.value )
            print("Notes from the DB view did load archivced\(db)")
            completed = db as AnyObject as? [String] ?? []
            print("Notes in array \(completed)")
            self.tableView.reloadData()
    }
        
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

        
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                
                // remove the item from the data model
                completed.remove(at: indexPath.row)
                let ref = Database.database().reference()
                
                ref.child("Completed").setValue(completed)
                // UserDefaults.standard.set(notes, forKey: "notes")
                
                // delete the table view row
                tableView.deleteRows(at: [indexPath], with: .fade)
                //UserDefaults.standard.set(notes, forKey: "notes")
                self.tableView.reloadData()
            }
        }
    }


//
//  ViewController.swift
//  Notes
//
//  Created by IMCS2 on 2/13/19.
//  Copyright © 2019 IMCS2. All rights reserved.
//

import UIKit
import FirebaseDatabase
var completed: [String] = []
class ViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var receivedString: String = ""
    var notes : [String] = []
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       print("Table view method for count called")
        return notes.count

    }
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    print("tableview for cell called")
        let cell = tableView.dequeueReusableCell(withIdentifier: "Prototype_Cell") as! UITableViewCell
        cell.textLabel?.text = notes[indexPath.row]
        return cell
    }
    

    override func viewDidLoad() {
        //notes = UserDefaults.standard.array(forKey: "notes") as! [String]
        super.viewDidLoad()
        print("value of user \(UserDefaults.standard.array(forKey: "completed"))")
        // Do any additional setup after loading the view, typically from a nib.
        
        let ref = Database.database().reference()
        ref.child("Notes").observeSingleEvent(of: .value) { (dataSnapShot) in
           var db = (dataSnapShot.value )
            print("Notes from the DB \(db)")
            self.notes = db as AnyObject as? [String] ?? []
            print("Notes in array \(self.notes)")
            self.tableView.reloadData()
        }
        
    }
    
    @IBAction func archivedPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name:"CompletedList",bundle: nil)
        let viewC = storyboard.instantiateViewController(withIdentifier:"CompletedList")
        self.navigationController?.pushViewController(viewC, animated: true)
    }
    
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue){
        notes.insert(receivedString, at: 0)
        // Add new note to Firebase
        let ref = Database.database().reference()

        ref.child("Notes").setValue(notes)
       // UserDefaults.standard.set(notes, forKey: "notes")
        self.tableView.reloadData()
        
    }
   

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // remove the item from the data model
            notes.remove(at: indexPath.row)
            let ref = Database.database().reference()
            
            ref.child("Notes").setValue(notes)
            // UserDefaults.standard.set(notes, forKey: "notes")
            
            // delete the table view row
            tableView.deleteRows(at: [indexPath], with: .fade)
            //UserDefaults.standard.set(notes, forKey: "notes")
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let done = UIContextualAction(style: .normal,title: "Completed"){(action,view, completion) in
            completed.insert(self.notes[indexPath.row], at:0)

            self.notes.remove(at: indexPath.row)
            
            let ref = Database.database().reference()
            ref.child("Notes").setValue(self.notes)
            // UserDefaults.standard.set(notes, forKey: "notes")
            
            // delete the table view row
            tableView.deleteRows(at: [indexPath], with: .fade)
            
           // UserDefaults.standard.set(self.notes, forKey: "notes")
            ref.child("Completed").setValue(completed)
           // UserDefaults.standard.set(completed, forKey: "completed")
            self.tableView.reloadData()
        }
        print(UserDefaults.standard.array(forKey: "completed"))
        return UISwipeActionsConfiguration(actions: [done])
        
    }

}


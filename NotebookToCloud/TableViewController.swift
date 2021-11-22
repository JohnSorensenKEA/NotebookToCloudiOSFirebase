//
//  TableViewController.swift
//  NotebookToCloud
//
//  Created by John Sørensen on 09/09/2021.
//

import UIKit
import Firebase

class TableViewController: UITableViewController {

    var strings: [String] = []
    var currentNote = -1
    var notes: [Note] = []
    
    let db = Firestore.firestore() //Get a reference to the db
    let notesKey = "notes"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startListener()
        //insertData(txt: "new note")
    }

    func startListener() {
        db.collection(notesKey).addSnapshotListener { snapshot, error in
            if let e = error {
                print("error fetching notes: \(e)")
            } else {
                if let s = snapshot {
                    self.strings.removeAll()
                    self.notes.removeAll()
                    for doc in s.documents {
                        if let txt = doc.data()["txt"] as? String {
                            self.strings.append(txt)
                        }
                        let note = Note()
                        note.id = doc.documentID
                        note.txt = doc.data()["txt"] as? String ?? "none"
                        self.notes.append(note)
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func insertData(txt: String) {
        let document = db.collection(notesKey).document()
        var data = [String: String]()
        data["txt"] = txt
        document.setData(data)
    }
    
    func simpleDelete(index: Int) {
        //db.col(nk).doc(id).delete
    }
    
    func simpleEdit() {
        var data = [String: String]()
        data["txt"] = "edit test 123"
        db.collection(notesKey).document("").setData(data)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return strings.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
        
        // Configure the cell...
        
        let txt = strings[indexPath.row]
        if (txt.count > 25) {
            cell.textLabel?.text = String(txt.prefix(25)) + "..."
        } else {
            cell.textLabel?.text = txt
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentNote = indexPath.row
        performSegue(withIdentifier: "segue1", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ViewController {
            destination.num = currentNote
            destination.tableVC = self
            destination.db = db
            destination.notes = notes
        }
    }
    
    func updateTableView(){
        self.tableView.reloadData()
    }
}

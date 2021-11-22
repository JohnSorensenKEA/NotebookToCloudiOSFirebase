//
//  ViewController.swift
//  NotebookToCloud
//
//  Created by John Sørensen on 09/09/2021.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    var tableVC: TableViewController? = nil
    var num = -1
    var notebook: Notebook? = nil
    var db: Firestore? = nil
    var notes: [Note] = []
    
    let notesKey = "notes"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startListener()
        // Do any additional setup after loading the view.
    }
    
    func startListener() {
        
        db?.collection(notesKey).addSnapshotListener { snapshot, error in
            if let e = error {
                print("error fetching notes: \(e)")
            } else {
                if let s = snapshot {
                    
                    let doc = s.documents[self.num]
                    if let txt = doc.data()["txt"] as? String {
                        self.txtView.text = txt
                    }
                }
            }
        }
    }

    @IBOutlet weak var txtView: UITextView!
    
    @IBAction func savePressed(_ sender: Any) {
        //notebook?.updateNote(index: num, text: txtView.text)
        tableVC?.updateTableView()
    }
    
}


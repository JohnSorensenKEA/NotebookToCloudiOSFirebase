//
//  Notebook.swift
//  NotebookToCloud
//
//  Created by John Sørensen on 09/09/2021.
//

import Foundation
import Firebase

class Notebook {
    let db = Firestore.firestore() //Get a reference to the db
    let notesKey = "notes"
    
    init() {
    }
    
    /*
    func loadNotes() {
        notes.removeAll()
        db.collection(notesKey).addSnapshotListener { snapshot, error in
            if let e = error {
                print("some error \(e)")
            } else {
                if let docs = snapshot {
                    for doc in docs.documents {
                        self.notes.append(doc)
                        print(doc.data())
                        print(self.notes.count)
                        //self.s.append(doc.data()[1])
                    }
                }
            }
        }
    }
 */
    
    func getNote(index: Int) -> String {
        return getNotes()[index]
    }
    
    /*
    func updateNote(index: Int, text: String) {
        print(text)
        db.document(notesKey).setValue(text, forKeyPath: notes[index].documentID)
        print(notes[index].data())
    }
    */
    
    func getNotes() -> [String] {
        var strings: [String] = []
        
        db.collection(notesKey).addSnapshotListener { snapshot, error in
            if let e = error {
                print("some error \(e)")
            } else {
                if let docs = snapshot {
                    for doc in docs.documents {
                        strings.append(doc.data()["txt"] as! String)
                    }
                }
            }
        }
        return strings
    }
}

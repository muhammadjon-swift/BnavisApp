//
//  NoteViewController.swift
//  Bnavis
//
//  Created by Muhammadjon Loves on 6/26/22.
//

import UIKit

class NoteViewController: UIViewController, UITextFieldDelegate {
    
    let listView = ListNotesViewController()
    
    static let identifier = "NoteViewController"
    
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var textField: UITextField!
    
    var note: Note!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        noteTextView.delegate = self
        textField.text = note.title
        textField.isUserInteractionEnabled = false
        noteTextView.text = note.notetext
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        noteTextView.becomeFirstResponder()
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
    }
}

//MARK: - UITextView Delegate Methods

extension NoteViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        note.notetext = noteTextView.text
        listView.saveItems()
    }
}

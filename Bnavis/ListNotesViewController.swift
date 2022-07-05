//
//  ViewController.swift
//  Bnavis
//
//  Created by Muhammadjon Loves on 6/25/22.
//

import UIKit
import CoreData
import SwipeCellKit

class ListNotesViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var allNotes = [Note]()
    var noteT: Note!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNotes()
        tableView.rowHeight = 50.0
    }
    
    //MARK: - TableView Data Source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allNotes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotesCell", for: indexPath) as! SwipeTableViewCell
        cell.textLabel?.text = allNotes[indexPath.row].title
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        goToEditNote(allNotes[indexPath.row])
    }
    
    private func goToEditNote(_ note: Note) {
        let controller = storyboard?.instantiateViewController(identifier: NoteViewController.identifier) as! NoteViewController
        controller.note = note
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK:- Methods to implement
    private func createNote() -> Note {
        let note = Note(context: context)
        noteT = note
        noteT.notetext = ""
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Create ting", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Title", style: .default) { action in
            
            let titleq = textField.text
            self.noteT.title = titleq
            self.allNotes.append(self.noteT)
            self.tableView.reloadData()
   }
        alert.addAction(action)
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create ting"
            textField = alertTextField
        }
        present(alert, animated: true)
        saveItems()
        return noteT
    }
    
    //MARK: - Add Button Pressed
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        goToEditNote(createNote())
    }
    
    //MARK: - Data Manipulation
    func saveItems() {
        do {
            try context.save()
            print("WAS SUCCESFULL INIT/saving/changing")
        } catch {
            print("Error saving data/changing \(error)")
            print("ERRRRORRRRRRROROROROROROORORORROORR")
        }
    }
    
    func loadNotes(with request: NSFetchRequest<Note> = Note.fetchRequest(), predicate: NSPredicate? = nil) {
        if let safePredicate = predicate {
            request.predicate = safePredicate
        }
        do {
            allNotes = try context.fetch(request)
        } catch {
            print("There was an error \(error)")
        }
        tableView.reloadData()
    }
}
//MARK: - UISearchBar Delegate Methods

extension ListNotesViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)

        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadNotes(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadNotes()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

//MARK: - Swipe TableView Methods

extension ListNotesViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            self.context.delete(self.allNotes[indexPath.row])
            self.allNotes.remove(at: indexPath.row)
            self.saveItems()
            tableView.reloadData()
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "Trash")

        return [deleteAction]
    }
}

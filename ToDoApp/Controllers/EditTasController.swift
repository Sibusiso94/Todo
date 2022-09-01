//
//  EditTasController.swift
//  ToDoApp
//
//  Created by Sibusiso Mbonani on 2022/08/31.
//

import UIKit
import CoreData

class EditTasController: UIViewController {
    
    var tasks = [Task]()
    var text: String?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var indexPath: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        loadTasks()
        
    }
    
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
//        let task = Task(context: self.context)
        print(tasks[indexPath!].taskTitle)
//        print(tasks)
        
//        self.tasks[indexPath.row].setValue(textField.text!, forKey: "taskTitle")
        
        saveTasks()
        
    }
    
}

// MARK: - Data Manipulation
extension EditTasController {
    
    func saveTasks() {
        do {
            try context.save()
        } catch {
            print("Error saving task: \(error)")
        }
        
//        tableView.reloadData()
    }
    
    func loadTasks() {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        
        request.predicate = NSPredicate(format: "taskArchived == 0")
        
        do {
            tasks = try context.fetch(request)
        } catch {
            print("Error fetching tasks: \(error)")
        }
        
//        tableView.reloadData()
    }
    
}

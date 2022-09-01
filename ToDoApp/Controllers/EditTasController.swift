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
    var date: String = ""
    var time: String = ""
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var indexPath: Int?
    
    @IBOutlet weak var task: UITextField!
    @IBOutlet weak var taskDesc: UITextField!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        loadTasks()
        
    }
    
    @IBAction func dateTimeSelected(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        let timeFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        timeFormatter.dateFormat = "HH:mm"
//        formatter.dateStyle = .long
//        formatter.timeStyle = .short
        
        date = dateFormatter.string(from: sender.date)
        time = timeFormatter.string(from: sender.date)
    }
    
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        
        let item = tasks[indexPath!]
        if let title = task.text, let descr = taskDesc.text {
            
            item.setValue(title, forKey: "taskTitle")
            item.setValue(descr, forKey: "taskDescription")
            item.setValue(date, forKey: "taskDate")
            item.setValue(time, forKey: "taskTime")
            print(title)
            print(descr)
    //        self.tasks[indexPath.row].setValue(textField.text!, forKey: "taskTitle")
            saveTasks()
        } else {
            print("Not all entered")
        }
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

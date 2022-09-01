//
//  EditTasController.swift
//  ToDoApp
//
//  Created by Sibusiso Mbonani on 2022/08/31.
//

import UIKit
import CoreData

class EditTasController: UIViewController {
    
//    var tasks = [Task]()
    var date: String = ""
    var time: String = ""
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var indexPath: Int?
    let nav = NavAppearance()
    let dbh = DatabaseHandler()
    let vc = ViewController()
    
    @IBOutlet weak var task: UITextField!
    @IBOutlet weak var taskDesc: UITextField!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        nav.homeNavAppearance(navigationItem)
//        task.text = tasks[indexPath!].taskTitle
//        taskDesc.text = tasks[indexPath!].taskDescription
        
        dbh.loadTasks(to: vc.tableView)
        
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
        
        let item = dbh.tasks[indexPath!]
        
        if let title = task.text, let descr = taskDesc.text {
            
            item.setValue(title, forKey: "taskTitle")
            item.setValue(descr, forKey: "taskDescription")
            item.setValue(date, forKey: "taskDate")
            item.setValue(time, forKey: "taskTime")
            print(title)
            print(descr)
            dbh.saveTasks()
        } else {
            print("Not all entered")
        }
        
        let completeMessage = UIAlertController(title: "Successful", message: "Your task has been edited", preferredStyle: .alert)
        let okay = UIAlertAction(title: "Okay", style: .cancel) { (action) in
            print("Successful")
        }
        
        completeMessage.addAction(okay)
        self.present(completeMessage, animated: true, completion: nil)
        
        task.text = ""
        taskDesc.text = ""
    }
    
}

// MARK: - Data Manipulation
extension EditTasController {
    
//    func loadTasks() {
//        let request: NSFetchRequest<Task> = Task.fetchRequest()
//
//        request.predicate = NSPredicate(format: "taskArchived == 0")
//
//        do {
//            tasks = try context.fetch(request)
//        } catch {
//            print("Error fetching tasks: \(error)")
//        }
//    }
    
}

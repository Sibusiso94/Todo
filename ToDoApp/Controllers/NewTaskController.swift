//
//  NewTaskController.swift
//  ToDoApp
//
//  Created by Sibusiso Mbonani on 2022/08/31.
//

import UIKit

class NewTaskController: UIViewController {

    @IBOutlet weak var newTask: UITextField!
    @IBOutlet weak var taskDesc: UITextField!
    @IBOutlet weak var taskDate: UIDatePicker!
    
    var tasks = [Task]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var date: String = ""
    var time: String = ""
    let nav = NavAppearance()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nav.homeNavAppearance(navigationItem)
    }
    
    @IBAction func dateTimeChosen(_ sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        let timeFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        timeFormatter.dateFormat = "HH:mm"
//        formatter.dateStyle = .long
//        formatter.timeStyle = .short
        
        date = dateFormatter.string(from: sender.date)
        time = timeFormatter.string(from: sender.date)
        print(date)
        print(time)
        
    }
    
    @IBAction func addTaskCliced(_ sender: UIBarButtonItem) {
        
        let task = Task(context: self.context)
        if let newTask = newTask.text, let newDesc = taskDesc.text {
            task.taskTitle = newTask
            task.taskDescription = newDesc
            task.taskDate = date
            task.taskTime = time
            task.taskIsDone = false
            task.taskArchived = false
            
            self.tasks.append(task)
            self.saveTasks()
            
            let completeMessage = UIAlertController(title: "Successful", message: "Your task has been successfully addded", preferredStyle: .alert)
            let okay = UIAlertAction(title: "Okay", style: .cancel) { (action) in
                print("Successful")
            }
            
            completeMessage.addAction(okay)
            self.present(completeMessage, animated: true, completion: nil)
            
        }
    }
}

// MARK: - Data Manipulation
extension NewTaskController {
    
    func saveTasks() {
        do {
            try context.save()
        } catch {
            print("Error saving task: \(error)")
        }
        
//        tableView.reloadData()
    }
    
}

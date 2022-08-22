//
//  ViewController.swift
//  ToDoApp
//
//  Created by Sibusiso Mbonani on 2022/08/22.
//

import UIKit
import CoreData

class ViewController: UITableViewController {
    
    var tasks = [Task]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let nav = NavAppearance()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nav.homeNavAppearance(navigationItem)
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadTasks()
    }

    // MARK: - Add A New Task
    @IBAction func addTaskPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add a Task", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Task", style: .default) { (action) in
            
            let newTask = Task(context: self.context)
            newTask.taskTitle = textField.text
            newTask.taskIsDone = false
            newTask.taskArchived = false
            
            self.tasks.append(newTask)
            self.saveTasks()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Task"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - Data Manipulation Methods
extension ViewController {
    
    func saveTasks() {
        do {
            try context.save()
        } catch {
            print("Error saving task: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadTasks() {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            tasks = try context.fetch(request)
        } catch {
            print("Error fetching tasks: \(error)")
        }
    }
}

// MARK: - Table view data source
extension ViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
        cell.textLabel?.text = tasks[indexPath.row].taskTitle
        
        // value = condition ? valueIfTrue : valuIfFalse
        cell.accessoryType = tasks[indexPath.row].taskIsDone ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // equals the opposite, reverses what it used to be. Instead of if else
        tasks[indexPath.row].taskIsDone = !tasks[indexPath.row].taskIsDone
        self.saveTasks()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}

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
    var archivedTasks = [Task]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let nav = NavAppearance()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nav.homeNavAppearance(navigationItem)
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadTasks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadTasks()
        tableView.reloadData()
    }

    // MARK: - Add A New Task
    @IBAction func addTaskPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add a Task", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Task", style: .default) { (action) in
            
            let date = self.getDate()
            
            let newTask = Task(context: self.context)
            newTask.taskTitle = textField.text
            newTask.taskDate = date
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
        present(alert, animated: true, completion: {
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOutside)))
        })
    }
    
    @objc func dismissOnTapOutside() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func archivePressed(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "goToArchive", sender: self)
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
        
        request.predicate = NSPredicate(format: "taskArchived == 0")
        
        do {
            tasks = try context.fetch(request)
        } catch {
            print("Error fetching tasks: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func getDate() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let currentDate = dateFormatter.string(from: date)
        return currentDate
    }
}

// MARK: - Search Bar Methods
extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        
        if let searchText = searchBar.text {
            request.predicate = NSPredicate(format: "taskTitle CONTAINS[cd] %@", searchText)
            request.sortDescriptors = [NSSortDescriptor(key: "taskTitle", ascending: true)]
            
            do {
                tasks = try context.fetch(request)
            } catch {
                print("Error fetching tasks: \(error)")
            }
            
            tableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadTasks()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

// MARK: - Table view data source
extension ViewController {
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        
        let archivedAction = UITableViewRowAction(style: .normal, title: "Remove") { action, indexPath in
            var dbArchive: Int
            
            self.tasks[indexPath.row].taskArchived = !self.tasks[indexPath.row].taskArchived
            dbArchive = self.tasks[indexPath.row].taskArchived ? 1 : 0
            print(dbArchive)
            print(self.tasks[indexPath.row].taskArchived)
            
            self.tasks[indexPath.row].setValue(dbArchive, forKey: "taskArchived")
            self.saveTasks()
            self.loadTasks()
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { action, indexPath in
            
            var textField = UITextField()
            let alert = UIAlertController(title: self.tasks[indexPath.row].taskTitle, message: "", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Edit", style: .default) { (action) in
                self.tasks[indexPath.row].setValue(textField.text!, forKey: "taskTitle")
                
                self.saveTasks()
            }
            
            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "Edit Task"
                textField = alertTextField
            }
            
            alert.addAction(action)
            self.present(alert, animated: true, completion: {
                alert.view.superview?.isUserInteractionEnabled = true
                alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOutside)))
            })
        }
        
        archivedAction.backgroundColor = UIColor(red: 0.96, green: 0.78, blue: 0.92, alpha: 1.0)
        editAction.backgroundColor = UIColor(red: 0.88, green: 0.94, blue: 0.92, alpha: 1.0)
        
        return [archivedAction, editAction]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskCell
        cell.taskLabel.text = tasks[indexPath.row].taskTitle
        cell.dateTaskLabel.text = tasks[indexPath.row].taskIsDone ? "Complete" : tasks[indexPath.row].taskDate
        
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

//
//  ViewController.swift
//  ToDoApp
//
//  Created by Sibusiso Mbonani on 2022/08/22.
//

import UIKit
import CoreData

class ViewController: UITableViewController {
    
    //var tasks = [Task]()
    var archivedTasks = [Task]()
    var editIndexPath: Int?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let nav = NavAppearance()
    let dbh = DatabaseHandler()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nav.homeNavAppearance(navigationItem)
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        dbh.loadTasks(to: tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dbh.loadTasks(to: tableView)
        tableView.reloadData()
    }

    // MARK: - Add A New Task
    
    @IBAction func archivePressed(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "goToArchive", sender: self)
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
                dbh.tasks = try context.fetch(request)
            } catch {
                print("Error fetching tasks: \(error)")
            }
            
            tableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            dbh.loadTasks(to: tableView)
            
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
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let item = tasks[indexPath.row]
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, completion) in
            self.editIndexPath = indexPath.row
            self.performSegue(withIdentifier: "goToEdit", sender: indexPath)
        }
        
        let archiveAction = UIContextualAction(style: .normal, title: "Archive", handler: { (action, view, completion) in
            var dbArchive: Int
            
            self.dbh.tasks[indexPath.row].taskArchived = !self.dbh.tasks[indexPath.row].taskArchived
            dbArchive = self.dbh.tasks[indexPath.row].taskArchived ? 1 : 0
            print(dbArchive)
            print(self.dbh.tasks[indexPath.row].taskArchived)
            
            self.dbh.tasks[indexPath.row].setValue(dbArchive, forKey: "taskArchived")
            self.dbh.saveTasks()
            self.tableView.reloadData()
            self.dbh.loadTasks(to: tableView)
        })
        
        archiveAction.backgroundColor = UIColor(red: 0.96, green: 0.78, blue: 0.92, alpha: 1.0)
        editAction.backgroundColor = UIColor(red: 0.88, green: 0.94, blue: 0.92, alpha: 1.0)
        
        return UISwipeActionsConfiguration(actions: [editAction, archiveAction])
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? EditTasController {
            destination.indexPath = editIndexPath
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dbh.tasks.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let taskModel = dbh.tasks[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskCell
        
         cell.setUp(title: taskModel.taskTitle!, description: taskModel.taskDescription!, date: taskModel.taskDate!, time: taskModel.taskTime!, isDone: taskModel.taskIsDone)
//        cell.taskLabel.text = tasks[indexPath.row].taskTitle
//        cell.dateTaskLabel.text = tasks[indexPath.row].taskIsDone ? "Complete" : tasks[indexPath.row].taskDate
        cell.completeDelegate = self
        
        return cell
    }
    
    func isDone(for index: Int) {
        dbh.tasks[index].taskIsDone.toggle()
        dbh.saveTasks()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // equals the opposite, reverses what it used to be. Instead of if else
//        tasks[indexPath.row].taskIsDone = !tasks[indexPath.row].taskIsDone
//        self.saveTasks()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController: Completable {

    func toggleComplete(for cell: UITableViewCell) {

        if let indexPath = tableView.indexPath(for: cell) {
            isDone(for: indexPath.row)
            tableView.reloadData()
        }
    }
}


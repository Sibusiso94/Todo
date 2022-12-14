//
//  ArchiveController.swift
//  ToDoApp
//
//  Created by Sibusiso Mbonani on 2022/08/23.
//

import UIKit
import CoreData

class ArchiveController: UITableViewController {
    
    var data: [Task]?
//    var archivedTasks = [Task]()
    let nav = NavAppearance()
    let vc = ViewController()
    let dbh = DatabaseHandler()

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nav.archiveNavAppearance(navigationItem)
        dbh.loadArchived(to: tableView)
        
    }
    
//    func loadArchived() {
//        let request: NSFetchRequest<Task> = Task.fetchRequest()
//        
//        request.predicate = NSPredicate(format: "taskArchived == 1")
//        
//        do {
//            archivedTasks = try context.fetch(request)
//            
//        } catch {
//            print("Could not fetch Archived data: \(error)")
//        }
//
//        tableView.reloadData()
//    }
}

extension ArchiveController {
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let item = tasks[indexPath.row]
        
        let returnAction = UIContextualAction(style: .normal, title: "Return") { (action, view, completion) in
            var dbArchive: Int
            
            self.dbh.archivedTasks[indexPath.row].taskArchived = !self.dbh.archivedTasks[indexPath.row].taskArchived
            dbArchive = self.dbh.archivedTasks[indexPath.row].taskArchived ? 1 : 0
            print(dbArchive)
            print(self.dbh.archivedTasks[indexPath.row].taskArchived)
            
            self.dbh.archivedTasks[indexPath.row].setValue(dbArchive, forKey: "taskArchived")
            self.dbh.saveTasks()
            self.tableView.reloadData()
            self.dbh.loadArchived(to: tableView)
            self.vc.dbh.loadTasks(to: tableView)
        }
        
        let deleteAction = UIContextualAction(style: .normal, title: "Delete", handler: { (action, view, completion) in
            let deleteMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this Task?", preferredStyle: .alert)
            
            let yes = UIAlertAction(title: "Yes", style: .default) { (action) in
                self.context.delete(self.dbh.archivedTasks[indexPath.row])
                self.dbh.archivedTasks.remove(at: indexPath.row)
                
                self.dbh.saveTasks()
                self.tableView.reloadData()
                self.dbh.loadArchived(to: tableView)
            }
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                print("Cancelled")
            }
            
            deleteMessage.addAction(yes)
            deleteMessage.addAction(cancel)
            
            self.present(deleteMessage, animated: true, completion: nil)
        })
        
        deleteAction.backgroundColor = UIColor(red: 0.96, green: 0.78, blue: 0.92, alpha: 1.0)
        returnAction.backgroundColor = UIColor(red: 0.88, green: 0.94, blue: 0.92, alpha: 1.0)
        
        return UISwipeActionsConfiguration(actions: [returnAction, deleteAction])
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dbh.archivedTasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "archivedTask", for: indexPath) as! ArchiveCell
        cell.taskLabel.text = dbh.archivedTasks[indexPath.row].taskTitle
        return cell
    }
}

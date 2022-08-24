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
    var archivedTasks = [Task]()
    let nav = NavAppearance()
    let vc = ViewController()

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nav.archiveNavAppearance(navigationItem)
        loadArchived()
        
    }
    
    func loadArchived() {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        
        request.predicate = NSPredicate(format: "taskArchived == 1")
        
        do {
            archivedTasks = try context.fetch(request)
            
        } catch {
            print("Could not fetch Archived data: \(error)")
        }

        tableView.reloadData()
    }
    
    func saveTasks() {
        do {
            try context.save()
        } catch {
            print("Error saving task: \(error)")
        }
        
        tableView.reloadData()
    }
}

extension ArchiveController {
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        
        let returnAction = UITableViewRowAction(style: .normal, title: "Return") { action, indexPath in
            var dbArchive: Int
            
            self.archivedTasks[indexPath.row].taskArchived = !self.archivedTasks[indexPath.row].taskArchived
            dbArchive = self.archivedTasks[indexPath.row].taskArchived ? 1 : 0
            print(dbArchive)
            print(self.archivedTasks[indexPath.row].taskArchived)
            
            self.archivedTasks[indexPath.row].setValue(dbArchive, forKey: "taskArchived")
            self.saveTasks()
            self.loadArchived()
            self.vc.loadTasks()
        }
        
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { action, indexPath in
            
            self.context.delete(self.archivedTasks[indexPath.row])
            self.archivedTasks.remove(at: indexPath.row)
            
            self.saveTasks()
            self.loadArchived()
        }
        
        return [returnAction, deleteAction]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        archivedTasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "archivedTask", for: indexPath) as! ArchiveCell
        cell.taskLabel.text = archivedTasks[indexPath.row].taskTitle
        return cell
    }
}

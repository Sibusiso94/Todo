//
//  DatabaseHandler.swift
//  ToDoApp
//
//  Created by Sibusiso Mbonani on 2022/08/25.
//

import UIKit
import CoreData

protocol TaskLoadable {
    func loadTasks()
}

class DatabaseHandler {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var tasks = [Task]()
    var archivedTasks = [Task]()
    
    func saveTasks() {
        do {
            try context.save()
        } catch {
            print("Error saving task: \(error)")
        }
    }
    
    func loadTasks(to tableView: UITableView) {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        
        request.predicate = NSPredicate(format: "taskArchived == 0")
        
        do {
            tasks = try context.fetch(request)
        } catch {
            print("Error fetching tasks: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadArchived(to tableView: UITableView) {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        
        request.predicate = NSPredicate(format: "taskArchived == 1")
        
        do {
            archivedTasks = try context.fetch(request)
            
        } catch {
            print("Could not fetch Archived data: \(error)")
        }

        tableView.reloadData()
    }
    
}

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

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let safeData = data {
            archivedTasks = safeData
            tableView.reloadData()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        archivedTasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "archivedTask", for: indexPath)
        cell.textLabel?.text = archivedTasks[indexPath.row].taskTitle
        return cell
    }
    
//    func loadArchived() {
//        let request: NSFetchRequest<Task> = Task.fetchRequest()
//        var data = [Task]()
//        do {
//            data = try context.fetch(request)
//            for d in data {
//                if d.taskArchived {
//                    archivedTasks.append(d)
//                } else {
//                    tasks.append(d)
//                }
//            }
//        } catch {
//            print("Could not fetch Archived data: \(error)")
//        }
//
//        tableView.reloadData()
//    }

    
}

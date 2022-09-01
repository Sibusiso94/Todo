//
//  DatabaseHandler.swift
//  ToDoApp
//
//  Created by Sibusiso Mbonani on 2022/08/25.
//

import UIKit
import CoreData

class DatabaseHandler {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveTasks() {
        do {
            try context.save()
        } catch {
            print("Error saving task: \(error)")
        }
        
//        tableView.reloadData()
    }
    
}

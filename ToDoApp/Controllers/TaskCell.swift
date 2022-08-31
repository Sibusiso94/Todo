//
//  TaskCell.swift
//  ToDoApp
//
//  Created by Sibusiso Mbonani on 2022/08/24.
//

import UIKit

protocol Completable {
    func toggleComplete(for cell: UITableViewCell)
}

class TaskCell: UITableViewCell {
    
    var completeDelegate: Completable?
    
    @IBOutlet var taskLabel: UILabel!
    @IBOutlet var descTaskLabel: UILabel!
    @IBOutlet var dateTaskLabel: UILabel!
    @IBOutlet var timeTaskLabel: UILabel!
    @IBOutlet var taskImage: UIImageView!
    @IBOutlet var taskView: UIView!
    @IBOutlet var taskTextView: UIView!
    @IBOutlet weak var checkButton: UIButton!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        taskImage.tintColor = UIColor(red: 0.88, green: 0.94, blue: 0.92, alpha: 1.0)
        taskView.layer.cornerRadius = taskView.frame.size.height / 5
        taskView.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.00)
        taskTextView.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.00)

//        taskView.backgroundColor = UIColor(red: 0.98, green: 0.96, blue: 0.72, alpha: 1.00)

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setUp(title: String, description: String, date: String, time: String, isDone: Bool) {
        
        taskLabel.text = title
        descTaskLabel.text = description
        dateTaskLabel.text = date
        timeTaskLabel.text = time
        
        if isDone {
            checkButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        } else {
            checkButton.setImage((UIImage(systemName: "square")), for: .normal)
        }
        
        //         value = condition ? valueIfTrue : valuIfFalse
        //        cell.accessoryType = tasks[indexPath.row].taskIsDone ? .checkmark : .none
    }
    
    @IBAction func doneButtonClicked(_ sender: UIButton) {
        
        completeDelegate?.toggleComplete(for: self)
    }

}

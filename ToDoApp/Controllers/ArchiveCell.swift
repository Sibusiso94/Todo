//
//  ArchiveCell.swift
//  ToDoApp
//
//  Created by Sibusiso Mbonani on 2022/08/24.
//

import UIKit

class ArchiveCell: UITableViewCell {
    
    @IBOutlet var taskLabel: UILabel!
    @IBOutlet var taskImage: UIImageView!
    @IBOutlet var taskView: UIView!
    @IBOutlet var taskTextView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        taskImage.tintColor = UIColor(red: 0.96, green: 0.78, blue: 0.92, alpha: 1.0)
        taskView.layer.cornerRadius = taskView.frame.size.height / 5
        taskView.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.00)
        taskTextView.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.00)

    }

}

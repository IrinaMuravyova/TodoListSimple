//
//  TodoCell.swift
//  TodoListSimple
//
//  Created by Irina Muravyeva on 11.02.2025.
//

import UIKit

class TodoCell: UITableViewCell {
    @IBOutlet weak var completedImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func configure(with todo: Todo) {
        completedImageView.image = todo.completed
            ? UIImage(systemName: "checkmark.circle")
            : UIImage(systemName: "circle")
        titleLabel.text = todo.title
        descriptionLabel.text = todo.description
        dateLabel.text = todo.data.formatted(date: .numeric, time: .omitted)
    }
}

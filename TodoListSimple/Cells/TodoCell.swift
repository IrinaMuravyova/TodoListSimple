//
//  TodoCellView.swift
//  TodoListSimple
//
//  Created by Irina Muravyeva on 11.02.2025.
//

import UIKit

class TodoCell: UIView {
    @IBOutlet weak var completedImageView: UIImageView!
    @IBOutlet weak var todoTextView: UIView!
    private var todoTextCellView: TodoTextCellView!

    private func setupBaseView() {
        todoTextCellView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configure(with todo: Todo) {
        completedImageView.image = todo.completed
            ? UIImage(systemName: "checkmark.circle")
            : UIImage(systemName: "circle")

        todoTextCellView.configure(with: todo)
    }
    
}

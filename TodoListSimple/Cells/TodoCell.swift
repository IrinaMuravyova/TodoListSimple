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
    
    private var currentTodo: Todo?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let menu = UIContextMenuInteraction(delegate: self)
        self.addInteraction(menu)
    }
    
    func configure(with todo: Todo) {
        currentTodo = todo
        completedImageView.image = todo.completed
            ? UIImage(systemName: "checkmark.circle")
            : UIImage(systemName: "circle")
        titleLabel.text = todo.title
        descriptionLabel.text = todo.description
        dateLabel.text = todo.date.formatted(date: .numeric, time: .omitted)
    }
}

extension TodoCell: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
                let editAction = UIAction(title: "Редактировать", image: UIImage(systemName: "pencil")) { _ in

                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    if let editVC = storyboard.instantiateViewController(withIdentifier: "EditTodoViewController") as? EditTodoViewController {
                        editVC.todo = self.currentTodo
                        editVC.openedForEdit = true
                        if let navigationController = self.window?.rootViewController as? UINavigationController {
                            editVC.delegate = navigationController.topViewController as? TodoListViewController
                            navigationController.pushViewController(editVC, animated: true)
                        }
                    }
                }
                
                let deleteAction = UIAction(title: "Удалить", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                    print("Сообщение удалено")
                }
                
                return UIMenu(title: "", children: [editAction, deleteAction])
            }
    }
}

//
//  EditTodoViewController.swift
//  TodoListSimple
//
//  Created by Irina Muravyeva on 10.02.2025.
//

import UIKit

protocol EditTodoViewControllerDelegate: AnyObject {
    func addTodo(_ todo: Todo)
}

class EditTodoViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    private var newTodo: Todo?
    
    weak var delegate: EditTodoViewControllerDelegate?
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            createTodo()
            
            guard let newTodo = newTodo else { return }
            
            if !todoIsNil() {
                delegate?.addTodo(newTodo)
            }
        }
        
        func todoIsNil() -> Bool {
            return !checkIsNil(titleTextField)
                && !checkIsNil(dateTextField)
                && !checkIsNil(descriptionTextField)
        }
        
        func checkIsNil(_ textField: UITextField!) -> Bool {
            guard let field = textField else {
                return false
            }
            return field.text!.isEmpty
        }
        
        func createTodo() {
            newTodo = Todo(
                    id: UUID(),
                    title: titleTextField.text!,
                    description: descriptionTextField.text!,
                    data: formatDate(dateTextField.text!),
                    completed: false
            )
        }
        
        func formatDate(_ dateString: String) -> Date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yy"
            if let date = dateFormatter.date(from: dateString) {
                return date
            } else {
                return Date()
            }
        }
    }
}

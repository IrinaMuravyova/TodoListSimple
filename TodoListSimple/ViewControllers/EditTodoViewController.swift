//
//  EditTodoViewController.swift
//  TodoListSimple
//
//  Created by Irina Muravyeva on 10.02.2025.
//

import UIKit

protocol EditTodoViewControllerDelegate: AnyObject {
    func add(_ todo: Todo)
    func update(_ todo: Todo)
}

class EditTodoViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    var todo: Todo?
    var openedForEdit: Bool = false
    
    weak var delegate: EditTodoViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if openedForEdit {
            titleTextField.text = todo?.title
            descriptionTextField.text = todo?.description
            dateTextField.text = todo?.date.formatted(date: .numeric, time: .omitted)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            createTodo()
            guard let todo = todo else { return }
            guard !todoIsNil() else { return }
         
            if openedForEdit {
                delegate?.update(todo)
                openedForEdit = false
            } else {
                delegate?.add(todo)
            }
        }
    }
}

//MARK: - Private methods
extension EditTodoViewController {
    private func todoIsNil() -> Bool {
        return checkIsNil(titleTextField)
            && checkIsNil(dateTextField)
            && checkIsNil(descriptionTextField)
    }
    
    private func checkIsNil(_ textField: UITextField!) -> Bool {
        guard let field = textField else {
            return true
        }
        return field.text!.isEmpty
    }
    
    private func createTodo() {
        var id = UUID()
        if let todo = todo, openedForEdit {
            id = todo.id
        }
        todo = Todo(
                id: id,
                title: titleTextField.text!,
                description: descriptionTextField.text!,
                date: formatDate(dateTextField.text!),
                completed: false
        )
    }
    
    private func formatDate(_ dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yy"
        if let date = dateFormatter.date(from: dateString) {
            return date
        } else {
            return Date()
        }
    }
}

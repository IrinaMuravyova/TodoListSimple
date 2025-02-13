//
//  TodoListViewController.swift
//  TodoListSimple
//
//  Created by Irina Muravyeva on 10.02.2025.
//

import UIKit

class TodoListViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var todosTableView: UITableView!
    @IBOutlet weak var todosCountButtonItem: UIBarButtonItem!
    var todos: [Todo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // для тестирования
        todos = Todo.getTodos()
        
        todosTableView.dataSource = self
        todosTableView.delegate = self
        todosTableView.register(UINib(nibName: "TodoCell", bundle: nil), forCellReuseIdentifier: "TodoCell")
        
        setTodosCount(todos.count)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditViewController",
           let editVC = segue.destination as? EditTodoViewController {
            editVC.delegate = self
        }
    }
    
    private func setTodosCount(_ todosCount: Int) {
        let todosCountString = pluralizeTask(count: todosCount)
        displayTodosCount(todosCountString)
    }
    
    private func displayTodosCount(_ todosCountString: String) {
        todosCountButtonItem.title = todosCountString
    }
    
    private func pluralizeTask(count: Int) -> String {
        let remainder10 = count % 10
        let remainder100 = count % 100

        let word: String
        if remainder10 == 1 && remainder100 != 11 {
            word = "задача"
        } else if (2...4).contains(remainder10) && !(12...14).contains(remainder100) {
            word = "задачи"
        } else {
            word = "задач"
        }

        return "\(count) \(word)"
    }
}

extension TodoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as? TodoCell  else {
            print("Ошибка приведения ячейки к типу TodoCell")
            return UITableViewCell()
        }
        let todo = todos[indexPath.row]
        cell.configure(with: todo)
        return cell
    }
}

extension TodoListViewController: EditTodoViewControllerDelegate {
    func add(_ todo: Todo) {
        todos.append(todo)
        todosTableView.reloadData()
        setTodosCount(todos.count)
    }
    
    func update(_ todo: Todo) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index] = todo
        }
        todosTableView.reloadData()
    }
}

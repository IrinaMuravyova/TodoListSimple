//
//  TodoListViewController.swift
//  TodoListSimple
//
//  Created by Irina Muravyeva on 10.02.2025.
//

import UIKit

protocol TodoCellDelegate: AnyObject {
    func delete(_ todo: Todo)
}

final class TodoListViewController: UIViewController {
    @IBOutlet weak private var searchBar: UISearchBar!
    @IBOutlet weak private var todosTableView: UITableView!
    @IBOutlet weak private var todosCountButtonItem: UIBarButtonItem!
    
    private var todos: [Todo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // для тестирования
//        todos = Todo.getTodos()
//        UserDefaultsManager.clearUserDefaults()

        todosTableView.dataSource = self
        todosTableView.delegate = self
        todosTableView.register(UINib(nibName: "TodoCell", bundle: nil), forCellReuseIdentifier: "TodoCell")
    
        configure()
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

    private func fetchTodos() {
        NetworkManager.share.fetchTodos { [weak self] todos in
            self?.todos = todos
            UserDefaultsManager.save(todos)
            self?.todosTableView.reloadData()
            self?.setTodosCount(todos.count)
        }
    }
    
    private func configure() {
        let haveBeenLaunched = UserDefaultsManager.checkIsFirstLaunch()
        if !haveBeenLaunched {
            fetchTodos()
            UserDefaultsManager.setMarkIsFirstLaunch()
        } else {
            todos = UserDefaultsManager.loadTodos()
        }
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
        cell.delegate = self
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

extension TodoListViewController: TodoCellDelegate {
    func delete(_ todo: Todo) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos.remove(at: index)
        }
        setTodosCount(todos.count)
        todosTableView.reloadData()
    }
}

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let filteredTodos = search(in: todos, with: searchText)
        self.displayTodos(filteredTodos)
    }
    
    func search(in todos: [Todo], with query: String) -> [Todo] {
        if query.isEmpty {
            return todos
        } else {
            let filteredTodos = todos.filter { 
                $0.title.lowercased().contains(query.lowercased()) ||
                $0.description.lowercased().contains(query.lowercased())
            }
            return filteredTodos
        }
    }
    
    func displayTodos(_ todos: [Todo]) {
        self.todos = todos
        todosTableView.reloadData()
    }
}

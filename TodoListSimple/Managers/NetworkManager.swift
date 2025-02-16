//
//  NetworkManager.swift
//  TodoListSimple
//
//  Created by Irina Muravyeva on 16.02.2025.
//

import UIKit

final class NetworkManager {
    
    static let share = NetworkManager()
    
    private init() {
        
    }
    
    func fetchTodos(completion: @escaping ([Todo]) -> Void) {
        guard let url = URL(string: "https://dummyjson.com/todos") else {
            completion([])
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                completion([])
                return
            }
            
            do {
                let dataResponse = try JSONDecoder().decode(TodosResponse.self, from: data)
                let todos = dataResponse.todos.map { todo in
                    Todo(
                        id:UUID(),
                        title: todo.todo,
                        description: "",
                        date: Date(),
                        completed: todo.completed
                    )
                }
                DispatchQueue.main.async {
                    completion(todos)
                }
            } catch let error {
                print(error.localizedDescription)
                completion([])
            }
        }
        dataTask.resume()
    }
}

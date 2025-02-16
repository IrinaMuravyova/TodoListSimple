//
//  TodoResponse.swift
//  TodoListSimple
//
//  Created by Irina Muravyeva on 16.02.2025.
//

struct TodoResponse: Decodable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}

struct TodosResponse: Decodable {
    let todos: [TodoResponse]
}

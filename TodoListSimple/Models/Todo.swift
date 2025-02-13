//
//  Todo.swift
//  TodoListSimple
//
//  Created by Irina Muravyeva on 11.02.2025.
//

import Foundation

struct Todo {
    let id: UUID
    let title: String
    let description: String
    let date: Date
    let completed: Bool
    
    // для тестирования
    static func getTodos() -> [Todo] {
        [
            Todo(id: UUID(), title: "Тренировка", description: "Сходить на тренировку", date: Date(), completed: false),
            Todo(id: UUID(), title: "Зарегистрироваться на тест", description: "Бронь на 9 марта центр тестирования в Шеньжень. Заплатить взнос, добавить в календарь.", date: Date(), completed: false),
            Todo(id: UUID(), title: "Проверить почту", description: "", date: Date(), completed: false)
        ]
    }
}

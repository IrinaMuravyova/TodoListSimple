//
//  UserDefaultsManager.swift
//  TodoListSimple
//
//  Created by Irina Muravyeva on 16.02.2025.
//

import Foundation

class UserDefaultsManager {
    
    static private let usersTodosKey = "usersTodos"
    static private let isFirstLaunchKey = "isFirstLaunch"
    
    static func save(_ todos: [Todo]) {
       let encoder = JSONEncoder()
       do {
           let data = try encoder.encode(todos)
           UserDefaults.standard.set(data, forKey: usersTodosKey)
       } catch {
           print("Error encoding todos: \(error)")
       }
    }
   
   static func loadTodos() -> [Todo] {
       guard let data = UserDefaults.standard.data(forKey: usersTodosKey) else {
           return []
       }
       
       let decoder = JSONDecoder()
       do {
           let todos = try decoder.decode([Todo].self, from: data)
           return todos
       } catch {
           print("Error decoding todos: \(error)")
           return []
       }
   }
    
    static func checkIsFirstLaunch()-> Bool {
        UserDefaults.standard.bool(forKey: isFirstLaunchKey)
    }
    
    static func setMarkIsFirstLaunch() {
        UserDefaults.standard.set(true, forKey: isFirstLaunchKey)
    }
    
    // для тестирования
    static func clearUserDefaults(){
        let keys = [isFirstLaunchKey, usersTodosKey]
        keys.forEach { 
            UserDefaults.standard.setValue(nil, forKey: $0)
        }
    }
}

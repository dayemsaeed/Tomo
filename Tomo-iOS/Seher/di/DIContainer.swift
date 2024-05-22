//
//  DIContainer.swift
//  Seher
//
//  Created by Dayem Saeed on 5/22/24.
//

import Swinject

class DIContainer {
    static let shared = DIContainer()
    let container: Container

    private init() {
        container = Container()

        // Register services
        container.register(ChatService.self) { _ in ChatService() }
        container.register(NameRepository.self) { _ in NameRepository() }
        container.register(TaskRepository.self) { _ in TaskRepository() }

        // Register view models
        container.register(LoginViewModel.self) { resolver in
            LoginViewModel()
        }
        container.register(NameViewModel.self) { resolver in
            NameViewModel(/*nameRepository: resolver.resolve(NameRepository.self)!*/)
        }
        container.register(TaskViewModel.self) { resolver in
            TaskViewModel(/*taskRepository: resolver.resolve(TaskRepository.self)!*/)
        }
        container.register(ChatViewModel.self) { resolver in
            ChatViewModel(chatService: resolver.resolve(ChatService.self)!)
        }
        container.register(RegisterViewModel.self) { resolver in
            RegisterViewModel()
        }
        container.register(TaskCellViewModel.self) { resolver in
            TaskCellViewModel(task: Task(title: "", startDate: "", completed: false, completedIcon: ""))
        }
    }
}

//
//  DIContainer.swift
//  Seher
//
//  Created by Dayem Saeed on 5/22/24.
//

import Swinject
import Supabase

class DIContainer {
    static let shared = DIContainer()
    let container: Container

    private init() {
        container = Container()
    }

    func initializeDependencies() async {
        // Initialize Supabase client
        let supabaseClient = SupabaseClientProvider.makeSupabaseClient()

        // Register Supabase client
        container.register(SupabaseClient.self) { _ in supabaseClient }

        // Register TaskRepository with pre-initialized SupabaseClient
        container.register(TaskRepository.self) { _ in
            TaskRepository()
        }

        // Register other dependencies
        container.register(ChatService.self) { _ in ChatService() }
        container.register(NameRepository.self) { _ in NameRepository() }
        container.register(LoginViewModel.self) { resolver in
            LoginViewModel(supabaseClient: supabaseClient)
        }
        container.register(RegisterViewModel.self) { resolver in
            RegisterViewModel(supabaseClient: supabaseClient)
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
        container.register(TaskCellViewModel.self) { resolver in
            TaskCellViewModel(/*task: TaskItem(title: "", startDate: "", completed: false, completedIcon: "")*/)
        }
    }
}

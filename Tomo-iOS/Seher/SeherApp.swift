//
//  SeherApp.swift
//  Seher
//
//  Created by Dayem Saeed on 5/25/24.
//

import SwiftUI
import Firebase
import Swinject
import SwiftData

@main
struct MyApp: App {
    let persistenceController = PersistenceController.shared
    let supabaseClient = SupabaseClientProvider.makeSupabaseClient()
    let loginViewModel: LoginViewModel
    let registerViewModel: RegisterViewModel
    let taskViewModel: TaskViewModel
    let chatViewModel: ChatViewModel
    
    init() {
        self.loginViewModel = LoginViewModel(supabaseClient: self.supabaseClient)
        self.registerViewModel = RegisterViewModel(supabaseClient: self.supabaseClient)
        self.taskViewModel = TaskViewModel()
        self.chatViewModel = ChatViewModel(chatService: ChatService())
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(loginViewModel)
                .environmentObject(registerViewModel)
                .environmentObject(taskViewModel)
                //.environmentObject(DIContainer.shared.container.resolve(NameViewModel.self)!)
                .environmentObject(chatViewModel)
        }
        .modelContainer(for: [TaskItem.self, ChatMessage.self])
    }
}

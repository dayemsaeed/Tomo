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
import Supabase
import UserNotifications

@main
struct MyApp: App {
    @StateObject private var appState: AppState
    
    init() {
        let supabaseClient = SupabaseClientProvider.makeSupabaseClient()
        _appState = StateObject(wrappedValue: AppState(supabaseClient: supabaseClient))
        
        // Request notification permissions
        Task {
            do {
                let granted = try await NotificationManager.shared.requestAuthorization()
                print("Notification authorization granted: \(granted)")
            } catch {
                print("Error requesting notification authorization: \(error)")
            }
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState.loginViewModel)
                .environmentObject(appState.registerViewModel)
                .environmentObject(appState.taskViewModel)
                .environmentObject(appState.chatViewModel)
        }
    }
}

// Create a new class to handle app state
class AppState: ObservableObject {
    let loginViewModel: LoginViewModel
    let registerViewModel: RegisterViewModel
    let taskViewModel: TaskViewModel
    let chatViewModel: ChatViewModel
    
    init(supabaseClient: SupabaseClient) {
        self.loginViewModel = LoginViewModel(supabaseClient: supabaseClient)
        self.registerViewModel = RegisterViewModel(supabaseClient: supabaseClient)
        self.taskViewModel = TaskViewModel(taskRepository: TaskRepository(supabaseClient: supabaseClient))
        self.chatViewModel = ChatViewModel(
            chatService: ChatService(),
            supabaseClient: supabaseClient
        )
    }
}

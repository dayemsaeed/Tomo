//
//  TaskRepository.swift
//  Tomo
//
//  Created by Dayem Saeed on 10/3/23.
//

import Foundation
import Supabase

class TaskRepository: ObservableObject {
    private let supabaseClient: SupabaseClient

    init(supabaseClient: SupabaseClient) {
        self.supabaseClient = supabaseClient
    }

    func getCurrentUserId() -> String? {
        return supabaseClient.auth.currentSession?.user.id.uuidString
    }

    func storeTask(task: TaskItem) async throws {
        // Ensure the user is authenticated
        guard (supabaseClient.auth.currentSession?.user.id) != nil else {
            throw NSError(domain: "TaskRepository", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
        }

        let payload = task.toPayload()
        
        do {
            try await supabaseClient
                .from("tasks")
                .insert(payload)
                .execute()
        } catch {
            print("Supabase error: \(error)")
            throw error
        }
    }

    func getTask(taskId: UUID) async throws {
        // Ensure the user is authenticated
        if supabaseClient.auth.currentSession == nil {
            do {
                let _ = try await supabaseClient.auth.refreshSession()
            } catch {
                throw error
            }
        }

        let tasks: [TaskItemResponse] = try await supabaseClient
            .from("tasks")
            .select()
            .eq("id", value: taskId.uuidString)
            .execute()
            .value

        guard tasks.first != nil else {
            throw URLError(.badServerResponse)
        }
    }

    func fetchAllTasks() async throws -> [TaskItem] {
        // Ensure the user is authenticated
        if supabaseClient.auth.currentSession == nil {
            do {
                let _ = try await supabaseClient.auth.refreshSession()
            } catch {
                throw error
            }
        }

        // Fetch tasks from Supabase
        let tasks: [TaskItemResponse] = try await supabaseClient
            .from("tasks")
            .select()
            .eq("task_created_by", value: supabaseClient.auth.currentUser?.id)
            .execute()
            .value

        return tasks.map { TaskItem(response: $0) }
    }

    func updateTaskCompletion(_ task: TaskItem) async throws {
        guard let userId = supabaseClient.auth.currentSession?.user.id else {
            throw NSError(domain: "TaskRepository", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
        }
        
        do {
            try await supabaseClient
                .from("tasks")
                .update(["task_completed": task.isCompleted])
                .eq("id", value: task.id)
                .eq("task_created_by", value: userId.uuidString)
                .execute()
            
            print("Task completion updated successfully: \(task.id), completed: \(task.isCompleted)")
        } catch {
            print("Supabase error updating task completion: \(error)")
            throw error
        }
    }

    func deleteTask(task: TaskItem) async throws {
        guard let userId = supabaseClient.auth.currentSession?.user.id else {
            throw NSError(domain: "TaskRepository", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
        }
        
        do {
            try await supabaseClient
                .from("tasks")
                .delete()
                .eq("id", value: task.id)
                .eq("task_created_by", value: userId.uuidString)  // Ensure user owns the task
                .execute()
            
            print("Task deleted successfully: \(task.id)")
        } catch {
            print("Supabase error deleting task: \(error)")
            throw error
        }
    }
}

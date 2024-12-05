//
//  TaskViewModel.swift
//  Tomo
//
//  Created by Dayem Saeed on 10/9/23.
//

import Foundation
import Supabase
import Combine

@MainActor
class TaskViewModel: ObservableObject {
    
    @Published var tasks: [TaskItem] = []
    
    private let taskRepository: TaskRepository
    
    init(taskRepository: TaskRepository) {
        self.taskRepository = taskRepository
    }
    
    func getCurrentUserId() -> String? {
        return taskRepository.getCurrentUserId()
    }
    
    func fetchTasks() async {
        do {
            let fetchedTasks = try await taskRepository.fetchAllTasks()
            DispatchQueue.main.async {
                self.tasks = fetchedTasks
            }
        } catch {
            print("Error fetching tasks: \(error)")
        }
    }
    
    func storeTask(task: TaskItem) async throws -> Void {
        do {
            try await taskRepository.storeTask(task: task)
            
            // Automatically schedule notification for the task
            NotificationManager.shared.scheduleTaskReminder(for: task)
            
        } catch {
            print("Error storing task: \(task). Error: \(error.localizedDescription)")
        }
    }
    
    func updateTaskCompletion(task: TaskItem) async {
        do {
            try await taskRepository.updateTaskCompletion(task)
            
            if task.isCompleted {
                // Cancel notification if task is completed
                NotificationManager.shared.cancelReminder(for: task.id)
            } else {
                // Reschedule notification if task is uncompleted
                NotificationManager.shared.scheduleTaskReminder(for: task)
            }
            
            await fetchTasks()
        } catch {
            print("Error updating task completion: \(error.localizedDescription)")
        }
    }
    
    func deleteTask(task: TaskItem) async {
        do {
            try await taskRepository.deleteTask(task: task)
            await fetchTasks()
        } catch {
            print("Error deleting task: \(error.localizedDescription)")
        }
    }
    
}

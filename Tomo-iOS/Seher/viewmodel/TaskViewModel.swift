//
//  TaskViewModel.swift
//  Tomo
//
//  Created by Dayem Saeed on 10/9/23.
//

import Foundation
import Combine

class TaskViewModel: ObservableObject {
    @Published var taskCellViewModels = [TaskCellViewModel]()
    @Published var taskCellListViewModels = [TaskCellViewModel]()
    
    private var cancellables = Set<AnyCancellable>()
    internal var taskRepository = TaskRepository()
    
    init() {
        taskRepository.loadTodaysTasks()
        // Load tasks for the day
        taskRepository.$todaysTasks.map { tasks in
            tasks.map { task in
                TaskCellViewModel(task: task)
            }
        }
        .assign(to: \.taskCellViewModels, on: self)
        .store(in: &cancellables)
        
        taskRepository.loadAllTasks()
        // Load all tasks
        taskRepository.$tasks.map { tasks in
            tasks.map { task in
                TaskCellViewModel(task: task)
            }
        }
        .assign(to: \.taskCellListViewModels, on: self)
        .store(in: &cancellables)
    }
    
    func addTask(task: Task) {
        taskRepository.updateTask(task)
    }
    
    func removeTasks(atOffsets indexSet: IndexSet) {
        // Get tasks to remove
        let tasksToRemove = indexSet.lazy.map { self.taskCellViewModels[$0].task }
        
        // Remove tasks from repository
        tasksToRemove.forEach { task in
            taskRepository.deleteTask(task)
        }
    }
}

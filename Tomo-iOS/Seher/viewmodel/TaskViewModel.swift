//
//  TaskViewModel.swift
//  Tomo
//
//  Created by Dayem Saeed on 10/9/23.
//

import Foundation
import Combine

class TaskViewModel: ObservableObject {
//    private let taskRepository: TaskRepository
//
//    @Published var taskCellViewModels = [TaskCellViewModel]()
//    @Published var taskCellListViewModels = [TaskCellViewModel]()
//    
//    private var cancellables = Set<AnyCancellable>()
//    
//    init(taskRepository: TaskRepository) {
//        self.taskRepository = taskRepository
//        
//        taskRepository.loadTodaysTasks()
//        taskRepository.$todaysTasks
//            .map { tasks in tasks.map { TaskCellViewModel(task: $0) } }
//            .assign(to: \.taskCellViewModels, on: self)
//            .store(in: &cancellables)
//        
//        taskRepository.loadAllTasks()
//        taskRepository.$tasks
//            .map { tasks in tasks.map { TaskCellViewModel(task: $0) } }
//            .assign(to: \.taskCellListViewModels, on: self)
//            .store(in: &cancellables)
//    }
//    
//    func addTask(task: Task) {
//        taskRepository.updateTask(task)
//    }
//    
//    func removeTasks(atOffsets indexSet: IndexSet) {
//        let tasksToRemove = indexSet.lazy.map { self.taskCellViewModels[$0].task }
//        tasksToRemove.forEach { task in
//            taskRepository.deleteTask(task)
//        }
//    }
//
//    func toggleTaskCompletion(_ task: Task) {
//        var updatedTask = task
//        updatedTask.completed.toggle()
//        taskRepository.updateTask(updatedTask)
//    }
}

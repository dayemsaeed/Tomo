//
//  TaskViewModel.swift
//  PetSupport
//
//  Created by Dayem Saeed on 5/5/21.
//

import Foundation
import Combine
import FirebaseAuth

class TaskViewModel : ObservableObject {
    var taskRepository = TaskRepository()
    @Published var taskCellViewModels = [TaskCellViewModel]()
    @Published var taskCellListViewModels = [TaskCellViewModel]()

    private var cancellables = Set<AnyCancellable>()
    
    init() {
        if Auth.auth().currentUser != nil {
            taskRepository.loadData()
            taskRepository.$todaysTasks
                .map { tasks in
                tasks.map { task in
                    TaskCellViewModel(task: task)
                }
            }
            .assign(to: \.taskCellViewModels, on: self)
            .store(in: &cancellables)
            
            taskRepository.loadAllTasks()
            taskRepository.$tasks
                .map { tasks in
                    tasks.map { task in
                        TaskCellViewModel(task: task)
                    }
                }
                .assign(to: \.taskCellListViewModels, on: self)
                .store(in: &cancellables)
        }
    }
    
    func addTask(task: Task) {
        let taskVM = TaskCellViewModel(task: task)
        self.taskCellViewModels.append(taskVM)
    }
    
}

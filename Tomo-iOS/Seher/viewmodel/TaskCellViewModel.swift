//
//  TaskCellViewModel.swift
//  Tomo
//
//  Created by Dayem Saeed on 10/9/23.
//

import Foundation
import Combine

class TaskCellViewModel : ObservableObject, Identifiable {
    @Published var task : TaskItem
    
    var id = ""
    @Published var completionIconName = ""
    private var cancellables = Set<AnyCancellable>()
    
    init(task: TaskItem) {
        self.task = task
        
        $task
            .map {
                task in task.isCompleted ? "checkmark.circle.fill" : "circle"
            }
            .assign(to: \.completionIconName, on: self)
            .store(in: &cancellables)
        
        $task
            .compactMap { task in
                task.id
            }
        .assign(to: \.id, on: self)
        .store(in: &cancellables)
    }
}

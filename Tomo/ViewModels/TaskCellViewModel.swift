//
//  TaskCellViewModel.swift
//  PetSupport
//
//  Created by Dayem Saeed on 5/7/21.
//

import Foundation
import Combine

class TaskCellViewModel : ObservableObject, Identifiable {
    @Published var task : Task
    
    var id = ""
    @Published var completionIconName = ""
    private var cancellables = Set<AnyCancellable>()
    
    init(task: Task) {
        self.task = task
        
        $task
            .map {
                task in task.completed ? "checkmark.circle.fill" : "circle"
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

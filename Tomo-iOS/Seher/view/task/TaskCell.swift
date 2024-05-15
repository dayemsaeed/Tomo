//
//  TaskCell.swift
//  Tomo
//
//  Created by Dayem Saeed on 10/9/23.
//

import Foundation
import SwiftUI

struct TaskCell : View {
    @ObservedObject var taskViewModel : TaskCellViewModel
    
    var body: some View {
        let task = taskViewModel.task
        HStack {
            Image(systemName: task.completed ? "checkmark.circle.fill" : "circle")
                .resizable()
                .frame(width: 20, height: 20)
            Text(task.title)
                .font(.system(size: 18))
                .strikethrough(task.completed)
        }
    }
}

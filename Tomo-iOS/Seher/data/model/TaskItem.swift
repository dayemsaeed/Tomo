//
//  TaskItem.swift
//  Seher
//
//  Created by Dayem Saeed on 10/29/24.
//

import SwiftUI

class TaskItem: Identifiable, ObservableObject {
    var id: String
    @Published var taskTitle: String
    @Published var creationDate: Date
    @Published var description: String
    @Published var isCompleted: Bool
    @Published var colorValue: Int64
    var createdBy: String

    // Computed property to get a SwiftUI Color from the colorValue
    var tintColor: Color {
        return colorFromValue(colorValue)
    }

    // Main initializer
    init(id: String = UUID().uuidString, taskTitle: String, creationDate: Date = Date(), description: String = "", isCompleted: Bool = false, colorValue: Int64, createdBy: String) {
        self.id = id
        self.taskTitle = taskTitle
        self.creationDate = creationDate
        self.description = description
        self.isCompleted = isCompleted
        self.colorValue = colorValue
        self.createdBy = createdBy
    }

    // Initializer to create TaskItem from TaskItemResponse
    convenience init(response: TaskItemResponse) {
        self.init(
            id: response.id,
            taskTitle: response.taskTitle,
            creationDate: response.creationDate,
            description: response.description,
            isCompleted: response.isCompleted,
            colorValue: response.colorValue,
            createdBy: response.createdBy
        )
    }

    // Method to create TaskItemPayload from TaskItem
    func toPayload() -> TaskItemPayload {
        return TaskItemPayload(
            id: self.id,
            taskTitle: self.taskTitle,
            creationDate: self.creationDate,
            description: self.description,
            isCompleted: self.isCompleted,
            colorValue: self.colorValue,
            createdBy: self.createdBy
        )
    }

    // Function to map integer color values to actual colors
    func colorFromValue(_ value: Int64) -> Color {
        switch value {
        case 1: return .taskColor1
        case 2: return .taskColor2
        case 3: return .taskColor3
        case 4: return .taskColor4
        case 5: return .taskColor5
        default: return .black
        }
    }
}

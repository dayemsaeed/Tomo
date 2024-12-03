//
//  TaskItem.swift
//  Seher
//
//  Created by Dayem Saeed on 10/3/23.
//

import SwiftUI

struct TaskItemPayload: Encodable {
    var id: String
    var taskTitle: String
    var creationDate: Date
    var description: String
    var isCompleted: Bool
    var colorValue: Int64
    var createdBy: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case taskTitle = "task_title"
        case creationDate = "task_created_at"
        case description = "task_description"
        case isCompleted = "task_completed"
        case colorValue = "task_tint"
        case createdBy = "task_created_by"
    }
}

extension Date {
    static func updateHour(_ value: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .hour, value: value, to: .init()) ?? .init()
    }
}

//
//  TaskItem.swift
//  Seher
//
//  Created by Dayem Saeed on 10/29/24.
//

import SwiftUI

struct TaskItemResponse: Decodable, Identifiable {
    var id: String
    var taskTitle: String
    var creationDate: Date
    var description: String
    var isCompleted: Bool
    var colorValue: Int64
    var createdBy: String

    // Map coding keys to match Supabase response keys
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

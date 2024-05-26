//
//  PersistenceController.swift
//  Seher
//
//  Created by Dayem Saeed on 5/25/24.
//

import SwiftData

class PersistenceController {
    static let shared = PersistenceController()
    let container: ModelContainer

    init() {
        // Initialize the ModelContainer with the TaskItem model
        container = try! ModelContainer(for: TaskItem.self)
    }
}

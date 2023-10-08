//
//  Task.swift
//  Tomo
//
//  Created by Dayem Saeed on 10/3/23.
//

import Foundation
import FirebaseFirestoreSwift

struct Task: Codable, Identifiable {
    @DocumentID var id: String?
    var title: String
    var startDate: Date
    var completed: Bool
    var completedIcon: String
}

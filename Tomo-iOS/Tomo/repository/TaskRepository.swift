//
//  TaskRepository.swift
//  Tomo
//
//  Created by Dayem Saeed on 10/3/23.
//

import Foundation
import FirebaseFirestore

class TaskRepository: ObservableObject {
    
    let db = Firestore.firestore()
    
    @Published var tasks = [Task]()
    
}

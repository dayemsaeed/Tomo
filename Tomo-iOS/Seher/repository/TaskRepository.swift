//
//  TaskRepository.swift
//  Tomo
//
//  Created by Dayem Saeed on 10/3/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class TaskRepository : ObservableObject {
    
//    private let db = Firestore.firestore()
//    private var userTasksCollection: CollectionReference {
//        db.collection("users").document(Auth.auth().currentUser?.uid ?? "").collection("tasks")
//    }
//    
//    @Published var todaysTasks = [Task]()
//    @Published var tasks = [Task]()
//    
//    private let dateToStringFormatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd-MMM-yyyy"
//        return formatter
//    }()
//    
//    func loadTodaysTasks() {
//        let todaysDate = dateToStringFormatter.string(from: Date())
//        print("LoadTodaysTasks (TaskRepository): " + todaysDate)
//        userTasksCollection
//            .whereField("startDate", isEqualTo: todaysDate)
//            .addSnapshotListener { querySnapshot, error in
//                if let error = error {
//                        print("Error fetching today's tasks: \(error.localizedDescription)")
//                        return
//                    }
//                self.todaysTasks = self.tasksFromSnapshot(querySnapshot)
//            }
//    }
//    
//    func loadAllTasks() {
//        userTasksCollection
//            .order(by: "startDate")
//            .addSnapshotListener { querySnapshot, error in
//                self.tasks = self.tasksFromSnapshot(querySnapshot)
//            }
//    }
//    
//    private func tasksFromSnapshot(_ querySnapshot: QuerySnapshot?) -> [Task] {
//        guard let documents = querySnapshot?.documents else {
//            print("Error fetching documents: \(String(describing: querySnapshot?.count))")
//            return []
//        }
//        
//        return documents.compactMap { document in
//            try? document.data(as: Task.self)
//        }
//    }
//    
//    func updateTask(_ task: Task) {
//        do {
//            try userTasksCollection.document(task.title).setData(from: task, merge: true)
//        } catch {
//            print("Unable to update task: \(error.localizedDescription)")
//        }
//    }
//    
//    func updateTaskWithNewTitle(_ task: Task, title: String) {
//        do {
//            try userTasksCollection.document(task.title).setData(from: task)
//            userTasksCollection.document(title).delete()
//        } catch {
//            print("Unable to update task: \(error.localizedDescription)")
//        }
//    }
//    
//    func deleteTask(_ task: Task) {
//        userTasksCollection.document(task.title).delete()
//    }
}

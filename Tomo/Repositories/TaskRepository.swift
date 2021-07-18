//
//  TaskRepository.swift
//  PetSupport
//
//  Created by Dayem Saeed on 5/7/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class TaskRepository : ObservableObject {
    
    let db = Firestore.firestore()
    
    @Published var todaysTasks = [Task]()
    @Published var tasks = [Task]()
    
    let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            return formatter
        }()
    
    let dateToStringFormatter = DateFormatter()
    init() {
        dateToStringFormatter.dateFormat = "d MMM y"
    }
    
    func loadData() {
        db.collection("users").document(Auth.auth().currentUser!.uid).collection("tasks").whereField("date", isEqualTo: dateToStringFormatter.string(from: Date())).addSnapshotListener { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                self.todaysTasks = querySnapshot.documents.compactMap { document in
                    do {
                        let x = try document.data(as: Task.self)
                        return x
                    }
                    catch {
                        print(error)
                    }
                    return nil
                }
            }
        }
    }
    
    func loadAllTasks() {
        db.collection("users").document(Auth.auth().currentUser!.uid).collection("tasks").order(by: "date")
            .addSnapshotListener {
                (querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    self.tasks = querySnapshot.documents.compactMap { document in
                        do {
                            let x = try document.data(as: Task.self)
                            return x
                        }
                        catch {
                            print(error)
                        }
                        return nil
                    }
                }
            }
    }
    
    func updateTask(_ task: Task) {
        do {
            try db.collection("users").document(Auth.auth().currentUser!.uid).collection("tasks").document(task.title).setData(from: task, merge: true)
        }
        catch {
            fatalError("Unable to update task: \(error.localizedDescription)")
        }
    }
    
    func updateTaskNewTitle(_ task: Task, title: String) {
        do {
            try db.collection("users").document(Auth.auth().currentUser!.uid).collection("tasks").document(task.title).setData(from: task)
            db.collection("users").document(Auth.auth().currentUser!.uid).collection("tasks").document(title).delete()
        }
        catch {
            fatalError("Unable to update task: \(error.localizedDescription)")
        }
    }
    
    func deleteTask(_ task: Task) {
        db.collection("users").document(Auth.auth().currentUser!.uid).collection("tasks").document(task.title).delete()
    }
}

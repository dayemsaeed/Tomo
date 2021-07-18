////
////  NameRepository.swift
////  PetSupport
////
////  Created by Dayem Saeed on 5/20/21.
////
//
//import Foundation
//import FirebaseFirestore
//import FirebaseFirestoreSwift
//import FirebaseAuth
//
//class NameRepository : ObservableObject {
//    
//    let db = Firestore.firestore()
//    
//    @Published var name = [Name]()
//    
//    func getName() {
//        db.collection("user").document(Auth.auth().currentUser!.uid)
//            .addSnapshotListener {
//                (querySnapshot, error) in
//                if let querySnapshot = querySnapshot {
//                    do {
//                        try self.name[0] = querySnapshot.data(as: Name.self)!
//                    }
//                    catch {
//                        print("Error: \(error.localizedDescription)")
//                    }
//                }
//            }
//    }
//}

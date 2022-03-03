//
//  NameRepository.swift
//  PetSupport
//
//  Created by Dayem Saeed on 5/20/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class NameRepository : ObservableObject {
    
    let db = Firestore.firestore()
    
    @Published var name = ""
    
    func getDocumentData(db: Firestore) {
        let docRef = db.collection("user").document(Auth.auth().currentUser!.uid)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.get("name") ?? "nil"
                print("Document data: \(dataDescription)")
                DispatchQueue.main.async {
                    self.name = dataDescription as! String
                }
            } else {
                print("Document does not exist")
            }
        }
    }
}

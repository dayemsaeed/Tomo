//
//  NameViewModel.swift
//  Tomo
//
//  Created by Dayem Saeed on 3/3/22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class NameViewModel : ObservableObject {
    var nameRepository = NameRepository()
    @Published var name = String()
    
    init() {
        nameRepository.getDocumentData(db: Firestore.firestore())
    }
}

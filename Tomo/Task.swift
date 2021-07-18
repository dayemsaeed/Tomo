//
//  Task.swift
//  PetSupport
//
//  Created by Dayem Saeed on 5/5/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Task : Codable, Identifiable {
    @DocumentID var id: String?
    var title : String
    var date : String
    var completed : Bool
    var completedIcon : String
}

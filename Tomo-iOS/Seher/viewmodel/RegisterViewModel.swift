//
//  RegisterViewModel.swift
//  PetSupport
//
//  Created by Dayem Saeed on 3/23/21.
//

import Foundation
import FirebaseAuth

class RegisterViewModel: ObservableObject {
    @Published var isRegistered = false
    @Published var text = ""

    func register(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            guard authResult != nil, error == nil else {
                self.text = error?.localizedDescription ?? "Unknown error"
                return
            }
            self.isRegistered = true
        }
    }
}


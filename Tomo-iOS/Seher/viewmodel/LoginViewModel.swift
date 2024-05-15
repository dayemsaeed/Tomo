//
//  LoginViewModel.swift
//  PetSupport
//
//  Created by Dayem Saeed on 3/23/21.
//

import Foundation
import FirebaseAuth

class LoginViewModel: ObservableObject {
    @Published var isLoggedIn = false
    @Published var text = ""

    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            guard authResult != nil, error == nil else {
                self.text = error?.localizedDescription ?? "Unknown error"
                return
            }
            self.isLoggedIn = true
        }
    }
}


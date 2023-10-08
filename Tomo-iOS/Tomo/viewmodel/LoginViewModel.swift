//
//  LoginViewModel.swift
//  PetSupport
//
//  Created by Dayem Saeed on 3/23/21.
//

import Foundation
import Firebase

class LoginViewModel: ObservableObject {
    
    @Published var isLoggedIn = false
    func login(email: String, password: String) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Logged In!")
                self.isLoggedIn = true
            }
        }
        
    }
    
}

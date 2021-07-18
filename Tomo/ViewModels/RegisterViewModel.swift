//
//  RegisterViewModel.swift
//  PetSupport
//
//  Created by Dayem Saeed on 3/23/21.
//

import Foundation
import Firebase
import SwiftUI

class RegisterViewModel: ObservableObject {
    
    @Published var isRegistered = false
    @Published var text = ""
    
    func register(email: String, password: String) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print(error.localizedDescription)
                self.text = error.localizedDescription
            } else {
                print("Registered!")
                self.isRegistered = true
                self.text = "Successfully registered!"
            }
        }
        
    }
    
}

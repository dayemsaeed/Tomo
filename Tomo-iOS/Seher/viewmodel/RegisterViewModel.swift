//
//  RegisterViewModel.swift
//  PetSupport
//
//  Created by Dayem Saeed on 3/23/21.
//

import Foundation
import Supabase

class RegisterViewModel: ObservableObject {
    @Published var isLoggedIn = false
    @Published var isRegistered = false
    @Published var text = ""
    
    private let supabaseClient: SupabaseClient

    init(supabaseClient: SupabaseClient) {
        self.supabaseClient = supabaseClient
    }

    func register(email: String, password: String) async throws -> User {
        do {
            let authResponse = try await supabaseClient.auth.signUp(
                email: email,
                password: password
            )
            
            DispatchQueue.main.async {
                self.isRegistered = true  // Show confirmation message
            }
            
            return authResponse.user
        } catch {
            print("Registration error: \(error)")
            throw error
        }
    }
}


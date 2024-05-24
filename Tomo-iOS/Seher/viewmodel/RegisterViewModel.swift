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
    @Published var text = ""
    
    private let supabaseClient: SupabaseClient

    init(supabaseClient: SupabaseClient) {
        self.supabaseClient = supabaseClient
    }

    func register(email: String, password: String) async throws -> User {
        do {
            let session = try await 
            supabaseClient.auth.signUp(email: email, password: password)
            DispatchQueue.main.async {
                self.isLoggedIn = true
            }
            return session.user
        } catch {
            print(error)
            throw error
        }
    }
}


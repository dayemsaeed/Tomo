//
//  LoginViewModel.swift
//  Seher
//
//  Created by Dayem Saeed on 3/23/21.
//

import Foundation
import Supabase

class LoginViewModel: ObservableObject {
    @Published var isLoggedIn = false
    @Published var text = ""
    
    private let supabaseClient: SupabaseClient

    init(supabaseClient: SupabaseClient) {
        self.supabaseClient = supabaseClient
        if let _ = supabaseClient.auth.currentSession {
            self.isLoggedIn = true
        }
    }

    func login(email: String, password: String) async throws -> User {
        do {
            let session = try await supabaseClient.auth.signIn(email: email, password: password)
            print("Logging in with email: \(email)")
            
            DispatchQueue.main.async {
                self.isLoggedIn = true
                print("isLoggedIn set to true")
            }
            
            if let currentSession = supabaseClient.auth.currentSession {
                print("Session established: \(currentSession.accessToken)")
            }
            
            return session.user
        } catch {
            print("Login error: \(error)")
            throw error
        }
    }
    
    func isUserLoggedIn() -> Session? {
        return supabaseClient.auth.currentSession
    }

    func logout() async throws {
        try await supabaseClient.auth.signOut()
        DispatchQueue.main.async {
            self.isLoggedIn = false
        }
    }

    func signOut() async throws {
        do {
            try await supabaseClient.auth.signOut()
            DispatchQueue.main.async {
                self.isLoggedIn = false
            }
        } catch {
            print("Error signing out: \(error)")
            throw error
        }
    }
}


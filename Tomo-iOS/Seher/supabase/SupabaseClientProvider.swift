//
//  SupabaseClientProvider.swift
//  Seher
//
//  Created by Dayem Saeed on 5/22/24.
//

import Supabase
import Foundation

class SupabaseClientProvider {
    static func makeSupabaseClient() -> SupabaseClient {
        // Hardcode the URL since it's not sensitive
        let supabaseUrlString = "https://xzcmehrmmnstqrovwabx.supabase.co"
        
        guard let supabaseKey = Bundle.main.infoDictionary?["SUPABASE_KEY"] as? String,
              let supabaseUrl = URL(string: supabaseUrlString) else {
            fatalError("App configuration error: Missing Supabase key")
        }

        return SupabaseClient(
            supabaseURL: supabaseUrl,
            supabaseKey: supabaseKey
        )
    }
}

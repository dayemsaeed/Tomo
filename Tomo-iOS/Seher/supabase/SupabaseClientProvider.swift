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
        // Fetch the Supabase Key from the environment or fallback to the config file
        let supabaseKey: String
        
        if let environmentKey = ProcessInfo.processInfo.environment["SUPABASE_KEY"] {
            supabaseKey = environmentKey // Use environment variable (e.g., in Xcode Cloud)
        } else if let configKey = Bundle.main.infoDictionary?["SUPABASE_KEY"] as? String {
            supabaseKey = configKey // Use local Info.plist or xcconfig file for development
        } else {
            fatalError("Supabase key not found in environment or Info.plist")
        }

        // Define the Supabase URL (hardcoded or fetched similarly if needed)
        let supabaseUrlString = "https://xzcmehrmmnstqrovwabx.supabase.co"
        guard let supabaseUrl = URL(string: supabaseUrlString) else {
            fatalError("Invalid Supabase URL")
        }

        return SupabaseClient(
            supabaseURL: supabaseUrl,
            supabaseKey: supabaseKey
        )
    }
}

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
        guard let infoDictionary = Bundle.main.infoDictionary else {
            fatalError("Missing Info.plist")
        }
        guard let supabaseKey = infoDictionary["SUPABASE_KEY"] as? String else {
            fatalError("SUPABASE_KEY not found in Info.plist")
        }
        let supabaseUrlString = "https://xzcmehrmmnstqrovwabx.supabase.co"
        guard let supabaseUrl = URL(string: supabaseUrlString) else {
            fatalError("Invalid supabase url")
        }
        
        return SupabaseClient(
            supabaseURL: supabaseUrl,
            supabaseKey: supabaseKey
        )
    }
}

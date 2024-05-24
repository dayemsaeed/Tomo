//
//  ChatMessage.swift
//  Tomo
//
//  Created by Dayem Saeed on 4/1/23.
//

import SwiftUI

struct ChatMessage: Identifiable, Hashable {
    let id = UUID()
    let text: String
    let isSender: Bool
}

//
//  BreathingExercise.swift
//  Seher
//
//  Created by Dayem Saeed on 12/2/24.
//

import Foundation
import SwiftUI

struct BreathingExercise: Identifiable {
    let id: String
    let title: String
    let description: String
    let inhaleSeconds: Int
    let holdSeconds: Int
    let exhaleSeconds: Int
    let cycles: Int
    let color: Color
    
    init(
        id: String = UUID().uuidString,
        title: String,
        description: String,
        inhaleSeconds: Int,
        holdSeconds: Int = 0,
        exhaleSeconds: Int,
        cycles: Int = 3,
        color: Color = .blue
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.inhaleSeconds = inhaleSeconds
        self.holdSeconds = holdSeconds
        self.exhaleSeconds = exhaleSeconds
        self.cycles = cycles
        self.color = color
    }
}

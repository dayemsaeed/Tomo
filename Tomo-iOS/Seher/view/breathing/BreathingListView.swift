//
//  BreathingListView.swift
//  Seher
//
//  Created by Dayem Saeed on 12/2/24.
//

import Foundation
import SwiftUI

struct BreathingListView: View {
    let exercises: [BreathingExercise] = [
        BreathingExercise(
            title: "4-7-8 Breathing",
            description: "Inhale for 4, hold for 7, exhale for 8. Promotes relaxation and helps with sleep.",
            inhaleSeconds: 4,
            holdSeconds: 7,
            exhaleSeconds: 8,
            color: .blue
        ),
        BreathingExercise(
            title: "Box Breathing",
            description: "Equal duration for inhale, hold, exhale. Helps regain calm and control of thoughts when under stress.",
            inhaleSeconds: 4,
            holdSeconds: 4,
            exhaleSeconds: 4,
            color: .green
        ),
        BreathingExercise(
            title: "Measured Breathing",
            description: "Inhale for 4, hold for 1, exhale for 7. Reduces stress and anxiety, promotes relaxation.",
            inhaleSeconds: 4,
            holdSeconds: 1,
            exhaleSeconds: 7,
            color: .purple
        ),
        BreathingExercise(
            title: "Triangle Breathing",
            description: "Inhale for 4, hold for 4, exhale for 4. Alleviates anxiety and stress.",
            inhaleSeconds: 4,
            holdSeconds: 4,
            exhaleSeconds: 4,
            color: .cyan
        ),
        // Add more exercises as needed
    ]
    
    var body: some View {
        NavigationView {
            List(exercises) { exercise in
                NavigationLink(destination: BreathingExerciseView(exercise: exercise)) {
                    BreathingExerciseRow(exercise: exercise)
                }
            }
            .navigationTitle("Breathing Exercises")
        }
    }
}

struct BreathingExerciseRow: View {
    let exercise: BreathingExercise
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(exercise.title)
                .font(.headline)
            Text(exercise.description)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
    }
}

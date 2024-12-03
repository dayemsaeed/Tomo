//
//  BreathingExerciseView.swift
//  Seher
//
//  Created by Dayem Saeed on 12/2/24.
//

import Foundation
import SwiftUI

struct BreathingExerciseView: View {
    let exercise: BreathingExercise
    @State private var isBreathing = false
    @State private var currentPhase = BreathingPhase.inhale
    @State private var currentCycle = 1
    @State private var scale: CGFloat = 1.0
    @State private var timer: Timer?
    @State private var showCompletion = false
    
    enum BreathingPhase {
        case inhale, hold, exhale
        
        var instruction: String {
            switch self {
            case .inhale: return "Breathe In"
            case .hold: return "Hold"
            case .exhale: return "Breathe Out"
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 60) {
            Text("Cycle \(currentCycle) of \(exercise.cycles)")
                .font(.title2)
                .foregroundColor(.gray)
            
            ZStack {
                Circle()
                    .fill(exercise.color.opacity(0.3))
                    .frame(width: 260, height: 260)
                    .scaleEffect(scale)
                    .animation(.easeInOut(duration: Double(currentPhaseDuration())), value: scale)
                
                Text(currentPhase.instruction)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(exercise.color)
            }
            .frame(height: 300)
            
            Button(action: {
                isBreathing ? stopBreathing() : startBreathing()
            }) {
                Text(isBreathing ? "Stop" : "Start")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: 120, height: 50)
                    .background(exercise.color)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
            }
        }
        .padding()
        .onDisappear {
            stopBreathing()
        }
        .overlay {
            if showCompletion {
                CompletionView(exercise: exercise, isPresented: $showCompletion)
                    .transition(.opacity)
            }
        }
    }
    
    private func startBreathing() {
        HapticManager.shared.impact(style: .medium)
        HapticManager.shared.playSound(named: "start")
        isBreathing = true
        currentPhase = .inhale
        currentCycle = 1
        scale = 1.0
        startTimer()
    }
    
    private func stopBreathing() {
        isBreathing = false
        timer?.invalidate()
        timer = nil
        scale = 1.0
    }
    
    private func startTimer() {
        timer?.invalidate()
        
        // Set initial scale based on phase
        switch currentPhase {
        case .inhale:
            scale = 1.0
        case .hold:
            // Start a single timer for hold duration
            timer = Timer.scheduledTimer(withTimeInterval: Double(exercise.holdSeconds), repeats: false) { _ in
                moveToNextPhase()
            }
            return
        case .exhale:
            scale = 1.5
        }
        
        // For inhale and exhale phases
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if (currentPhase == .inhale && scale >= 1.5) || 
               (currentPhase == .exhale && scale <= 1.0) {
                moveToNextPhase()
            } else {
                adjustScale()
            }
        }
    }
    
    private func moveToNextPhase() {
        timer?.invalidate()
        
        switch currentPhase {
        case .inhale:
            if exercise.holdSeconds > 0 {
                HapticManager.shared.impact(style: .light)
                currentPhase = .hold
                startTimer()
            } else {
                currentPhase = .exhale
                startTimer()
            }
        case .hold:
            currentPhase = .exhale
            startTimer()
        case .exhale:
            if currentCycle < exercise.cycles {
                currentCycle += 1
                HapticManager.shared.impact(style: .medium)
                HapticManager.shared.playSound(named: "cycle")
                currentPhase = .inhale
                startTimer()
            } else {
                completeExercise()
            }
        }
    }
    
    private func adjustScale() {
        switch currentPhase {
        case .inhale:
            scale += 0.01
        case .hold:
            break
        case .exhale:
            scale -= 0.01
        }
    }
    
    private func currentPhaseDuration() -> Int {
        switch currentPhase {
        case .inhale: return exercise.inhaleSeconds
        case .hold: return exercise.holdSeconds
        case .exhale: return exercise.exhaleSeconds
        }
    }
    
    private func completeExercise() {
        stopBreathing()
        HapticManager.shared.notification(type: .success)
        HapticManager.shared.playSound(named: "complete")
        withAnimation {
            showCompletion = true
        }
    }
}

struct CompletionView: View {
    let exercise: BreathingExercise
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(exercise.color)
                
                Text("Great job!")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("You've completed the exercise")
                    .foregroundColor(.gray)
                
                Button("Done") {
                    withAnimation {
                        isPresented = false
                    }
                }
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(width: 120, height: 50)
                .background(exercise.color)
                .clipShape(RoundedRectangle(cornerRadius: 25))
            }
            .padding(40)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 10)
        }
    }
}

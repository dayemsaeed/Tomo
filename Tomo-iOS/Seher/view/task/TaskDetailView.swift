//
//  TaskDetailView.swift
//  Seher
//
//  Created by Dayem Saeed on 12/5/24.
//


import SwiftUI

struct TaskDetailView: View {
    let task: TaskItem
    
    var body: some View {
        VStack(spacing: 20) {
            Text(task.taskTitle)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.seherText)
                .padding(.top, 40)
            
            Text(format(date: task.creationDate))
                .font(.title2)
                .foregroundColor(.seherText.opacity(0.8))
            
            if !task.description.isEmpty {
                Text(task.description)
                    .font(.body)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(task.tintColor)
        .edgesIgnoringSafeArea(.all)
    }
    
    func format(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

//
//  NotificationManager.swift
//  Seher
//
//  Created by Dayem Saeed on 12/3/24.
//


import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    private let reminderOffset: TimeInterval = -15 * 60 // 15 minutes in seconds
    
    private init() {}
    
    func requestAuthorization() async throws -> Bool {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        return try await UNUserNotificationCenter.current().requestAuthorization(options: options)
    }
    
    func scheduleTaskReminder(for task: TaskItem) {
        // Calculate reminder time (15 minutes before task time)
        let reminderTime = task.creationDate.addingTimeInterval(reminderOffset)
        
        // Don't schedule if the reminder time has already passedA
        guard reminderTime > Date() else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Upcoming Task"
        content.body = "Your task '\(task.taskTitle)' is starting in 15 minutes"
        content.sound = .default
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: reminderTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: task.id,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
    
    func cancelReminder(for taskId: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [taskId])
    }
}
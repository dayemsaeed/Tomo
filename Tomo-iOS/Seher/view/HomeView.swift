//
//  HomeView.swift
//  Seher
//
//  Created by Dayem Saeed on 12/15/20.
//

import SwiftUI

/// `HomeView` serves as the main screen where users can navigate to the chat or task sections.
/// It also features an animated Lottie view to enhance user engagement.
struct HomeView: View {
    @State private var lottieAnimation: String = "catIdle"  // Tracks the Lottie animation to be displayed
    @EnvironmentObject private var nameViewModel: NameViewModel  // ViewModel for handling name logic
    @EnvironmentObject private var chatViewModel: ChatViewModel  // ViewModel for handling chat logic

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                // Displays a Lottie animation
                lottieAnimationView
                
                // Navigation buttons for Chat and Task views
                HStack {
                    NavigationLink("Chat") {
                        ChatView()  // Navigate to ChatView
                    }
                    .padding(30)
                    .buttonStyle(PrimaryButtonStyle())
                    
                    NavigationLink("Tasks") {
                        TaskView()  // Navigate to TaskView
                    }
                    .padding(30)
                    .buttonStyle(PrimaryButtonStyle())
                }
            }
        }
    }

    /// View displaying the Lottie animation based on `lottieAnimation`.
    var lottieAnimationView: some View {
        // Placeholder for actual Lottie animation (to be implemented)
        Text("Lottie Animation Placeholder")
            .font(.headline)
    }
}

#if DEBUG
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
#endif

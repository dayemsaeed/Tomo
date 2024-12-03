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
    @EnvironmentObject private var loginViewModel: LoginViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Split background
                VStack(spacing: 0) {
                    // Wall color (top portion)
                    Color.wallBlue
                        .frame(height: UIScreen.main.bounds.height * 0.35)
                    
                    // Floor color (bottom portion)
                    Color.floorGreen
                        .frame(maxHeight: .infinity)
                }
                .ignoresSafeArea()
                
                // Character animation
                riveAnimationView
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // Temporary Sign Out Button
                VStack {
                    Button(action: {
                        Task {
                            try? await loginViewModel.signOut()
                        }
                    }) {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.seherCircle)
                            .clipShape(Circle())
                    }
                    .padding()
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .safeAreaInset(edge: .bottom) {
                // Navigation buttons
                HStack(spacing: 20) {
                    NavigationLink("Chat") {
                        ChatView()
                    }
                    .buttonStyle(PrimaryButtonStyle())

                    NavigationLink("Tasks") {
                        TaskView()
                    }
                    .buttonStyle(PrimaryButtonStyle())

                    NavigationLink("Breathe") {
                        BreathingListView()
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
                .padding(.vertical, 10)
            }
        }
    }

    /// View displaying the Lottie animation based on `lottieAnimation`.
    var riveAnimationView: some View {
        // Placeholder for actual Lottie animation (to be implemented)
        RiveCatView()
    }
}

#if DEBUG
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
#endif

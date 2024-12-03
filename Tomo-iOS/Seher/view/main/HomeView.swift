struct HomeView: View {
    var body: some View {
        ZStack {
            // Background
            Color("BackgroundGreen")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Status Bar Background
                Color("NavigationGreen")
                    .frame(height: 0)
                    .ignoresSafeArea()
                
                // Cat animation in a larger space
                RiveCatView()
                    .frame(maxHeight: .infinity)
                
                // Bottom Navigation Area
                VStack(spacing: 0) {
                    // Subtle divider
                    Rectangle()
                        .fill(Color.white.opacity(0.1))
                        .frame(height: 1)
                    
                    // Navigation Buttons
                    HStack(spacing: 25) {  // Increased spacing
                        ForEach(["Chat", "Tasks", "Breathe"], id: \.self) { tab in
                            Button(action: {}) {
                                Text(tab)
                                    .font(.system(size: 18, weight: .semibold))  // Bolder text
                                    .foregroundColor(.white)
                                    .frame(width: 105, height: 48)  // Slightly larger
                                    .background(
                                        Capsule()
                                            .fill(Color("NavigationGreen"))
                                            .shadow(color: .black.opacity(0.15), radius: 8, y: 4)
                                    )
                            }
                        }
                    }
                    .padding(.vertical, 20)  // More vertical padding
                    .padding(.horizontal)
                    .background(
                        Color("NavigationGreen")
                            .opacity(0.1)
                            .ignoresSafeArea()
                    )
                }
            }
        }
    }
} 
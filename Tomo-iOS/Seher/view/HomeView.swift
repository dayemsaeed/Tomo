//
//  HomeView.swift
//  Seher
//
//  Created by Dayem Saeed on 12/15/20.
//

import SwiftUI

struct HomeView: View {
    @State private var lottieAnimation: String = "catIdle"
    @EnvironmentObject private var nameViewModel: NameViewModel
    @EnvironmentObject private var chatViewModel: ChatViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                // Lottie Animation View
                lottieAnimationView
                HStack {
                    NavigationLink("Chat") {
                        ChatView()
                    }
                    .padding(30)
                    .buttonStyle(PrimaryButtonStyle())
                    
                    NavigationLink("Tasks") {
                        TaskView()
                    }
                    .padding(30)
                    .buttonStyle(PrimaryButtonStyle())
                }
                
            }
            .padding(.horizontal, 30)
        }
    }
    
    private var lottieAnimationView: some View {
        LottieView(
            lottieFile: lottieAnimation,
            onAnimationComplete: {
                if (lottieAnimation != "catIdle" || lottieAnimation != "catSleeping") {
                    lottieAnimation = "catIdle"
                }
            }
        )
        .scaledToFit()
        .onTapGesture {
            lottieAnimation = "catHeadshake"
        }
        .gesture(
            DragGesture(minimumDistance: 30, coordinateSpace: .local)
                .onChanged({ value in
                    lottieAnimation = "catHeart"
                })
        )
    }
}

#if DEBUG
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
#endif

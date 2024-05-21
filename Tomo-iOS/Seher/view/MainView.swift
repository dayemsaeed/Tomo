//
//  ContentView.swift
//  PetSupport
//
//  Created by Dayem Saeed on 12/15/20.
//

import SwiftUI

struct MainView: View {
    @State private var lottieAnimation: String = "catIdle"
    @EnvironmentObject private var nameViewModel: NameViewModel
    @EnvironmentObject private var chatViewModel: ChatViewModel
    
    var body: some View {
        VStack {
            Spacer()
            
            // Lottie Animation View
            lottieAnimationView
            
            // Chat View
            ChatView()
                .environmentObject(chatViewModel)
            
            Spacer()
                .frame(height: 50)
        }
        .padding(.horizontal, 30)
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
        .frame(width: 200, height: 200)
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
        MainView()
    }
}
#endif

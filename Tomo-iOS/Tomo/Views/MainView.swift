//
//  ContentView.swift
//  PetSupport
//
//  Created by Dayem Saeed on 12/15/20.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import AVFoundation
import SpriteKit

struct MainView: View {
    
    @State private var radius = 300
    @Binding var view: String
    @ObservedObject private var nameViewModel = NameViewModel()
    let db = Firestore.firestore()
    let firebaseAuth = Auth.auth()
    @Binding var name: String
    @Binding var speechText: String
    let synthesizer = AVSpeechSynthesizer()
    let text = "Welcome! Time to get started on those tasks!"
    
    init(view: Binding<String>, name: Binding<String>, speechText: Binding<String>) { UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
        UITableView.appearance().isScrollEnabled = true
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(identifier: AVSpeechSynthesisVoiceIdentifierAlex)
        self._name = name;
        self._speechText = speechText;
        self._view = view
    }
    
    var body: some View {
        VStack {
            Spacer()
            LottieView(lottieFile: "sloth").frame(width: 200, height: 200)
            ChatView()
            Spacer()
                .frame(height: 50)
        }
        .padding(.horizontal, 30)
//        .background(bubble, alignment: .topLeading)
//        .background(bubble.rotationEffect(Angle(degrees: 180)), alignment: .bottomTrailing)
        
    }

//    @State private var startAnimation: Bool = false

//    var bubble: some View {
//
//        ZStack {
//
//            Circle()
//                .fill(Color(UIColor.systemTeal).opacity(0.4))
//                .frame(width: 300, height: 300, alignment: .center)
//                .offset(x: startAnimation ? -110 : -100, y: startAnimation ? -180 : -150)
//
//
//            Circle()
//                .fill(Color(UIColor.systemTeal).opacity(0.4))
//                .frame(width: 300, height: 300, alignment: .center)
//                .offset(x: startAnimation ? -180 : -150, y: startAnimation ? -90 : -100)
//
//        }
//        .onAppear() { startAnimation = true }
//        .animation(Animation.easeInOut(duration: 3.0).repeatForever(autoreverses: true))
//
//    }
}

#if DEBUG
struct MainView_Previews : PreviewProvider {
    static var previews: some View {
        MainView(view: .constant("Hi"), name: .constant("Hi"), speechText: .constant("Hi"))
    }
}
#endif

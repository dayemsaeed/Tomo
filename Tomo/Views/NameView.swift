//
//  NameView.swift
//  PetSupport
//
//  Created by Dayem Saeed on 3/25/21.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import AVFoundation
import SpriteKit

struct NameView: View {
    @Binding var name: String
    @State private var isEditing = false
    @Binding var view: String
    
    let db = Firestore.firestore()
    let synthesizer = AVSpeechSynthesizer()

    private var canContinue : Bool {
        return !name.isEmpty
    }
    
    var scene: SKScene {
        let scene = Tomodachi(size: CGSize(width: 300, height: 300));
        scene.scaleMode = .fill
        return scene;
    }

    var body: some View {
        return VStack(spacing: 8, content: {
            Spacer()
            SpriteView(scene: scene, options: [.allowsTransparency])
                .frame(height: 220)
                .padding(0)

            Group {
                HStack {
                    Text("HELLO! I'M PAIMON!")
                        .font(Font.custom("Permanent Marker", size: 32))
                }
                HStack {
                    Text("YOUR VIRTUAL SUPPORT ANIMAL!")
                        .font(Font.custom("Permanent Marker", size: 30))
                }
            }

            Group {
                HStack {
                    Text("WHAT'S YOUR NAME?")
                        .font(Font.custom("Permanent Marker", size: 30))
                }
                TextField("Name", text: $name) {
                    isEditing in self.isEditing = isEditing
                }
                .autocapitalization(.words)
                .disableAutocorrection(true)
                .padding(.top, 20)
                .padding(.horizontal)

                Divider()
                    .foregroundColor(.black)
            }
            Spacer()
            Button(action: {
                db.collection("user").document(Auth.auth().currentUser!.uid).setData([
                    "name": name
                ]) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                    }
                }
                let seconds = 3.0
                DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                    // Put your code which should be executed with a delay here
                    let utterance = AVSpeechUtterance(string: "Hi, \(name)! Welcome!")
                    utterance.voice = AVSpeechSynthesisVoice(identifier: AVSpeechSynthesisVoiceIdentifierAlex)
                    synthesizer.speak(utterance)
                    view = "Main"
                }
            }, label: {
                Text("NEXT")
            })
                .foregroundColor(.white)
                .font(Font.custom("Permanent Marker", size: 18.0))
                .padding(.horizontal, 20)
                .padding()
                .background(Color.petSupportBlue)
                .cornerRadius(70.0)
                .disabled(!canContinue)
            Spacer()
        })
        .padding(.horizontal, 30)
        .background(bubble, alignment: .topLeading)
        .background(bubble.rotationEffect(Angle(degrees: 180)), alignment: .bottomTrailing)
        .ignoresSafeArea()
    }


    @State private var startAnimation: Bool = false

    var bubble: some View {

        ZStack {

            Circle()
                .fill(Color(UIColor.systemTeal).opacity(0.4))
                .frame(width: 300, height: 300, alignment: .center)
                .offset(x: startAnimation ? -110 : -100, y: startAnimation ? -180 : -150)


            Circle()
                .fill(Color(UIColor.systemTeal).opacity(0.4))
                .frame(width: 300, height: 300, alignment: .center)
                .offset(x: startAnimation ? -180 : -150, y: startAnimation ? -90 : -100)

        }
        .onAppear() { startAnimation = true }
        .animation(Animation.easeInOut(duration: 3.0).repeatForever(autoreverses: true))

    }
}

struct NameView_Previews: PreviewProvider {
    static var previews: some View {
        NameView(name: .constant("Hi"), view: .constant("Hi"))
    }
}

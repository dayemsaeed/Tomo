//
//  RegisterView.swift
//  PetSupport
//
//  Created by Dayem Saeed on 3/23/21.
//

import SwiftUI
import AVFoundation

struct RegisterView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isEditing = false
    @State private var showPassword = false
    @State private var showConfirmPassword = false
    //@State private var text : String = ""
    @Binding var view : String
    @ObservedObject var userRegistered : RegisterViewModel
    
    let synthesizer = AVSpeechSynthesizer()
    
    private var canSignUp: Bool {
        return !email.isEmpty && !password.isEmpty && !confirmPassword.isEmpty
    }

    let registerView = RegisterViewModel()
    
    var body: some View {
        
        return VStack(content: {
            
            Spacer()
                .frame(height: 150)
            
            Text("TOMO").foregroundColor(Color.petSupportText)
                .font(Font.custom("Permanent Marker", size: 36))
                .padding()

            Group {
                
                HStack {
                    
                    Text("EMAIL")
                        .font(Font.custom("Permanent Marker", size: 18))
                        .padding(.top, 10)
                    
                    Spacer()
                    
                }
                
                TextField("Email", text: $email) {
                    isEditing in self.isEditing = isEditing
                }
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                .disableAutocorrection(true)
                .padding(.top, 20)
                
                Divider()
                    .foregroundColor(.black)
                
            }

            
            Group {
                
                HStack {
                    
                    Text("PASSWORD")
                        .font(Font.custom("Permanent Marker", size: 18))
                        .padding(.top, 10)
                    
                    Spacer()
                    
                }

                ZStack {
                    if showPassword {
                        TextField("Password", text: $password)
                    }
                    else {
                        SecureField("Password", text: $password)
                    }
                }
                .frame(height: 20)
                .autocapitalization(.none)
                .overlay(Image(systemName: showPassword ? "eye.slash" : "eye").onTapGesture { showPassword.toggle() }, alignment: .trailing)
                .disableAutocorrection(true)
                .padding(.top, 20)
                
                Divider()
                    .foregroundColor(.black)
                
            }
            
            Group {
                
                HStack {
                    
                    Text("CONFIRM PASSWORD")
                        .font(Font.custom("Permanent Marker", size: 18))
                        .padding(.top, 10)
                    
                    Spacer()
                    
                }

                ZStack {
                    if showConfirmPassword {
                        TextField("Password", text: $confirmPassword)
                    }
                    else {
                        SecureField("Password", text: $confirmPassword)
                    }
                }
                .frame(height: 20)
                .autocapitalization(.none)
                .overlay(Image(systemName: showConfirmPassword ? "eye.slash" : "eye").onTapGesture { showConfirmPassword.toggle() }, alignment: .trailing)
                .disableAutocorrection(true)
                .padding(.top, 20)
                
                Divider()
                    .foregroundColor(.black)
                
            }
            
            Spacer();
            
            Group {
                
                Button(action: {
                    registerView.register(email: email, password: password)
                    let seconds = 4.0
                    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                        // Put your code which should be executed with a delay here
                        let utterance = AVSpeechUtterance(string: "Successfully Registered!")
                        utterance.voice = AVSpeechSynthesisVoice(identifier: AVSpeechSynthesisVoiceIdentifierAlex)
                        synthesizer.speak(utterance)
                        view = "Name"
                    }
                }, label: {
                    Text("Register")
                })
                    .foregroundColor(.white)
                    .font(Font.custom("Permanent Marker", size: 18.0))
                    .padding(.horizontal, 20)
                    .padding()
                    .background(Color.petSupportBlue)
                    .cornerRadius(70.0)
                    .disabled(!canSignUp)
                
                Button(action: {
                    view = "Main"
                }, label: {
                    Text("LOGIN")
                })
                .padding()
                .font(Font.custom("Permanent Marker", size: 18.0))
                .foregroundColor(Color.petSupportText)
                .navigationBarTitle("")
                .navigationBarHidden(true)
            }
            
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

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(view: .constant("Main"), userRegistered: RegisterViewModel())
    }
}

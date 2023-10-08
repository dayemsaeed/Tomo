//
//  ContentView.swift
//  PetSupport
//
//  Created by Dayem Saeed on 5/5/21.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ContentView: View {
    @StateObject var userLoggedIn = LoginViewModel()
    @StateObject var userRegistered = RegisterViewModel()
    @State private var view = "Main"
    @State private var oldTitle = ""
    @State private var name = ""
    //@State private var speechText = "Hi! I'm so happy to see you!"
    
    var body: some View {
        if view == "Register" {
            RegisterView(view: $view, userRegistered: userRegistered)
        }
        else if Auth.auth().currentUser?.uid == nil {
            LoginView(userLoggedIn: userLoggedIn, view: $view)
        }
        else if view == "Name" {
            NameView(name: $name, view: $view)
        }
        else if view == "Tasks" {
            //TaskView(view: $view)
        }
        else {
            MainView(view: $view, name: $name)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//
//  NameView.swift
//  Seher
//
//  Created by Dayem Saeed on 5/24/24.
//

import SwiftUI
import FirebaseAuth
import Firebase

/// `NameView` allows users to enter their name and save it to Firebase.
/// It includes logic for verifying name input and navigating to the main screen once the name is saved.
struct NameView: View {
    @Binding var name: String  // Binding for the user's input name
    @Binding var view: String  // Tracks the current view for navigation purposes
    @State private var canContinue = false  // Determines if the "Next" button can be pressed
    @State private var isEditing = false  // Tracks if the user is actively editing the name field

    var body: some View {
        VStack {
            Spacer()
            
            // Greeting text and name input prompt
            Group {
                HStack {
                    Text("HELLO! I’M PAIMON!")
                        .font(.system(size: 32))
                }
                HStack {
                    Text("YOUR VIRTUAL SUPPORT ANIMAL!")
                        .font(.system(size: 30))
                }
            }
            
            Group {
                HStack {
                    Text("WHAT’S YOUR NAME?")
                        .font(.system(size: 30))
                }
                
                // TextField for entering the user's name
                TextField("Name", text: $name) { isEditing in
                    self.isEditing = isEditing
                }
                .autocapitalization(.words)
                .disableAutocorrection(true)
                .padding(.top, 20)
                .padding(.horizontal)

                Divider()
                    .foregroundColor(.black)
            }
            
            Spacer()

            // Button to save the name and navigate to the main view
            Button(action: saveName, label: {
                Text("NEXT")
                    .foregroundColor(.white)
                    .font(.system(size: 18))
                    .padding(.horizontal, 20)
                    .padding()
                    .background(Color.petSupportBlue)
                    .cornerRadius(70.0)
                    .disabled(!canContinue)
            })

            Spacer()
        }
        .padding(.horizontal, 30)
    }

    /// Saves the user's name to Firebase and navigates to the main view.
    private func saveName() {
        let db = Firestore.firestore()
        if let userId = Auth.auth().currentUser?.uid {
            db.collection("user").document(userId).setData(["name": name]) { error in
                if let error = error {
                    print("Error writing document: \(error)")
                } else {
                    print("Document successfully written!")
                    view = "Main"  // Navigate to the main screen
                }
            }
        }
    }
}

struct NameView_Previews: PreviewProvider {
    static var previews: some View {
        NameView(name: .constant("Hi"), view: .constant("Hi"))
    }
}

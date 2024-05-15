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

    private var canContinue : Bool {
        return !name.isEmpty
    }

    var body: some View {
        return VStack(spacing: 8, content: {
            Spacer()
            LottieView(lottieFile: "sloth").frame(width: 300, height: 300)

            Group {
                HStack {
                    Text("HELLO! I'M PAIMON!")
                        .font(.system(size: 32))
                }
                HStack {
                    Text("YOUR VIRTUAL SUPPORT ANIMAL!")
                        .font(.system(size: 30))
                }
            }

            Group {
                HStack {
                    Text("WHAT'S YOUR NAME?")
                        .font(.system(size: 30))
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
                view = "Main"
            }, label: {
                Text("NEXT")
            })
                .foregroundColor(.white)
                .font(.system(size: 18))
                .padding(.horizontal, 20)
                .padding()
                .background(Color.petSupportBlue)
                .cornerRadius(70.0)
                .disabled(!canContinue)
            Spacer()
        })
        .padding(.horizontal, 30)
    }
}

struct NameView_Previews: PreviewProvider {
    static var previews: some View {
        NameView(name: .constant("Hi"), view: .constant("Hi"))
    }
}

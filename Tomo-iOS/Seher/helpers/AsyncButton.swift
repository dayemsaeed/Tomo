//
//  AsyncButton.swift
//  Seher
//
//  Created by Dayem Saeed on 5/22/24.
//

import SwiftUI

struct AsyncButton<Label: View>: View {
    let action: () async -> Void
    let label: Label

    @State private var isRunning = false

    init(action: @escaping () async -> Void, @ViewBuilder label: () -> Label) {
        self.action = action
        self.label = label()
    }

    var body: some View {
        Button {
            isRunning = true
            Task {
                await action()
                isRunning = false
            }
        } label: {
            label
        }
        .disabled(isRunning)
    }
}

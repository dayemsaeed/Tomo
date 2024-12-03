//
//  TypingIndicator.swift
//  Tomo
//
//  Created by Dayem Saeed on 10/12/23.
//

import SwiftUI

/// The `TypingIndicator` view displays an animated indicator showing that the other user is typing.
struct TypingIndicator: View {
    @State private var opacity: Double = 0.3
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(Color(.systemGray3))
                    .frame(width: 8, height: 8)
                    .opacity(opacity)
                    .animation(
                        Animation
                            .easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(Double(index) * 0.2),
                        value: opacity
                    )
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color(.systemGray5))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .onAppear {
            opacity = 1
        }
    }
}

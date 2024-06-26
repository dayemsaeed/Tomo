//
//  TypingIndicator.swift
//  Tomo
//
//  Created by Dayem Saeed on 10/12/23.
//

import SwiftUI

struct TypingIndicator: View {
    var body: some View {
        HStack {
            ForEach(0..<3) { index in
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundColor(.gray)
                    .opacity(self.opacity(for: index))
                    .animation(Animation.easeInOut(duration: 0.6).repeatForever().delay(self.delay(for: index)))
            }
        }
    }
    
    private func opacity(for index: Int) -> Double {
        switch index {
        case 0: return 0.2
        case 1: return 0.4
        default: return 1.0
        }
    }
    
    private func delay(for index: Int) -> Double {
        return Double(index) * 0.2
    }
}

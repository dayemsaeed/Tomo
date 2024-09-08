//
//  ChatBubble.swift
//  Tomo
//
//  Created by Dayem Saeed on 4/1/23.
//

import SwiftUI

/// The `ChatBubble` shape is used to create a message bubble with rounded corners.
/// The shape adjusts based on whether the message is sent by the user (sender) or received.
struct ChatBubble: Shape {
    var isSender: Bool
    
    /// Creates the path for the bubble shape.
    /// - Parameter rect: The bounding rectangle in which to draw the shape.
    /// - Returns: A path representing the chat bubble.
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: [.topLeft, .topRight, isSender ? .bottomLeft : .bottomRight],
                                cornerRadii: CGSize(width: 16, height: 16))
        return Path(path.cgPath)
    }
}

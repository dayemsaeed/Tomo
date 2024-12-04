//
//  OffsetKey.swift
//  Seher
//
//  Created by Dayem Saeed on 5/23/24.
//

import SwiftUI

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

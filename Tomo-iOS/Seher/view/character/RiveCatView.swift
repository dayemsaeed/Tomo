//
//  RiveCatView.swift
//  Seher
//
//  Created by Dayem Saeed on 9/25/24.
//

import SwiftUI
import RiveRuntime

struct RiveCatView: View {
    var body: some View {
        RiveViewModel(fileName: "cat", fit: .fitHeight).view()
    }
}

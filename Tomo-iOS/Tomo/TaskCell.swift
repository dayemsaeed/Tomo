//
//  TaskCell.swift
//  Tomo
//
//  Created by Dayem Saeed on 10/9/23.
//

import Foundation
import SwiftUI

struct TaskCell : View {
     @ObservedObject var taskViewModel : TaskCellViewModel

     var body: some View {
         HStack {
             Image(systemName: taskViewModel.task.completed ? "checkmark.circle.fill" : "circle")
                 .resizable()
                 .frame(width: 20, height: 20)
             Text(taskViewModel.task.title).font(Font.custom("Permanent Marker", size: 18))
         }
     }
 }

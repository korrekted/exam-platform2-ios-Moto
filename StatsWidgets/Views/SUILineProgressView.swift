//
//  SUILineProgressView.swift
//  CDL
//
//  Created by Andrey Chernyshev on 01.07.2021.
//

import SwiftUI

struct LineProgressView: View {
    var progress: CGFloat
    
    @Environment(\.colorScheme) var colorScheme
    
    var progressColor: Color {
        colorScheme == .dark
            ? Color(red: 245 / 255, green: 245 / 255, blue: 245 / 255)
            : Color(red: 31 / 255, green: 31 / 255, blue: 31 / 255)
    }
    
    var trackColor: Color {
        colorScheme == .dark
            ? Color(red: 68 / 255, green: 68 / 255, blue: 68 / 255)
            : Color(red: 237 / 255, green: 237 / 255, blue: 237 / 255)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(trackColor)
                    .cornerRadius(geometry.size.height / 2)
                
                Rectangle()
                    .frame(width: min(CGFloat(progress) * geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(progressColor)
                    .cornerRadius(geometry.size.height / 2)
            }
        }
    }
}

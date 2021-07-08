//
//  VerticalRateView.swift
//  CDL
//
//  Created by Andrey Chernyshev on 01.07.2021.
//

import SwiftUI

struct VerticalRateView: View {
    var progress: CGFloat
    var title: String
    var color: Color
    var alignment: HorizontalAlignment = .center
    
    @Environment(\.colorScheme) var colorScheme
    
    var textColor: Color {
        colorScheme == .dark
            ? Color.white
            : Color(red: 31 / 255, green: 31 / 255, blue: 31 / 255)
    }
    
    var body: some View {
        VStack(alignment: alignment) {
            Text(title)
                .font(.system(size: 12.scale))
                .fontWeight(.regular)
                .foregroundColor(textColor)
            Text(String(format: "%.0f%%", min(self.progress, 1.0) * 100.0))
                .font(.system(size: 32.scale))
                .fontWeight(.bold)
                .foregroundColor(color)
            Spacer(minLength: 10.scale)
            SUICircleView(progress: progress, color: color)
                .frame(width: 61.scale, height: 61.scale, alignment: .leading)
                
        }
    }
}

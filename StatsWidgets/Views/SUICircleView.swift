//
//  SUICircleView.swift
//  CDL
//
//  Created by Andrey Chernyshev on 01.07.2021.
//

import SwiftUI

struct SUICircleView: View {
    var progress: CGFloat
    var color: Color
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(color, lineWidth: 9.scale)
                .opacity(0.4)
            
            Circle()
                .trim(from: 0, to: min(self.progress, 1.0))
                .stroke(color, style: StrokeStyle(lineWidth: 9.scale, lineCap: .round))
                .rotationEffect(Angle(degrees: 270))
        }
    }
}

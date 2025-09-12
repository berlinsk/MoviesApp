//
//  DotsLoader.swift
//  MoviesApp
//
//  Created by Берлинский Ярослав Владленович on 12.09.2025.
//

import SwiftUI

struct DotsLoader: View {
    @State private var scale: [CGFloat] = Array(repeating: 0.5, count: 8)

    let dotCount = 8
    let radius: CGFloat = 20
    let dotSize: CGFloat = 10

    var body: some View {
        ZStack {
            ForEach(0..<dotCount, id: \.self) { i in
                Circle()
                    .frame(width: dotSize, height: dotSize)
                    .scaleEffect(scale[i])
                    .offset(x: 0, y: -radius)
                    .rotationEffect(.degrees(Double(i) / Double(dotCount) * 360))
                    .animation(
                        Animation
                            .easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(Double(i) * 0.1),
                        value: scale[i]
                    )
            }
        }
        .onAppear {
            for i in 0..<dotCount {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.1) {
                    withAnimation {
                        scale[i] = 1.0
                    }
                }
            }
        }
    }
}

//
//  BackgroundView.swift
//  SafeFun
//
//  Created by Lalo Cardenas on 19/10/25.
//

import SwiftUI

struct BackgroundView: View {
    @State private var t: CGFloat = 0 // parámetro animado [0,1]

    var body: some View {
        ZStack {
            // Capa base: degradado suave
            LinearGradient(
                colors: [
                    .wcBlue.opacity(0.6),
                    .wcPurple.opacity(0.6),
                    .wcCyan.opacity(0.6)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Capa mesh: varios RadialGradient superpuestos con blendMode
            ZStack {
                // Para cada mancha, interpolamos entre dos posiciones usando 't'
                RadialGradient(
                    colors: [.wcGold.opacity(0.55), .clear],
                    center: UnitPoint(
                        x: lerp(0.18, 0.28, t),
                        y: lerp(0.18, 0.26, t)
                    ),
                    startRadius: 10,
                    endRadius: 400
                )
                RadialGradient(
                    colors: [.wcGreen.opacity(0.5), .clear],
                    center: UnitPoint(
                        x: lerp(0.82, 0.88, t),
                        y: lerp(0.22, 0.30, t)
                    ),
                    startRadius: 10,
                    endRadius: 380
                )
                RadialGradient(
                    colors: [.wcRed.opacity(0.45), .clear],
                    center: UnitPoint(
                        x: lerp(0.22, 0.28, t),
                        y: lerp(0.78, 0.84, t)
                    ),
                    startRadius: 10,
                    endRadius: 420
                )
                RadialGradient(
                    colors: [.wcOrange.opacity(0.5), .clear],
                    center: UnitPoint(
                        x: lerp(0.88, 0.94, t),
                        y: lerp(0.82, 0.88, t)
                    ),
                    startRadius: 10,
                    endRadius: 380
                )
                RadialGradient(
                    colors: [.wcLightPurple.opacity(0.5), .clear],
                    center: UnitPoint(
                        x: lerp(0.52, 0.58, t),
                        y: lerp(0.52, 0.60, t)
                    ),
                    startRadius: 10,
                    endRadius: 360
                )
            }
            .blendMode(.plusLighter) // suma colores para un look “mesh”
            .blur(radius: 24)
            .ignoresSafeArea()
        }
        .onAppear {
            withAnimation(.linear(duration: 18).repeatForever(autoreverses: true)) {
                t = 1
            }
        }
    }

    // Interpolación lineal helper
    private func lerp(_ a: CGFloat, _ b: CGFloat, _ t: CGFloat) -> CGFloat {
        a + (b - a) * t
    }
}

#Preview {
    BackgroundView()
}

//
//  SplashView.swift
//  SineX-SwiftUI-iOS
//
//  Created by iOS Developer on 26/06/26.
//


import SwiftUI

struct SplashView: View {

    @Environment(AppRouter.self) private var router
    @State private var logoScale: CGFloat = 0.85
    @State private var logoOpacity: Double = 0

    var body: some View {
        ZStack {
            Color.backgroundPrimary
                .ignoresSafeArea()

            Color.purpleGlow
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Image(systemName: "paperplane.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 96, height: 96)
                    .foregroundStyle(Color.primaryGradient)
                    .scaleEffect(logoScale)
                    .opacity(logoOpacity)

                Text("Sonder")
                    .font(.largeTitle.bold())
                    .foregroundStyle(Color.textPrimary)
                    .opacity(logoOpacity)
            }
        }
        .onAppear(perform: animateAndRoute)
    }

    private func animateAndRoute() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
            logoScale = 1.0
            logoOpacity = 1.0
        }

        // Brief, deliberate pause so the brand mark is actually seen rather
        // than flashing past — not just an arbitrary delay.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
            routeToNextFlow()
        }
    }

    private func routeToNextFlow() {
        let hasSeenOnboarding = UserDefaults.standard.bool(forKey: "sonder_has_seen_onboarding")

        guard hasSeenOnboarding else {
            router.resetTo(.onboarding)
            return
        }

        if SessionService.shared.hasValidToken {
            router.resetTo(.home)
        } else {
            router.resetTo(.auth)
        }
    }
}
//
//#Preview {
//    SplashView()
//        .environment(AppRouter())
//}

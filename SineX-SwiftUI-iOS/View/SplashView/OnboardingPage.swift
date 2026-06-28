//
//  OnboardingPage.swift
//  SineX-SwiftUI-iOS
//
//  Created by iOS Developer on 26/06/26.
//


import SwiftUI

private struct OnboardingPage: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let subtitle: String
}

struct OnboardingView: View {

    @Environment(AppRouter.self) private var router
    @State private var currentPage = 0

    private let pages: [OnboardingPage] = [
        OnboardingPage(
            icon: "briefcase.fill",
            title: "Built for builders",
            subtitle: "Meet people who actually get your career — engineers, founders, and corporate professionals only."
        ),
        OnboardingPage(
            icon: "checkmark.seal.fill",
            title: "Every profile, reviewed",
            subtitle: "We verify identity and employment by hand, so who you meet is who they say they are."
        ),
        OnboardingPage(
            icon: "bubble.left.and.bubble.right.fill",
            title: "Conversations that matter",
            subtitle: "Skip the small talk. Match on skills, ambition, and what you're actually looking for."
        )
    ]

    var body: some View {
        ZStack {
            Color.backgroundPrimary
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Spacer(minLength: 24)

                TabView(selection: $currentPage) {
                    ForEach(Array(pages.enumerated()), id: \.element.id) { index, page in
                        pageView(page)
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                pageIndicator

                VStack(spacing: 16) {
                    AppGradientButton(
                        title: currentPage == pages.count - 1 ? "Get Started" : "Continue",
                        isLoading: false
                    ) {
                        advance()
                    }

                    if currentPage < pages.count - 1 {
                        Button("Skip") {
                            completeOnboarding()
                        }
                        .font(.callout.weight(.medium))
                        .foregroundStyle(Color.textSecondary)
                    } else {
                        Color.clear.frame(height: 20)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
        }
    }

    private func pageView(_ page: OnboardingPage) -> some View {
        VStack(spacing: 28) {
            Spacer()

            ZStack {
                Circle()
                    .fill(Color.surface)
                    .frame(width: 140, height: 140)

                Image(systemName: page.icon)
                    .font(.system(size: 52, weight: .medium))
                    .foregroundStyle(Color.primaryGradient)
            }

            VStack(spacing: 12) {
                Text(page.title)
                    .font(.title.bold())
                    .foregroundStyle(Color.textPrimary)
                    .multilineTextAlignment(.center)

                Text(page.subtitle)
                    .font(.body)
                    .foregroundStyle(Color.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }

            Spacer()
        }
    }

    private var pageIndicator: some View {
        HStack(spacing: 8) {
            ForEach(0..<pages.count, id: \.self) { index in
                Capsule()
                    .fill(index == currentPage ? Color.brandPrimary : Color.borderSubtle)
                    .frame(width: index == currentPage ? 24 : 8, height: 8)
                    .animation(.easeInOut(duration: 0.2), value: currentPage)
            }
        }
        .padding(.top, 8)
    }

    private func advance() {
        if currentPage < pages.count - 1 {
            withAnimation {
                currentPage += 1
            }
        } else {
            completeOnboarding()
        }
    }

    private func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "sonder_has_seen_onboarding")
        router.resetToAuth()
    }
}
//
//#Preview {
//    OnboardingView()
//        .environment(AppRouter())
//}

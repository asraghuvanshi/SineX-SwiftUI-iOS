//
//  ForgotPasswordView.swift
//  SineX-SwiftUI-iOS
//
//  Created by iOS Developer on 26/06/26.
//

import SwiftUI

struct ForgotPasswordView: View {

    @Environment(AppRouter.self) private var router
    @State private var email = ""
    @FocusState private var isFocused: Bool

    var body: some View {
        ZStack {
            Color.backgroundPrimary
                .ignoresSafeArea()

            Color.purpleGlow
                .ignoresSafeArea()
                .frame(height: 400)
                .frame(maxHeight: .infinity, alignment: .top)

            ScrollView {
                VStack(spacing: 24) {
                    Spacer(minLength: 60)

                    Image(systemName: "lock.rotation")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 70)
                        .foregroundStyle(Color.primaryGradient)

                    VStack(spacing: 8) {
                        Text("Reset Password")
                            .font(.title.bold())
                            .foregroundStyle(Color.textPrimary)

                        Text("Enter your email and we'll send you a link to reset your password.")
                            .font(.body)
                            .foregroundStyle(Color.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }

                    GlassTextField(
                        icon: "envelope.fill",
                        placeholder: "Email",
                        text: $email,
                        isFocused: isFocused
                    )
                    .focused($isFocused)
                    .keyboardType(.emailAddress)
                    .padding(.horizontal, 24)

                    AppGradientButton(
                        title: "Send Reset Link",
                        isLoading: false
                    ) {
                        sendResetLink()
                    }
                    .padding(.horizontal, 24)

                    Spacer(minLength: 30)
                }
            }
        }
        .preferredColorScheme(.dark)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.backgroundPrimary, for: .navigationBar)
    }

    private func sendResetLink() {
        isFocused = false
        guard !email.isEmpty else { return }
        router.pop()
    }
}

//#Preview {
//    NavigationStack {
//        ForgotPasswordView()
//            .environment(AppRouter())
//    }
//}

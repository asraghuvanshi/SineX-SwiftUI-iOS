//
//  ResetPasswordSentView.swift
//  SineX-SwiftUI-iOS
//
//  Created by iOS Developer on 26/06/26.
//


import SwiftUI

struct ResetPasswordSentView: View {

    @Environment(AppRouter.self) private var router
    let email: String

    var body: some View {
        ZStack {
            Color.backgroundPrimary
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                Image(systemName: "paperplane.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundStyle(Color.primaryGradient)

                VStack(spacing: 8) {
                    Text("Check your inbox")
                        .font(.title.bold())
                        .foregroundStyle(Color.textPrimary)

                    Text("We sent a password reset link to \(email).")
                        .font(.body)
                        .foregroundStyle(Color.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }

                Button("Back to Sign In") {
                    // Pop the whole auth stack back to Login rather than
                    // just popping one screen, since the user is done with
                    // both ForgotPassword and this confirmation screen.
                    router.popToAuthRoot()
                }
                .font(.callout.bold())
                .foregroundStyle(Color.brandPrimary)
                .padding(.top, 8)

                Spacer()
            }
            .padding(.horizontal, 24)
        }
        .preferredColorScheme(.dark)
        .navigationBarBackButtonHidden(true)
    }
}

//#Preview {
//    NavigationStack {
//        ResetPasswordSentView(email: "you@example.com")
//            .environment(AppRouter())
//    }
//}

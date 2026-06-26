//
//  RootContainerView.swift
//  SineX-SwiftUI-iOS
//
//  Created by iOS Developer on 26/06/26.
//


import SwiftUI

struct RootContainerView: View {

    @Environment(AppRouter.self) private var router

    var body: some View {
        Group {
            switch router.rootFlow {
            case .splash:
                SplashView()

            case .onboarding:
                OnboardingView()

            case .auth:
                authStack

            case .home:
                homeStack
            }
        }
        .animation(.easeInOut(duration: 0.25), value: router.rootFlow)
    }

    @ViewBuilder
    private var authStack: some View {
        @Bindable var router = router
        NavigationStack(path: $router.authPath) {
            LoginView()
                .navigationDestination(for: AuthRoute.self) { route in
                    switch route {
                    case .login:
                        LoginView()
                    case .signup:
                        SignupView()
                    case .forgotPassword:
                        ForgotPasswordView()
                    case .resetPasswordSent(let email):
                        ResetPasswordSentView(email: email)
                    }
                }
        }
    }

    @ViewBuilder
    private var homeStack: some View {
        @Bindable var router = router
        NavigationStack(path: $router.homePath) {
            HomeView()
                .navigationDestination(for: HomeRoute.self) { route in
                    switch route {
                    case .profileDetail(let userID):
                        Text("Profile detail for \(userID)")
                    case .chatThread(let matchID):
                        Text("Chat thread for \(matchID)")
                    case .settings:
                        Text("Settings")
                    }
                }
        }
    }
}

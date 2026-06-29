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
        @Bindable var router = router

        NavigationStack(path: $router.path) {
            rootView
                .navigationDestination(for: AppRoute.self) { route in
                    destination(for: route)
                }
        }
        .animation(.easeInOut(duration: 0.3), value: router.rootFlow)
        .sheet(item: $router.presentedSheet) { route in
            switch route {
            case .termsAndPrivacy:
                Text("Privacy policy view")
//                TermsAndPrivacyView()
            }
        }
    }


    @ViewBuilder
    private var rootView: some View {
        switch router.rootFlow {
        case .splash:
            SplashView()

        case .auth:
            LoginView()
                .navigationBarBackButtonHidden(true)

        case .main:
            MainTabView()
                .navigationBarBackButtonHidden(true)
        }
    }

    @ViewBuilder
    private func destination(for route: AppRoute) -> some View {
        switch route {

            // MARK: Auth
        case .onboarding:
            OnboardingView()
                .navigationBarBackButtonHidden(true)

        case .login:
            LoginView()
                .navigationBarBackButtonHidden(true)

        case .signup:
            SignupView()
                .navigationBarBackButtonHidden(true)

        case .forgotPassword:
            ForgotPasswordView()
                .navigationBarBackButtonHidden(true)

            // MARK: Journey
        case .journeyProfession:
            JourneyProfessionView()
                .navigationBarBackButtonHidden(true)

        case .journeyEducation:
            JourneyEducationView()
                .navigationBarBackButtonHidden(true)

        case .journeyBioSkills:
            JourneyBioSkillsView()
                .navigationBarBackButtonHidden(true)

        case .journeyPhotoCapture:
            JourneyPhotoCaptureView()
                .navigationBarBackButtonHidden(true)

        case .journeyLivenessVerification:
            JourneyLivenessView()
                .navigationBarBackButtonHidden(true)

        case .journeyComplete:
            JourneyCompleteView()
                .navigationBarBackButtonHidden(true)
        case .profileDetails(let profileModel):
            UserProfileDetailView(profile: profileModel)
                .navigationBarBackButtonHidden(true)
        }
    }
}

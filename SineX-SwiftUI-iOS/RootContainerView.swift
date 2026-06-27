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

        Group {
            switch router.rootFlow {
            case .splash:
                SplashView()

            case .auth:
                NavigationStack(path: $router.path) {
                    LoginView()
                        .navigationDestination(for: AppRoute.self) { route in
                            destination(for: route)
                        }
                }

//            case .main:
//                NavigationStack(path: $router.path) {
//                    MainTabView()
//                        .navigationDestination(for: AppRoute.self) { route in
//                            destination(for: route)
//                        }
//                }
//            }
            case .main:
                EmptyView()
            }
//        .sheet(item: $router.presentedSheet) { route in
//            switch route {
//            case .termsAndPrivacy:
//                TermsAndPrivacyView()
//            }
        }
        .animation(.easeInOut(duration: 0.3), value: router.rootFlow)
    }

    @ViewBuilder
        private func destination(for route: AppRoute) -> some View {
            switch route {
                
                // MARK: Auth
            case .login:
                LoginView()
                    .navigationBarBackButtonHidden(true)
                
            case .signup:
                SignupView()
                    .navigationBarBackButtonHidden(true)
                
            case .forgotPassword:
                ForgotPasswordView()
                    .navigationBarBackButtonHidden(true)
                
             
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
            }
        }
//    }
}

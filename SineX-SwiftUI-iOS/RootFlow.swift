//
//  RootFlow.swift
//  SineX-SwiftUI-iOS
//
//  Created by iOS Developer on 26/06/26.
//


import Foundation
import Observation
import SwiftUI

// MARK: - Root Flow

enum RootFlow {
    case splash
    case auth
    case main
}

// MARK: - All App Routes

enum AppRoute: Hashable {
    // Auth
    case onboarding
    case login
    case signup
    case forgotPassword
//    case otpVerification(email: String)
//    case resetPassword

    // Onboarding Journey (post-signup)
    case journeyProfession
    case journeyEducation
    case journeyBioSkills
    case journeyPhotoCapture
    case journeyLivenessVerification
    case journeyComplete
}

// MARK: - Sheet Routes

enum SheetRoute: Identifiable {
    case termsAndPrivacy

    var id: String {
        switch self {
        case .termsAndPrivacy: return "termsAndPrivacy"
        }
    }
}


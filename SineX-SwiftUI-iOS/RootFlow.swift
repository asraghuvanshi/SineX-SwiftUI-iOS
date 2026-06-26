//
//  RootFlow.swift
//  SineX-SwiftUI-iOS
//
//  Created by iOS Developer on 26/06/26.
//


import Foundation

enum RootFlow: Equatable {
    case splash
    case onboarding
    case auth
    case home
}

enum AuthRoute: Hashable {
    case login
    case signup
    case forgotPassword
    case resetPasswordSent(email: String)
}

enum HomeRoute: Hashable {
    case profileDetail(userID: String)
    case chatThread(matchID: String)
    case settings
}

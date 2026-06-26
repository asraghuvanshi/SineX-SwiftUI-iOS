//
//  AppRouter.swift
//  SineX-SwiftUI-iOS
//
//  Created by iOS Developer on 26/06/26.
//


import SwiftUI
import Observation

@Observable
final class AppRouter {

    // MARK: - Root flow

    private(set) var rootFlow: RootFlow = .splash

    func resetTo(_ flow: RootFlow) {
        authPath = NavigationPath()
        homePath = NavigationPath()
        withAnimation(.easeInOut(duration: 0.25)) {
            rootFlow = flow
        }
    }

    // MARK: - Auth flow stack

    var authPath = NavigationPath()

    func pushAuth(_ route: AuthRoute) {
        authPath.append(route)
    }

    func popAuth() {
        guard !authPath.isEmpty else { return }
        authPath.removeLast()
    }

    func popToAuthRoot() {
        authPath.removeLast(authPath.count)
    }

    // MARK: - Home flow stack

    var homePath = NavigationPath()

    func pushHome(_ route: HomeRoute) {
        homePath.append(route)
    }

    func popHome() {
        guard !homePath.isEmpty else { return }
        homePath.removeLast()
    }

    func popToHomeRoot() {
        homePath.removeLast(homePath.count)
    }
}

//
//  AppRouter.swift
//  SineX-SwiftUI-iOS
//
//  Created by iOS Developer on 26/06/26.
//


import SwiftUI
import Observation


// MARK: - AppRouter

@Observable
final class AppRouter {

    // MARK: Root
    private(set) var rootFlow: RootFlow = .splash

    var path = NavigationPath()

    // MARK: Sheet / FullScreen
    var presentedSheet: SheetRoute?

    // MARK: Root transitions
    func resetToAuth() {
        path = NavigationPath()
        withAnimation(.easeInOut(duration: 0.3)) {
            rootFlow = .auth
        }
    }

    func resetToMain() {
        path = NavigationPath()
        withAnimation(.easeInOut(duration: 0.3)) {
            rootFlow = .main
        }
    }

    func resetToSplash() {
        path = NavigationPath()
        withAnimation(.easeInOut(duration: 0.3)) {
            rootFlow = .splash
        }
    }

    // MARK: Push / Pop
    func push(_ route: AppRoute) {
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path.removeLast(path.count)
    }

    // MARK: Sheet helpers
    func presentSheet(_ route: SheetRoute) {
        presentedSheet = route
    }

    func dismissSheet() {
        presentedSheet = nil
    }
}

//
//  HomeView.swift
//  SineX-SwiftUI-iOS
//
//  Created by iOS Developer on 26/06/26.
//

import SwiftUI

struct HomeView: View {

    @Environment(AppRouter.self) private var router

    var body: some View {
        ZStack {
            Color.backgroundPrimary
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("You're in.")
                    .font(.largeTitle.bold())
                    .foregroundStyle(Color.textPrimary)

                Button("View sample profile") {
                    router.pushHome(.profileDetail(userID: "demo-user-1"))
                }
                .foregroundStyle(Color.brandPrimary)

                Button("Log out") {
                    SessionService.shared.clear()
                    router.resetTo(.auth)
                }
                .foregroundStyle(Color.error)
                .padding(.top, 24)
            }
        }
        .preferredColorScheme(.dark)
    }
}

//#Preview {
//    HomeView()
//        .environment(AppRouter())
//}

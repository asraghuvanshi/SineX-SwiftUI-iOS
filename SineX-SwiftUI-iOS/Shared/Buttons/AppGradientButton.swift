//
//  SocialButton.swift
//  SineX-SwiftUI-iOS
//
//  Created by iOS Developer on 26/06/26.
//

import SwiftUI

struct SocialButton: View {

    let title: String
    let icon: String
    var action: () -> Void = {}

    var body: some View {

        Button(action: action) {

            HStack(spacing: 12) {
                Spacer()
                Image(systemName: icon)
                Text(title)
                    .fontWeight(.medium)
                Spacer()
            }
            .padding(.horizontal, 16)
            .frame(height: 56)
            .foregroundStyle(Color.textPrimary)
            .background(Color.surface)
            .clipShape(
                RoundedRectangle(cornerRadius: 16)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        Color.borderSubtle,
                        lineWidth: 1
                    )
            }
        }
    }
}


struct AppGradientButton: View {

    let title: String
    var isLoading: Bool

    var action: () -> Void

    var body: some View {

        Button {

            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()

            action()

        } label: {

            ZStack {

                if isLoading {
                    ProgressView()
                        .tint(Color.textPrimary)
                } else {
                    Text(title)
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .foregroundStyle(Color.textPrimary)
            .background(
                Color.primaryGradient
            )
            .clipShape(
                RoundedRectangle(cornerRadius: 16)
            )
            .shadow(
                color: Color.brandPrimary.opacity(0.3),
                radius: 12,
                y: 6
            )
        }
    }
}

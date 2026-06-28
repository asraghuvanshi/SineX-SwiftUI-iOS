//
//  ProfileView.swift
//  SineX-SwiftUI-iOS
//
//  Created by iOS Developer on 27/06/26.
//


import SwiftUI

struct ProfileView: View {

    @Environment(AppRouter.self) private var router

    @State private var verificationStatus: VerificationStatus = .pending
    @State private var showEditProfile = false

    var body: some View {
        ZStack {
            Color.backgroundPrimary.ignoresSafeArea()

            Color.purpleGlow
                .ignoresSafeArea()
                .frame(height: 320)
                .frame(maxHeight: .infinity, alignment: .top)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    header
                    profileCard
                    verificationBanner
                    statsRow
                    menuSection
                    Spacer(minLength: 100) // clears floating tab bar
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
            }
        }
        .sheet(isPresented: $showEditProfile) {
            EditProfileView()
        }
    }

    // MARK: Header

    private var header: some View {
        HStack {
            Text("Profile")
                .font(.title2.bold())
                .foregroundStyle(.white)
            Spacer()
            Button {
                // navigate to settings
            } label: {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 40, height: 40)
                    .background(.white.opacity(0.1), in: Circle())
            }
        }
    }

    // MARK: Profile Card

    private var profileCard: some View {
        VStack(spacing: 14) {
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(Color.surface)
                    .frame(width: 96, height: 96)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 40))
                            .foregroundStyle(.white.opacity(0.35))
                    )

                if verificationStatus == .verified {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 22))
                        .foregroundStyle(Color.brandPrimary)
                        .background(Color.backgroundPrimary, in: Circle())
                        .offset(x: 4, y: 4)
                }
            }

            VStack(spacing: 4) {
                Text("Alex Morgan")
                    .font(.title3.bold())
                    .foregroundStyle(.white)

                Text("Senior Software Engineer · Stripe")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.55))
            }

            Button {
                showEditProfile = true
            } label: {
                Text("Edit Profile")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(Color.white.opacity(0.1), in: Capsule())
                    .overlay(Capsule().strokeBorder(.white.opacity(0.15)))
            }
            .padding(.top, 4)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
    }

    // MARK: Verification Banner

    @ViewBuilder
    private var verificationBanner: some View {
        switch verificationStatus {
        case .pending:
            JourneyCard {
                HStack(spacing: 14) {
                    Image(systemName: "hourglass")
                        .font(.title3)
                        .foregroundStyle(.orange)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Verification pending")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.white)
                        Text("We'll notify you once your profile is approved.")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.55))
                    }

                    Spacer()
                }
            }

        case .rejected:
            JourneyCard {
                HStack(spacing: 14) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.title3)
                        .foregroundStyle(.red)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Verification failed")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.white)
                        Text("Tap to retake your liveness photo.")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.55))
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .foregroundStyle(.white.opacity(0.3))
                }
            }
            .onTapGesture {
                router.push(.journeyLivenessVerification)
            }

        case .verified:
            EmptyView()
        }
    }

    // MARK: Stats Row

    private var statsRow: some View {
        HStack(spacing: 12) {
            statItem(value: "128", label: "Profile views")
            statItem(value: "34", label: "Likes")
            statItem(value: "9", label: "Matches")
        }
    }

    private func statItem(value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title3.bold())
                .foregroundStyle(.white)
            Text(label)
                .font(.caption2)
                .foregroundStyle(.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(.white.opacity(0.08), lineWidth: 1)
        )
    }

    // MARK: Menu Section

    private var menuSection: some View {
        VStack(spacing: 0) {
            menuRow(icon: "person.text.rectangle", title: "Account details")
            divider
            menuRow(icon: "shield.fill", title: "Privacy & safety")
            divider
            menuRow(icon: "bell.fill", title: "Notifications")
            divider
            menuRow(icon: "questionmark.circle.fill", title: "Help & support")
            divider
            menuRow(icon: "rectangle.portrait.and.arrow.right", title: "Log out", tint: .red)
        }
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(.white.opacity(0.08), lineWidth: 1)
        )
    }

    private var divider: some View {
        Divider().overlay(Color.white.opacity(0.08)).padding(.leading, 56)
    }

    private func menuRow(icon: String, title: String, tint: Color = .white) -> some View {
        Button {
            if title == "Log out" {
                router.resetToAuth()
            }
        } label: {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(tint == .red ? .red : .white.opacity(0.7))
                    .frame(width: 22)

                Text(title)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(tint == .red ? .red : .white)

                Spacer()

                if tint != .red {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.3))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Verification Status

enum VerificationStatus {
    case pending, verified, rejected
}

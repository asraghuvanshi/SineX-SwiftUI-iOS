//
//  DiscoverProfile.swift
//  SineX-SwiftUI-iOS
//
//  Created by iOS Developer on 27/06/26.
//

import SwiftUI
import Combine

struct DiscoverProfile: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let age: Int
    let jobTitle: String
    let distanceKm: Int
    let photoSystemImage: String
    let isVerified: Bool
    let isOnline: Bool
}

struct DiscoverGridView: View {

    @State private var profiles: [DiscoverProfile] = DiscoverProfile.sampleData
    @State private var showFilters = false
    @Environment(AppRouter.self) private var router

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        ZStack {
            Color.backgroundPrimary.ignoresSafeArea()

            Color.purpleGlow
                .ignoresSafeArea()
                .frame(height: 240)
                .frame(maxHeight: .infinity, alignment: .top)

            VStack(spacing: 0) {
                header

                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(profiles) { profile in
                            DiscoverGridCard(profile: profile)
                                .onTapGesture {
                                    router.push(.profileDetails(profileModel: profile.toUserProfileDetail()))
                                }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 110)
                }
            }
        }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Discover")
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                Text("\(profiles.count) people near you")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.5))
            }

            Spacer()

            Button { showFilters = true } label: {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 40, height: 40)
                    .background(.white.opacity(0.1), in: Circle())
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
        .padding(.bottom, 8)
    }
}

// MARK: - Discover Grid Card

struct DiscoverGridCard: View {

    let profile: DiscoverProfile

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.surface)
                .aspectRatio(0.78, contentMode: .fill)
                .overlay {
                    Image(profile.photoSystemImage)
                        .resizable()
                        .scaledToFit()
                        .padding(1)
                }
                .clipShape(
                    RoundedRectangle(cornerRadius: 22, style: .circular)
                )

            LinearGradient(
                colors: [.clear, .black.opacity(0.8)],
                startPoint: .center,
                endPoint: .bottom
            )
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))

            // Online dot
            if profile.isOnline {
                Circle()
                    .fill(Color.green)
                    .frame(width: 10, height: 10)
                    .overlay(Circle().strokeBorder(.white.opacity(0.5), lineWidth: 1))
                    .padding(10)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            }

            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 4) {
                    Text("\(profile.name), \(profile.age)")
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.white)
                        .lineLimit(1)

                    if profile.isVerified {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.caption2)
                            .foregroundStyle(Color.brandPrimary)
                    }
                }

                Text(profile.jobTitle)
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.8))
                    .lineLimit(1)

                HStack(spacing: 3) {
                    Image(systemName: "location.fill")
                        .font(.system(size: 8))
                    Text("\(profile.distanceKm) km")
                        .font(.caption2)
                }
                .foregroundStyle(.white.opacity(0.6))
            }
            .padding(12)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .strokeBorder(.white.opacity(0.08), lineWidth: 1)
        )
        .contentShape(Rectangle())
    }
}

// MARK: - Sample Data

extension DiscoverProfile {
    static let sampleData: [DiscoverProfile] = [
        DiscoverProfile(name: "Maya", age: 28, jobTitle: "Product Designer", distanceKm: 3, photoSystemImage: "profile1", isVerified: true, isOnline: true),
        DiscoverProfile(name: "Arjun", age: 31, jobTitle: "Backend Engineer", distanceKm: 5, photoSystemImage: "profile2", isVerified: true, isOnline: false),
        DiscoverProfile(name: "Sara", age: 26, jobTitle: "Founder, Lumen Health", distanceKm: 8, photoSystemImage: "profile3", isVerified: false, isOnline: true),
        DiscoverProfile(name: "Dev", age: 29, jobTitle: "iOS Engineer", distanceKm: 2, photoSystemImage: "profile4", isVerified: true, isOnline: false),
        DiscoverProfile(name: "Priya", age: 27, jobTitle: "Data Scientist", distanceKm: 6, photoSystemImage: "profile5", isVerified: true, isOnline: true),
        DiscoverProfile(name: "Kabir", age: 30, jobTitle: "Investment Analyst", distanceKm: 4, photoSystemImage: "profile6", isVerified: false, isOnline: false),
    ]

    func toUserProfileDetail() -> UserProfileDetail {
        UserProfileDetail(
            name: name,
            age: age,
            jobTitle: jobTitle,
            company: "—",
            university: "—",
            bio: "",
            distanceKm: distanceKm,
            photoSystemImage: photoSystemImage,
            isVerified: isVerified,
            isOnline: isOnline,
            isPrivate: false,
            followersCount: 0,
            followingCount: 0,
            postsCount: 0,
            posts: [],
            isFollowedByMe: false,
            followsMe: false
        )
    }
}

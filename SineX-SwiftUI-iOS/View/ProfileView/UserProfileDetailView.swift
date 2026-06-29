//
//  UserPost.swift
//  SineX-SwiftUI-iOS
//
//  Created by iOS Developer on 30/06/26.
//

import SwiftUI

// MARK: - Models

struct UserPost: Identifiable, Hashable {
    let id = UUID()
    let imageSystemName: String
    let likeCount: Int
}
struct UserProfileDetail: Identifiable , Hashable{
    let id = UUID()
    let name: String
    let age: Int
    let jobTitle: String
    let company: String
    let university: String
    let bio: String
    let distanceKm: Int
    let photoSystemImage: String
    let isVerified: Bool
    let isOnline: Bool
    let isPrivate: Bool
    let followersCount: Int
    let followingCount: Int
    let postsCount: Int
    let posts: [UserPost]
    var isFollowedByMe: Bool
    var followsMe: Bool
}


enum ViewerAccessState {
    case fullAccess              // subscribed, and (profile public OR already following)
    case lockedBySubscription    // viewer hasn't paid
    case lockedByPrivacy         // profile is private and viewer doesn't follow
}

// MARK: - Main Screen

struct UserProfileDetailView: View {

    @Environment(\.dismiss) private var dismiss

    let profile: UserProfileDetail

    @State private var isCurrentUserSubscribed: Bool
    @State private var isFollowing: Bool
    @State private var followersCount: Int

    @State private var showFollowers = false
    @State private var showFollowing = false
    @State private var showPaywall = false
    @State private var selectedPost: UserPost?

    init(profile: UserProfileDetail, isCurrentUserSubscribed: Bool = true) {
        self.profile = profile
        _isCurrentUserSubscribed = State(initialValue: isCurrentUserSubscribed)
        _isFollowing = State(initialValue: profile.isFollowedByMe)
        _followersCount = State(initialValue: profile.followersCount)
    }

    private var accessState: ViewerAccessState {
        if !isCurrentUserSubscribed { return .lockedBySubscription }
        if profile.isPrivate && !isFollowing { return .lockedByPrivacy }
        return .fullAccess
    }

    var body: some View {
        ZStack {
            Color.backgroundPrimary.ignoresSafeArea()

            Color.purpleGlow
                .ignoresSafeArea()
                .frame(height: 260)
                .frame(maxHeight: .infinity, alignment: .top)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    headerCard
                    statsRow
                    actionButtons

                    if !profile.bio.isEmpty {
                        bioSection
                    }

                    detailsSection

                    postsSection
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 32)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button("Report", systemImage: "flag") {}
                    Button("Block", systemImage: "hand.raised", role: .destructive) {}
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundStyle(.white)
                }
            }
        }
        .sheet(isPresented: $showFollowers) {
            FollowListView(title: "Followers", users: UserProfileDetail.sampleFollowList)
        }
        .sheet(isPresented: $showFollowing) {
            FollowListView(title: "Following", users: UserProfileDetail.sampleFollowList)
        }
        .sheet(isPresented: $showPaywall) {
            PaywallSheetPlaceholder()
        }
        .preferredColorScheme(.dark)
    }

    // MARK: Header

    private var headerCard: some View {
        VStack(spacing: 12) {
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(Color.surface)
                    .frame(width: 92, height: 92)
                    .overlay(
                        Image(profile.photoSystemImage)
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                    )
                    .overlay(Circle().strokeBorder(.white.opacity(0.1), lineWidth: 1))

                if profile.isOnline {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 14, height: 14)
                        .overlay(Circle().strokeBorder(Color.backgroundPrimary, lineWidth: 2))
                }
            }

            HStack(spacing: 6) {
                Text("\(profile.name), \(profile.age)")
                    .font(.title3.bold())
                    .foregroundStyle(.white)

                if profile.isVerified {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.subheadline)
                        .foregroundStyle(Color.brandPrimary)
                }
            }

            Text(profile.jobTitle)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.6))

            HStack(spacing: 4) {
                Image(systemName: "location.fill")
                    .font(.caption2)
                Text("\(profile.distanceKm) km away")
                    .font(.caption)
            }
            .foregroundStyle(.white.opacity(0.45))
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 8)
    }

    // MARK: Stats (posts / followers / following)

    private var statsRow: some View {
        JourneyCard {
            HStack(spacing: 0) {
                statItem(value: "\(profile.postsCount)", label: "Posts") {}
                divider
                statItem(value: "\(followersCount)", label: "Followers") {
                    if accessState == .fullAccess {
                        showFollowers = true
                    } else {
                        showPaywall = accessState == .lockedBySubscription
                    }
                }
                divider
                statItem(value: "\(profile.followingCount)", label: "Following") {
                    if accessState == .fullAccess {
                        showFollowing = true
                    } else {
                        showPaywall = accessState == .lockedBySubscription
                    }
                }
            }
        }
    }

    private var divider: some View {
        Rectangle()
            .fill(.white.opacity(0.08))
            .frame(width: 1, height: 32)
    }

    private func statItem(value: String, label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 2) {
                Text(value)
                    .font(.headline.bold())
                    .foregroundStyle(.white)
                Text(label)
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.5))
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }

    // MARK: Action Buttons

    private var actionButtons: some View {
        HStack(spacing: 10) {
            Button {
                handleFollowTap()
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: isFollowing ? "checkmark" : "plus")
                        .font(.caption.weight(.bold))
                    Text(isFollowing ? "Following" : "Follow")
                        .font(.subheadline.weight(.semibold))
                }
                .foregroundStyle(isFollowing ? .white : .white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    isFollowing ? Color.white.opacity(0.1) : Color.brandPrimary,
                    in: RoundedRectangle(cornerRadius: 14)
                )
            }

            Button {
                if !isCurrentUserSubscribed { showPaywall = true }
            } label: {
                Image(systemName: "message.fill")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(width: 48, height: 48)
                    .background(Color.white.opacity(0.1), in: RoundedRectangle(cornerRadius: 14))
            }
        }
    }

    private func handleFollowTap() {
        guard isCurrentUserSubscribed else {
            showPaywall = true
            return
        }
        isFollowing.toggle()
        followersCount += isFollowing ? 1 : -1
    }

    // MARK: Bio

    private var bioSection: some View {
        JourneyCard {
            VStack(alignment: .leading, spacing: 6) {
                Text("About")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.5))
                    .textCase(.uppercase)
                    .tracking(0.8)

                Text(profile.bio)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.85))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    // MARK: Work / Education details

    private var detailsSection: some View {
        JourneyCard {
            VStack(alignment: .leading, spacing: 10) {
                detailRow(icon: "briefcase.fill", text: "\(profile.jobTitle) at \(profile.company)")
                detailRow(icon: "building.columns.fill", text: profile.university)
            }
        }
    }

    private func detailRow(icon: String, text: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundStyle(Color.brandPrimary)
                .frame(width: 20)
            Text(text)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.85))
        }
    }

    // MARK: Posts grid (Instagram-style)

    private var postsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Posts")
                    .font(.headline)
                    .foregroundStyle(.white)
                Spacer()
                if accessState != .fullAccess {
                    Image(systemName: "lock.fill")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.4))
                }
            }

            switch accessState {
            case .fullAccess:
                postsGrid(locked: false)

            case .lockedByPrivacy:
                lockedPostsState(
                    icon: "lock.fill",
                    title: "This Account is Private",
                    message: "Follow \(profile.name) to see their posts.",
                    actionTitle: isFollowing ? nil : "Follow",
                    action: handleFollowTap
                )

            case .lockedBySubscription:
                lockedPostsState(
                    icon: "crown.fill",
                    title: "Unlock Full Profiles",
                    message: "Subscribe to view posts, followers, and connect with \(profile.name).",
                    actionTitle: "Upgrade to Premium",
                    action: { showPaywall = true }
                )
            }
        }
    }

    private func postsGrid(locked: Bool) -> some View {
        let columns = [GridItem(.flexible(), spacing: 6), GridItem(.flexible(), spacing: 6), GridItem(.flexible(), spacing: 6)]
        return LazyVGrid(columns: columns, spacing: 6) {
            ForEach(profile.posts) { post in
                Button { selectedPost = post } label: {
                    ZStack(alignment: .bottomLeading) {
                        Rectangle()
                            .fill(Color.surface)
                            .aspectRatio(1, contentMode: .fill)
                            .overlay(
                                Image(post.imageSystemName)
                                    .resizable()
                                    .scaledToFill()
                            )
                            .clipped()

                        HStack(spacing: 3) {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 9))
                            Text("\(post.likeCount)")
                                .font(.system(size: 10, weight: .semibold))
                        }
                        .foregroundStyle(.white)
                        .padding(6)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func lockedPostsState(icon: String, title: String, message: String, actionTitle: String?, action: @escaping () -> Void) -> some View {
        VStack(spacing: 14) {
            // blurred placeholder grid behind the message for visual teasing
            ZStack {
                let columns = [GridItem(.flexible(), spacing: 6), GridItem(.flexible(), spacing: 6), GridItem(.flexible(), spacing: 6)]
                LazyVGrid(columns: columns, spacing: 6) {
                    ForEach(0..<6, id: \.self) { _ in
                        Rectangle()
                            .fill(Color.surface)
                            .aspectRatio(1, contentMode: .fill)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
                .blur(radius: 12)

                VStack(spacing: 10) {
                    Image(systemName: icon)
                        .font(.system(size: 26))
                        .foregroundStyle(Color.brandPrimary)

                    Text(title)
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.white)

                    Text(message)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.6))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)

                    if let actionTitle {
                        Button(actionTitle, action: action)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.black)
                            .padding(.horizontal, 18)
                            .padding(.vertical, 9)
                            .background(Color.brandPrimary, in: Capsule())
                            .padding(.top, 4)
                    }
                }
                .padding(20)
                .background(.black.opacity(0.55), in: RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 12)
            }
        }
    }
}

// MARK: - Follow List (Followers/Following)

struct FollowListUser: Identifiable {
    let id = UUID()
    let name: String
    let jobTitle: String
    let photoSystemImage: String
    var isFollowing: Bool
}

struct FollowListView: View {
    let title: String
    @State var users: [FollowListUser]
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundPrimary.ignoresSafeArea()
                List {
                    ForEach(users) { user in
                        HStack(spacing: 12) {
                            Circle()
                                .fill(Color.surface)
                                .frame(width: 44, height: 44)
                                .overlay(Image(user.photoSystemImage).resizable().scaledToFill().clipShape(Circle()))

                            VStack(alignment: .leading, spacing: 2) {
                                Text(user.name).font(.subheadline.weight(.semibold)).foregroundStyle(.white)
                                Text(user.jobTitle).font(.caption).foregroundStyle(.white.opacity(0.5))
                            }

                            Spacer()

                            Button(user.isFollowing ? "Following" : "Follow") {
                                if let idx = users.firstIndex(where: { $0.id == user.id }) {
                                    users[idx].isFollowing.toggle()
                                }
                            }
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(user.isFollowing ? .white.opacity(0.7) : .black)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(user.isFollowing ? Color.white.opacity(0.1) : Color.brandPrimary, in: Capsule())
                        }
                        .listRowBackground(Color.backgroundPrimary)
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundStyle(Color.brandPrimary)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}


struct PaywallSheetPlaceholder: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "crown.fill")
                .font(.system(size: 40))
                .foregroundStyle(Color.brandPrimary)
            Text("Upgrade to Premium")
                .font(.title3.bold())
                .foregroundStyle(.white)
            Text("Unlock profiles, posts, followers, and unlimited messaging.")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.6))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            Button("See Plans") { dismiss() }
                .font(.headline)
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.brandPrimary, in: RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 32)
                .padding(.top, 8)
        }
        .padding(.top, 40)
        .presentationDetents([.medium])
        .background(Color.backgroundPrimary.ignoresSafeArea())
        .preferredColorScheme(.dark)
    }
}

// MARK: - Sample Data

extension UserProfileDetail {
    static let sample = UserProfileDetail(
        name: "Maya",
        age: 28,
        jobTitle: "Product Designer",
        company: "Notion",
        university: "UC Berkeley",
        bio: "Building things that matter, one product at a time. Looking for someone equally obsessed with their craft.",
        distanceKm: 3,
        photoSystemImage: "profile1",
        isVerified: true,
        isOnline: true,
        isPrivate: true,
        followersCount: 482,
        followingCount: 213,
        postsCount: 18,
        posts: (0..<9).map { UserPost(imageSystemName: "post\($0 % 4)", likeCount: Int.random(in: 12...340)) },
        isFollowedByMe: false,
        followsMe: true
    )

    static let sampleFollowList: [FollowListUser] = [
        FollowListUser(name: "Arjun", jobTitle: "Backend Engineer", photoSystemImage: "profile2", isFollowing: true),
        FollowListUser(name: "Sara", jobTitle: "Founder, Lumen Health", photoSystemImage: "profile3", isFollowing: false),
        FollowListUser(name: "Dev", jobTitle: "iOS Engineer", photoSystemImage: "profile4", isFollowing: true),
    ]
}

#Preview {
    NavigationStack {
        UserProfileDetailView(profile: .sample, isCurrentUserSubscribed: true)
    }
}

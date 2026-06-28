//
//  LovePost.swift
//  SineX-SwiftUI-iOS
//
//  Created by iOS Developer on 28/06/26.
//

import SwiftUI

// MARK: - Post Model (placeholder — wire to your real model)

struct LovePost: Identifiable {
    let id = UUID()
    let authorName: String
    let authorPhoto: String
    let isVerified: Bool
    let timestamp: String
    let text: String
    let imageSystemImage: String?
    var likeCount: Int
    var commentCount: Int
    var isLiked: Bool
}

struct HomeFeedView: View {

    @State private var posts: [LovePost] = LovePost.sampleData

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
                    LazyVStack(spacing: 16) {
                        ForEach($posts) { $post in
                            PostCardView(post: $post)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 110) // clears floating tab bar
                }
            }
        }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Sonder")
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                Text("Stories from people like you")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.5))
            }

            Spacer()

            Button {
                // navigate to notifications
            } label: {
                Image(systemName: "bell")
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

// MARK: - Post Card

struct PostCardView: View {

    @Binding var post: LovePost

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            // Author row
            HStack(spacing: 10) {
                Circle()
                    .fill(Color.surface)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.4))
                    )

                VStack(alignment: .leading, spacing: 1) {
                    HStack(spacing: 4) {
                        Text(post.authorName)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.white)

                        if post.isVerified {
                            Image(systemName: "checkmark.seal.fill")
                                .font(.caption2)
                                .foregroundStyle(Color.brandPrimary)
                        }
                    }
                    Text(post.timestamp)
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.45))
                }

                Spacer()

                Image(systemName: "ellipsis")
                    .foregroundStyle(.white.opacity(0.4))
                    .padding(8)
            }

            // Text
            Text(post.text)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.9))
                .fixedSize(horizontal: false, vertical: true)

            // Optional image
            if let imageName = post.imageSystemImage {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.surface)
                    .frame(height: 200)
                    .overlay(
                        Image(systemName: imageName)
                            .font(.system(size: 44))
                            .foregroundStyle(.white.opacity(0.2))
                    )
            }

            // Actions
            HStack(spacing: 20) {
                actionButton(
                    icon: post.isLiked ? "heart.fill" : "heart",
                    tint: post.isLiked ? Color.brandPrimary : .white.opacity(0.6),
                    label: "\(post.likeCount)"
                ) {
                    toggleLike()
                }

                actionButton(icon: "bubble.left", tint: .white.opacity(0.6), label: "\(post.commentCount)") {
                    // open comments
                }

                actionButton(icon: "paperplane", tint: .white.opacity(0.6), label: nil) {
                    // share
                }

                Spacer()
            }
            .padding(.top, 4)
        }
        .padding(16)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 22))
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .strokeBorder(.white.opacity(0.08), lineWidth: 1)
        )
    }

    private func actionButton(icon: String, tint: Color, label: String?, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.subheadline.weight(.medium))
                if let label {
                    Text(label)
                        .font(.caption.weight(.medium))
                }
            }
            .foregroundStyle(tint)
        }
        .buttonStyle(.plain)
    }

    private func toggleLike() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            post.isLiked.toggle()
            post.likeCount += post.isLiked ? 1 : -1
        }
    }
}

// MARK: - Sample Data

extension LovePost {
    static let sampleData: [LovePost] = [
        LovePost(authorName: "Maya", authorPhoto: "person.fill", isVerified: true, timestamp: "2h ago",
                  text: "First date jitters are real even after 30. Anyone else feel like dating got harder, not easier, with age? 😅",
                  imageSystemImage: nil, likeCount: 24, commentCount: 8, isLiked: false),
        LovePost(authorName: "Arjun", authorPhoto: "person.fill", isVerified: true, timestamp: "5h ago",
                  text: "Took a chance and asked someone out at a coffee shop today. Small wins count too ☕️",
                  imageSystemImage: "cup.and.saucer.fill", likeCount: 56, commentCount: 14, isLiked: true),
        LovePost(authorName: "Sara", authorPhoto: "person.fill", isVerified: false, timestamp: "1d ago",
                  text: "Reminder: you don't have to settle for someone who makes you feel like 'maybe' instead of 'absolutely.'",
                  imageSystemImage: nil, likeCount: 142, commentCount: 31, isLiked: false),
    ]
}

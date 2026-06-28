//
//  ChatsListView.swift
//  SineX-SwiftUI-iOS
//
//  Created by iOS Developer on 27/06/26.
//

import SwiftUI

struct Conversation: Identifiable {
    let id = UUID()
    let name: String
    let photoSystemImage: String
    let lastMessage: String
    let timestamp: String
    let unreadCount: Int
    let isOnline: Bool
}

struct ChatsListView: View {
    
    @State private var conversations: [Conversation] = Conversation.sampleData
    @State private var searchText = ""
    
    private var filtered: [Conversation] {
        guard !searchText.isEmpty else { return conversations }
        return conversations.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        ZStack {
            Color.backgroundPrimary.ignoresSafeArea()
            
            Color.purpleGlow
                .ignoresSafeArea()
                .frame(height: 220)
                .frame(maxHeight: .infinity, alignment: .top)
            
            VStack(spacing: 0) {
                header
                
                searchField
                    .padding(.horizontal, 24)
                    .padding(.top, 12)
                    .padding(.bottom, 8)
                
                if filtered.isEmpty {
                    emptyState
                } else {
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 4) {
                            ForEach(filtered) { conversation in
                                ConversationRow(conversation: conversation)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 100) // clears the floating tab bar
                    }
                }
            }
        }
    }
    
    private var header: some View {
        HStack {
            Text("Chats")
                .font(.title2.bold())
                .foregroundStyle(.white)
            
            Spacer()
            
            if conversations.contains(where: { $0.unreadCount > 0 }) {
                let totalUnread = conversations.reduce(0) { $0 + $1.unreadCount }
                Text("\(totalUnread) new")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.brandPrimary, in: Capsule())
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
    }
    
    private var searchField: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.white.opacity(0.4))
                .font(.subheadline)
            
            TextField(
                "",
                text: $searchText,
                prompt: Text("Search conversations").foregroundStyle(.white.opacity(0.3))
            )
            .foregroundStyle(.white)
            .font(.subheadline)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 11)
        .background(Color.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(.white.opacity(0.1), lineWidth: 1)
        )
    }
    
    private var emptyState: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "bubble.left.and.bubble.right")
                .font(.system(size: 52))
                .foregroundStyle(.white.opacity(0.25))
            Text("No conversations yet")
                .font(.headline)
                .foregroundStyle(.white)
            Text("When you match with someone, your conversation will show up here.")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.5))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 48)
            Spacer()
            Spacer()
        }
    }
}

// MARK: - Conversation Row

struct ConversationRow: View {
    
    let conversation: Conversation
    
    var body: some View {
        Button {
            // navigate to chat detail
        } label: {
            HStack(spacing: 14) {
                ZStack(alignment: .bottomTrailing) {
                    Circle()
                        .fill(Color.surface)
                        .frame(width: 56, height: 56)
                        .overlay(
                            Image(systemName: conversation.photoSystemImage)
                                .font(.system(size: 22))
                                .foregroundStyle(.white.opacity(0.4))
                        )
                    
                    if conversation.isOnline {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 13, height: 13)
                            .overlay(Circle().strokeBorder(Color.backgroundPrimary, lineWidth: 2))
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(conversation.name)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white)
                    
                    Text(conversation.lastMessage)
                        .font(.caption)
                        .foregroundStyle(conversation.unreadCount > 0 ? .white.opacity(0.85) : .white.opacity(0.45))
                        .lineLimit(1)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 6) {
                    Text(conversation.timestamp)
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.4))
                    
                    if conversation.unreadCount > 0 {
                        Text("\(conversation.unreadCount)")
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(.black)
                            .frame(width: 20, height: 20)
                            .background(Color.brandPrimary, in: Circle())
                    }
                }
            }
            .padding(12)
            .background(
                conversation.unreadCount > 0 ? Color.white.opacity(0.04) : Color.clear,
                in: RoundedRectangle(cornerRadius: 16)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Sample Data

extension Conversation {
    static let sampleData: [Conversation] = [
        Conversation(name: "Maya", photoSystemImage: "person.fill", lastMessage: "Haha that's hilarious 😂", timestamp: "2m", unreadCount: 2, isOnline: true),
        Conversation(name: "Arjun", photoSystemImage: "person.fill", lastMessage: "Sounds good, see you then!", timestamp: "1h", unreadCount: 0, isOnline: false),
        Conversation(name: "Sara", photoSystemImage: "person.fill", lastMessage: "You: Looking forward to it", timestamp: "3h", unreadCount: 0, isOnline: true),
        Conversation(name: "Dev", photoSystemImage: "person.fill", lastMessage: "What did you think of the talk?", timestamp: "Yesterday", unreadCount: 1, isOnline: false),
    ]
}

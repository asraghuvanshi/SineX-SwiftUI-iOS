//
//  AppTab.swift
//  SineX-SwiftUI-iOS
//
//  Created by iOS Developer on 27/06/26.
//

//
//  MainTabView.swift
//  SineX-SwiftUI-iOS
//
//  Created by iOS Developer on 27/06/26.
//


import SwiftUI

// MARK: - Tab Definition

enum AppTab: Int, CaseIterable, Identifiable {
    case home, discover, chats, profile
    
    var id: Int { rawValue }
    
    var title: String {
        switch self {
        case .home:     return "Home"
        case .discover: return "Discover"
        case .chats:    return "Chats"
        case .profile:  return "Profile"
        }
    }
    
    var icon: String {
        switch self {
        case .home:     return "house"
        case .discover: return "square.grid.2x2"
        case .chats:    return "bubble.left.and.bubble.right"
        case .profile:  return "person"
        }
    }
    
    var iconFilled: String {
        switch self {
        case .home:     return "house.fill"
        case .discover: return "square.grid.2x2.fill"
        case .chats:    return "bubble.left.and.bubble.right.fill"
        case .profile:  return "person.fill"
        }
    }
}

// MARK: - Main Tab Container

struct MainTabView: View {
    
    @Environment(AppRouter.self) private var router
    @State private var selectedTab: AppTab = .home
    @State private var showCreatePost = false
  
    @State private var hasUnreadChats = true
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.backgroundPrimary.ignoresSafeArea()
            
            // Active tab content
            Group {
                switch selectedTab {
                case .home:
                    HomeFeedView()
                case .discover:
                    DiscoverGridView()
                case .chats:
                    ChatsListView()
                case .profile:
                    ProfileView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            FloatingTabBar(
                selectedTab: $selectedTab,
                hasUnreadChats: hasUnreadChats,
                onTapCreate: { showCreatePost = true }
            )
            .padding(.horizontal, 20)
            .padding(.bottom, 8)
        }
       
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .sheet(isPresented: $showCreatePost) {
            CreatePostView()
        }
        .preferredColorScheme(.dark)
    }
}

// MARK: - Floating Tab Bar

struct FloatingTabBar: View {
    
    @Binding var selectedTab: AppTab
    var hasUnreadChats: Bool = false
    var onTapCreate: () -> Void
    
    /// Tabs are split left/right of the center create button.
    private var leftTabs: [AppTab] { [.home, .discover] }
    private var rightTabs: [AppTab] { [.chats, .profile] }
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(leftTabs) { tabButton($0) }
            
            createButton
            
            ForEach(rightTabs) { tabButton($0) }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .strokeBorder(Color.white.opacity(0.1), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.35), radius: 20, y: 8)
        .fixedSize(horizontal: false, vertical: true)
    }
    
    private var createButton: some View {
        Button(action: onTapCreate) {
            Image(systemName: "plus")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 48, height: 48)
                .background(Color.primaryGradient, in: Circle())
                .shadow(color: Color.brandPrimary.opacity(0.5), radius: 10, y: 4)
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 4)
    }
    
    private func tabButton(_ tab: AppTab) -> some View {
        let isSelected = selectedTab == tab
        
        return Button {
            if selectedTab != tab {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    selectedTab = tab
                }
            }
        } label: {
            ZStack(alignment: .topTrailing) {
                Image(systemName: isSelected ? tab.iconFilled : tab.icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(isSelected ? Color.brandPrimary : .white.opacity(0.45))
                    .frame(width: 48, height: 44)
                
                if tab == .chats && hasUnreadChats {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 8, height: 8)
                        .offset(x: -8, y: 8)
                }
            }
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Preview

#Preview {
    MainTabView()
        .environment(AppRouter())
}

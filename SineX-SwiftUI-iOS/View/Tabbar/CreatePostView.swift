//
//  CreatePostView.swift
//  SineX-SwiftUI-iOS
//
//  Created by iOS Developer on 28/06/26.
//


import SwiftUI

struct CreatePostView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var postText = ""
    @State private var selectedMood: PostMood = .reflection
    @FocusState private var isFocused: Bool
    
    let charLimit = 500
    
    var isValid: Bool {
        !postText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundPrimary.ignoresSafeArea()
                
                VStack(spacing: 20) {
                    
                    // Mood selector
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(PostMood.allCases) { mood in
                                let isOn = selectedMood == mood
                                Button {
                                    withAnimation(.spring(duration: 0.2)) { selectedMood = mood }
                                } label: {
                                    HStack(spacing: 6) {
                                        Text(mood.emoji)
                                        Text(mood.title)
                                            .font(.subheadline.weight(.medium))
                                    }
                                    .foregroundStyle(isOn ? .black : .white)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                    .background(isOn ? Color.brandPrimary : Color.white.opacity(0.08), in: Capsule())
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.top, 8)
                    
                    // Text editor
                    JourneyCard {
                        VStack(alignment: .leading, spacing: 10) {
                            ZStack(alignment: .topLeading) {
                                if postText.isEmpty {
                                    Text("Share something about your dating life, a win, a thought, a question for the community…")
                                        .foregroundStyle(.white.opacity(0.3))
                                        .font(.subheadline)
                                        .padding(.horizontal, 4)
                                        .padding(.top, 8)
                                }
                                
                                TextEditor(text: $postText)
                                    .foregroundStyle(.white)
                                    .font(.subheadline)
                                    .frame(minHeight: 160)
                                    .scrollContentBackground(.hidden)
                                    .tint(.brandPrimary)
                                    .focused($isFocused)
                                    .onChange(of: postText) { _, new in
                                        if new.count > charLimit {
                                            postText = String(new.prefix(charLimit))
                                        }
                                    }
                            }
                            
                            HStack {
                                Spacer()
                                Text("\(postText.count)/\(charLimit)")
                                    .font(.caption2)
                                    .foregroundStyle(.white.opacity(0.4))
                                    .monospacedDigit()
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    JourneyCTAButton(title: "Post", isDisabled: !isValid) {
                        publishPost()
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 12)
                }
            }
            .navigationTitle("New Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.backgroundPrimary, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundStyle(.white.opacity(0.7))
                }
            }
        }
        .preferredColorScheme(.dark)
        .onAppear { isFocused = true }
    }
    
    private func publishPost() {
        dismiss()
    }
}

// MARK: - Post Mood

enum PostMood: String, CaseIterable, Identifiable {
    case win, vent, question, reflection, advice
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .win:        return "Win"
        case .vent:       return "Vent"
        case .question:   return "Question"
        case .reflection: return "Reflection"
        case .advice:     return "Advice"
        }
    }
    
    var emoji: String {
        switch self {
        case .win:        return "🎉"
        case .vent:       return "😩"
        case .question:   return "❓"
        case .reflection: return "💭"
        case .advice:     return "💡"
        }
    }
}

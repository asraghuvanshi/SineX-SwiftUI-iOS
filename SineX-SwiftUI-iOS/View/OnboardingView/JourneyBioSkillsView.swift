//
//  JourneyBioSkillsView.swift
//  SineX-SwiftUI-iOS
//
//  Created by iOS Developer on 27/06/26.
//

import SwiftUI

struct JourneyBioSkillsView: View {

    @Environment(AppRouter.self) private var router

    @State private var bio = ""
    @State private var selectedSkills: Set<String> = []
    @State private var selectedInterests: Set<String> = []
    @State private var lookingFor: LookingFor = .longTerm
    @State private var relationshipStyle: RelationshipStyle = .monogamous

    @FocusState private var bioFocused: Bool

    let bioLimit = 300

    var isValid: Bool {
        bio.count >= 30 &&
        !selectedSkills.isEmpty &&
        !selectedInterests.isEmpty
    }

    var body: some View {
        ZStack {
            Color.backgroundPrimary.ignoresSafeArea()

            Color.purpleGlow
                .ignoresSafeArea()
                .frame(height: 320)
                .frame(maxHeight: .infinity, alignment: .top)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 28) {

                    JourneyProgressHeader(
                        step: JourneyStep(
                            index: 3, total: 5,
                            title: "About You",
                            subtitle: "Let your personality and passions shine."
                        ),
                        onBack: { router.pop() }
                    )
                    .padding(.top, 16)

                    VStack(spacing: 16) {

                        // Bio
                        JourneyCard {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Label("Your Bio", systemImage: "text.quote")
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(.white.opacity(0.5))
                                        .textCase(.uppercase)
                                        .tracking(0.8)

                                    Spacer()

                                    Text("\(bio.count)/\(bioLimit)")
                                        .font(.caption)
                                        .foregroundStyle(bio.count > bioLimit ? .red : .white.opacity(0.4))
                                        .monospacedDigit()
                                }

                                ZStack(alignment: .topLeading) {
                                    if bio.isEmpty {
                                        Text("Write a short bio — what drives you, what you're building, what you value in a partner…")
                                            .foregroundStyle(.white.opacity(0.3))
                                            .font(.subheadline)
                                            .padding(.horizontal, 14)
                                            .padding(.vertical, 12)
                                    }

                                    TextEditor(text: $bio)
                                        .foregroundStyle(.white)
                                        .font(.subheadline)
                                        .frame(minHeight: 110)
                                        .scrollContentBackground(.hidden)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 8)
                                        .tint(.brandPrimary)
                                        .focused($bioFocused)
                                        .onChange(of: bio) { _, new in
                                            if new.count > bioLimit {
                                                bio = String(new.prefix(bioLimit))
                                            }
                                        }
                                }
                                .background(Color.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 12))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .strokeBorder(
                                            bioFocused ? Color.brandPrimary.opacity(0.85) : Color.white.opacity(0.12),
                                            lineWidth: bioFocused ? 1.5 : 1
                                        )
                                )
                                .animation(.easeInOut(duration: 0.15), value: bioFocused)
                            }
                        }

                        // Tech & Professional Skills
                        JourneyCard {
                            VStack(alignment: .leading, spacing: 12) {
                                Label("Skills (pick up to 8)", systemImage: "cpu")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.white.opacity(0.5))
                                    .textCase(.uppercase)
                                    .tracking(0.8)

                                ChipGrid(
                                    options: ProfessionalSkill.all,
                                    selected: $selectedSkills,
                                    maxSelection: 8
                                )
                            }
                        }

                        // Personal Interests
                        JourneyCard {
                            VStack(alignment: .leading, spacing: 12) {
                                Label("Interests (pick up to 6)", systemImage: "heart.fill")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.white.opacity(0.5))
                                    .textCase(.uppercase)
                                    .tracking(0.8)

                                ChipGrid(
                                    options: PersonalInterest.all,
                                    selected: $selectedInterests,
                                    maxSelection: 6
                                )
                            }
                        }

                        // Looking For
                        JourneyCard {
                            VStack(alignment: .leading, spacing: 12) {
                                Label("Looking For", systemImage: "magnifyingglass.circle.fill")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.white.opacity(0.5))
                                    .textCase(.uppercase)
                                    .tracking(0.8)

                                Picker("Looking For", selection: $lookingFor) {
                                    ForEach(LookingFor.allCases) { l in
                                        Text(l.title).tag(l)
                                    }
                                }
                                .pickerStyle(.segmented)
                            }
                        }

                        // Relationship Style
                        JourneyCard {
                            VStack(alignment: .leading, spacing: 12) {
                                Label("Relationship Style", systemImage: "person.2.fill")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.white.opacity(0.5))
                                    .textCase(.uppercase)
                                    .tracking(0.8)

                                Picker("Style", selection: $relationshipStyle) {
                                    ForEach(RelationshipStyle.allCases) { r in
                                        Text(r.title).tag(r)
                                    }
                                }
                                .pickerStyle(.segmented)
                            }
                        }
                    }
                    .padding(.horizontal, 24)

                    VStack(spacing: 6) {
                        if bio.count < 30 && !bio.isEmpty {
                            Text("Write at least 30 characters for your bio.")
                                .font(.caption)
                                .foregroundStyle(.orange)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 24)
                        }

                        JourneyCTAButton(
                            title: "Continue",
                            isDisabled: !isValid
                        ) {
                            router.push(.journeyPhotoCapture)
                        }
                        .padding(.horizontal, 24)
                    }

                    Spacer(minLength: 32)
                }
            }
        }
        .preferredColorScheme(.dark)
        .onTapGesture { bioFocused = false }
    }
}

// MARK: - Enums

enum LookingFor: String, CaseIterable, Identifiable {
    case longTerm, casual, friendship
    var id: String { rawValue }
    var title: String {
        switch self {
        case .longTerm:   return "Long-term"
        case .casual:     return "Casual"
        case .friendship: return "Friendship"
        }
    }
}

enum RelationshipStyle: String, CaseIterable, Identifiable {
    case monogamous, openToExploring
    var id: String { rawValue }
    var title: String {
        switch self {
        case .monogamous:      return "Monogamous"
        case .openToExploring: return "Open to it"
        }
    }
}

// MARK: - Static data

enum ProfessionalSkill {
    static let all: [String] = [
        "iOS", "Android", "SwiftUI", "React", "Node.js", "Python",
        "Machine Learning", "Data Science", "Product", "UX Design",
        "DevOps", "Cloud", "Blockchain", "Cybersecurity", "Finance",
        "Marketing", "Sales", "Operations", "Legal", "Healthcare"
    ]
}

enum PersonalInterest {
    static let all: [String] = [
        "Startups", "Investing", "Travel", "Fitness", "Reading",
        "Gaming", "Music", "Art", "Cooking", "Photography",
        "Hiking", "Yoga", "Coffee", "Podcasts", "Writing",
        "Volunteering", "Chess", "Cycling"
    ]
}

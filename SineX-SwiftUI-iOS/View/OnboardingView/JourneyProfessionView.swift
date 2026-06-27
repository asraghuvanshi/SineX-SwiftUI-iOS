//
//  JourneyProfessionView.swift
//  SineX-SwiftUI-iOS
//
//  Created by iOS Developer on 27/06/26.
//


import SwiftUI

struct JourneyProfessionView: View {

    @Environment(AppRouter.self) private var router

    @State private var jobTitle = ""
    @State private var company = ""
    @State private var workMode: WorkMode = .hybrid
    @State private var industry: Industry = .technology
    @State private var experienceYears: ExperienceRange = .threeToFive

    @FocusState private var focusedField: Field?

    enum Field { case jobTitle, company }

    var isValid: Bool {
        !jobTitle.trimmingCharacters(in: .whitespaces).isEmpty &&
        !company.trimmingCharacters(in: .whitespaces).isEmpty
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
                            index: 1, total: 5,
                            title: "Your Professional Life",
                            subtitle: "Help us match you with compatible professionals."
                        ),
                        onBack: { router.pop() }
                    )
                    .padding(.top, 16)

                    VStack(spacing: 16) {

                        // Job Title
                        JourneyCard {
                            VStack(alignment: .leading, spacing: 12) {
                                Label("Job Title", systemImage: "briefcase.fill")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.white.opacity(0.5))
                                    .textCase(.uppercase)
                                    .tracking(0.8)

                                JourneyTextField(
                                    placeholder: "e.g. Senior Software Engineer",
                                    text: $jobTitle,
                                    icon: "briefcase",
                                    submitLabel: .next,
                                    onSubmit: { focusedField = .company }
                                )
                                .focused($focusedField, equals: .jobTitle)
                            }
                        }

                        // Company
                        JourneyCard {
                            VStack(alignment: .leading, spacing: 12) {
                                Label("Company", systemImage: "building.2.fill")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.white.opacity(0.5))
                                    .textCase(.uppercase)
                                    .tracking(0.8)

                                JourneyTextField(
                                    placeholder: "Where do you work?",
                                    text: $company,
                                    icon: "building.2",
                                    submitLabel: .done,
                                    onSubmit: { focusedField = nil }
                                )
                                .focused($focusedField, equals: .company)
                            }
                        }

                        // Industry
                        JourneyCard {
                            VStack(alignment: .leading, spacing: 12) {
                                Label("Industry", systemImage: "globe")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.white.opacity(0.5))
                                    .textCase(.uppercase)
                                    .tracking(0.8)

                                Picker("Industry", selection: $industry) {
                                    ForEach(Industry.allCases) { i in
                                        Text(i.title).tag(i)
                                    }
                                }
                                .pickerStyle(.menu)
                                .accentColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }

                        // Work Mode
                        JourneyCard {
                            VStack(alignment: .leading, spacing: 12) {
                                Label("Work Mode", systemImage: "laptopcomputer")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.white.opacity(0.5))
                                    .textCase(.uppercase)
                                    .tracking(0.8)

                                Picker("Work Mode", selection: $workMode) {
                                    ForEach(WorkMode.allCases) { m in
                                        Text(m.title).tag(m)
                                    }
                                }
                                .pickerStyle(.segmented)
                            }
                        }

                        // Experience
                        JourneyCard {
                            VStack(alignment: .leading, spacing: 12) {
                                Label("Years of Experience", systemImage: "calendar.badge.clock")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.white.opacity(0.5))
                                    .textCase(.uppercase)
                                    .tracking(0.8)

                                Picker("Experience", selection: $experienceYears) {
                                    ForEach(ExperienceRange.allCases) { e in
                                        Text(e.title).tag(e)
                                    }
                                }
                                .pickerStyle(.segmented)
                            }
                        }
                    }
                    .padding(.horizontal, 24)

                    JourneyCTAButton(
                        title: "Continue",
                        isDisabled: !isValid
                    ) {
                        router.push(.journeyEducation)
                    }
                    .padding(.horizontal, 24)

                    Spacer(minLength: 32)
                }
            }
        }
        .preferredColorScheme(.dark)
        .onTapGesture { focusedField = nil }
    }
}

// MARK: - Supporting Enums

enum WorkMode: String, CaseIterable, Identifiable {
    case remote, hybrid, onsite
    var id: String { rawValue }
    var title: String {
        switch self {
        case .remote: return "Remote"
        case .hybrid: return "Hybrid"
        case .onsite: return "On-site"
        }
    }
}

enum ExperienceRange: String, CaseIterable, Identifiable {
    case zeroToOne, oneToThree, threeToFive, fivePlus, tenPlus
    var id: String { rawValue }
    var title: String {
        switch self {
        case .zeroToOne:   return "0–1 yr"
        case .oneToThree:  return "1–3 yrs"
        case .threeToFive: return "3–5 yrs"
        case .fivePlus:    return "5–10 yrs"
        case .tenPlus:     return "10+ yrs"
        }
    }
}

enum Industry: String, CaseIterable, Identifiable {
    case technology, finance, healthcare, design, marketing, consulting, education, legal, other
    var id: String { rawValue }
    var title: String { rawValue.capitalized }
}

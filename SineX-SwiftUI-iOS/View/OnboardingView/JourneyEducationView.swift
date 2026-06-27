//
//  JourneyEducationView.swift
//  SineX-SwiftUI-iOS
//
//  Created by iOS Developer on 27/06/26.
//


import SwiftUI

struct JourneyEducationView: View {

    @Environment(AppRouter.self) private var router

    @State private var degree: DegreeLevel = .bachelors
    @State private var fieldOfStudy = ""
    @State private var university = ""
    @State private var graduationYear = Calendar.current.component(.year, from: Date())

    @FocusState private var focusedField: Field?
    enum Field { case fieldOfStudy, university }

    let yearRange = Array((1970...Calendar.current.component(.year, from: Date())).reversed())

    var isValid: Bool {
        !fieldOfStudy.trimmingCharacters(in: .whitespaces).isEmpty &&
        !university.trimmingCharacters(in: .whitespaces).isEmpty
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
                            index: 2, total: 5,
                            title: "Education Background",
                            subtitle: "Shared academics spark great conversations."
                        ),
                        onBack: { router.pop() }
                    )
                    .padding(.top, 16)

                    VStack(spacing: 16) {

                        // Degree Level
                        JourneyCard {
                            VStack(alignment: .leading, spacing: 12) {
                                Label("Highest Degree", systemImage: "graduationcap.fill")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.white.opacity(0.5))
                                    .textCase(.uppercase)
                                    .tracking(0.8)

                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 10) {
                                        ForEach(DegreeLevel.allCases) { d in
                                            let isOn = degree == d
                                            Button {
                                                withAnimation(.spring(duration: 0.2)) { degree = d }
                                            } label: {
                                                Text(d.title)
                                                    .font(.subheadline.weight(.medium))
                                                    .foregroundStyle(isOn ? .black : .white)
                                                    .padding(.horizontal, 14)
                                                    .padding(.vertical, 8)
                                                    .background(isOn ? Color.brandPrimary : Color.white.opacity(0.1),
                                                                in: Capsule())
                                            }
                                            .buttonStyle(.plain)
                                        }
                                    }
                                }
                            }
                        }

                        // Field of Study
                        JourneyCard {
                            VStack(alignment: .leading, spacing: 12) {
                                Label("Field of Study", systemImage: "book.fill")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.white.opacity(0.5))
                                    .textCase(.uppercase)
                                    .tracking(0.8)

                                JourneyTextField(
                                    placeholder: "e.g. Computer Science",
                                    text: $fieldOfStudy,
                                    icon: "book",
                                    submitLabel: .next,
                                    onSubmit: { focusedField = .university }
                                )
                                .focused($focusedField, equals: .fieldOfStudy)
                            }
                        }

                        // University
                        JourneyCard {
                            VStack(alignment: .leading, spacing: 12) {
                                Label("University / College", systemImage: "building.columns.fill")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.white.opacity(0.5))
                                    .textCase(.uppercase)
                                    .tracking(0.8)

                                JourneyTextField(
                                    placeholder: "Institution name",
                                    text: $university,
                                    icon: "building.columns",
                                    submitLabel: .done,
                                    onSubmit: { focusedField = nil }
                                )
                                .focused($focusedField, equals: .university)
                            }
                        }

                        // Graduation Year
                        JourneyCard {
                            VStack(alignment: .leading, spacing: 12) {
                                Label("Graduation Year", systemImage: "calendar")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.white.opacity(0.5))
                                    .textCase(.uppercase)
                                    .tracking(0.8)

                                Picker("Year", selection: $graduationYear) {
                                    ForEach(yearRange, id: \.self) { year in
                                        Text(String(year)).tag(year)
                                    }
                                }
                                .pickerStyle(.wheel)
                                .frame(height: 100)
                                .clipped()
                            }
                        }
                    }
                    .padding(.horizontal, 24)

                    JourneyCTAButton(
                        title: "Continue",
                        isDisabled: !isValid
                    ) {
                        router.push(.journeyBioSkills)
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

// MARK: - Degree Level

enum DegreeLevel: String, CaseIterable, Identifiable {
    case highSchool, associates, bachelors, masters, mba, phd, other
    var id: String { rawValue }
    var title: String {
        switch self {
        case .highSchool:  return "High School"
        case .associates:  return "Associate's"
        case .bachelors:   return "Bachelor's"
        case .masters:     return "Master's"
        case .mba:         return "MBA"
        case .phd:         return "PhD"
        case .other:       return "Other"
        }
    }
}

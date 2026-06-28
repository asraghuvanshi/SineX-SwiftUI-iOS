//
//  EditProfileView.swift
//  SineX-SwiftUI-iOS
//
//  Created by iOS Developer on 28/06/26.
//


import SwiftUI

struct EditProfileView: View {

    @Environment(\.dismiss) private var dismiss

    // Seed these from the real user/session model
    @State private var name = "Alex Morgan"
    @State private var jobTitle = "Senior Software Engineer"
    @State private var company = "Stripe"
    @State private var university = "UC Berkeley"
    @State private var bio = "Building things that matter, one product at a time. Looking for someone who's equally obsessed with their craft and knows how to switch off on weekends."
    @State private var selectedSkills: Set<String> = ["iOS", "SwiftUI", "Product"]
    @State private var selectedInterests: Set<String> = ["Travel", "Coffee", "Hiking"]
    @State private var workMode: WorkMode = .hybrid

    @FocusState private var focusedField: Field?
    enum Field { case name, jobTitle, company, university }

    let bioLimit = 300

    @State private var showDiscardAlert = false
    @State private var hasChanges = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundPrimary.ignoresSafeArea()

                Color.purpleGlow
                    .ignoresSafeArea()
                    .frame(height: 260)
                    .frame(maxHeight: .infinity, alignment: .top)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {

                        photoSection

                        // Name
                        JourneyCard {
                            VStack(alignment: .leading, spacing: 12) {
                                fieldLabel("Name", icon: "person.fill")
                                JourneyTextField(
                                    placeholder: "Your full name",
                                    text: $name,
                                    icon: "person",
                                    submitLabel: .next,
                                    onSubmit: { focusedField = .jobTitle }
                                )
                                .focused($focusedField, equals: .name)
                                .onChange(of: name) { _, _ in hasChanges = true }
                            }
                        }

                        // Job Title
                        JourneyCard {
                            VStack(alignment: .leading, spacing: 12) {
                                fieldLabel("Job Title", icon: "briefcase.fill")
                                JourneyTextField(
                                    placeholder: "e.g. Senior Software Engineer",
                                    text: $jobTitle,
                                    icon: "briefcase",
                                    submitLabel: .next,
                                    onSubmit: { focusedField = .company }
                                )
                                .focused($focusedField, equals: .jobTitle)
                                .onChange(of: jobTitle) { _, _ in hasChanges = true }
                            }
                        }

                        // Company
                        JourneyCard {
                            VStack(alignment: .leading, spacing: 12) {
                                fieldLabel("Company", icon: "building.2.fill")
                                JourneyTextField(
                                    placeholder: "Where do you work?",
                                    text: $company,
                                    icon: "building.2",
                                    submitLabel: .next,
                                    onSubmit: { focusedField = .university }
                                )
                                .focused($focusedField, equals: .company)
                                .onChange(of: company) { _, _ in hasChanges = true }
                            }
                        }

                        // Work Mode
                        JourneyCard {
                            VStack(alignment: .leading, spacing: 12) {
                                fieldLabel("Work Mode", icon: "laptopcomputer")
                                Picker("Work Mode", selection: $workMode) {
                                    ForEach(WorkMode.allCases) { m in
                                        Text(m.title).tag(m)
                                    }
                                }
                                .pickerStyle(.segmented)
                                .onChange(of: workMode) { _, _ in hasChanges = true }
                            }
                        }

                        // University
                        JourneyCard {
                            VStack(alignment: .leading, spacing: 12) {
                                fieldLabel("University / College", icon: "building.columns.fill")
                                JourneyTextField(
                                    placeholder: "Institution name",
                                    text: $university,
                                    icon: "building.columns",
                                    submitLabel: .done,
                                    onSubmit: { focusedField = nil }
                                )
                                .focused($focusedField, equals: .university)
                                .onChange(of: university) { _, _ in hasChanges = true }
                            }
                        }

                        // Bio
                        JourneyCard {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    fieldLabel("Bio", icon: "text.quote")
                                    Spacer()
                                    Text("\(bio.count)/\(bioLimit)")
                                        .font(.caption)
                                        .foregroundStyle(bio.count > bioLimit ? .red : .white.opacity(0.4))
                                        .monospacedDigit()
                                }

                                ZStack(alignment: .topLeading) {
                                    if bio.isEmpty {
                                        Text("Write a short bio…")
                                            .foregroundStyle(.white.opacity(0.3))
                                            .font(.subheadline)
                                            .padding(.horizontal, 4)
                                            .padding(.top, 8)
                                    }

                                    TextEditor(text: $bio)
                                        .foregroundStyle(.white)
                                        .font(.subheadline)
                                        .frame(minHeight: 100)
                                        .scrollContentBackground(.hidden)
                                        .tint(.brandPrimary)
                                        .onChange(of: bio) { _, new in
                                            if new.count > bioLimit {
                                                bio = String(new.prefix(bioLimit))
                                            }
                                            hasChanges = true
                                        }
                                }
                                .padding(.horizontal, 4)
                                .background(Color.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 12))
                            }
                        }

                        // Skills
                        JourneyCard {
                            VStack(alignment: .leading, spacing: 12) {
                                fieldLabel("Skills", icon: "cpu")
                                ChipGrid(
                                    options: ProfessionalSkill.all,
                                    selected: $selectedSkills,
                                    maxSelection: 8
                                )
                                .onChange(of: selectedSkills) { _, _ in hasChanges = true }
                            }
                        }

                        // Interests
                        JourneyCard {
                            VStack(alignment: .leading, spacing: 12) {
                                fieldLabel("Interests", icon: "heart.fill")
                                ChipGrid(
                                    options: PersonalInterest.all,
                                    selected: $selectedInterests,
                                    maxSelection: 6
                                )
                                .onChange(of: selectedInterests) { _, _ in hasChanges = true }
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 12)
                    .padding(.bottom, 32)
                }
                .onTapGesture { focusedField = nil }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.backgroundPrimary, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        if hasChanges {
                            showDiscardAlert = true
                        } else {
                            dismiss()
                        }
                    }
                    .foregroundStyle(.white.opacity(0.7))
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        saveChanges()
                    }
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color.brandPrimary)
                    .disabled(!hasChanges)
                }
            }
            .alert("Discard changes?", isPresented: $showDiscardAlert) {
                Button("Discard", role: .destructive) { dismiss() }
                Button("Keep Editing", role: .cancel) {}
            } message: {
                Text("You have unsaved changes. Are you sure you want to discard them?")
            }
        }
        .preferredColorScheme(.dark)
    }

    // MARK: Photo Section

    private var photoSection: some View {
        VStack(spacing: 10) {
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(Color.surface)
                    .frame(width: 100, height: 100)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 42))
                            .foregroundStyle(.white.opacity(0.35))
                    )

                Button {
                    // open photo picker / re-trigger photo capture journey step
                } label: {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 32, height: 32)
                        .background(Color.brandPrimary, in: Circle())
                        .overlay(Circle().strokeBorder(Color.backgroundPrimary, lineWidth: 3))
                }
            }

            Button("Manage Photos") {
                // navigate to photo management screen
            }
            .font(.caption.weight(.semibold))
            .foregroundStyle(Color.brandPrimary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 8)
        .padding(.bottom, 4)
    }

    // MARK: Helpers

    private func fieldLabel(_ text: String, icon: String) -> some View {
        Label(text, systemImage: icon)
            .font(.caption.weight(.semibold))
            .foregroundStyle(.white.opacity(0.5))
            .textCase(.uppercase)
            .tracking(0.8)
    }

    private func saveChanges() {
        // TODO: persist name/jobTitle/company/university/bio/skills/interests
        // to your backend or Firestore here.
        hasChanges = false
        dismiss()
    }
}

#Preview {
    EditProfileView()
}

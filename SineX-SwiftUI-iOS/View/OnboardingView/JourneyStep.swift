//
//  JourneyStep.swift
//  SineX-SwiftUI-iOS
//
//  Created by iOS Developer on 27/06/26.
//


import SwiftUI


struct JourneyStep {
    let index: Int      // 1-based
    let total: Int
    let title: String
    let subtitle: String
}

// MARK: - Journey Progress Header

struct JourneyProgressHeader: View {

    let step: JourneyStep
    let onBack: (() -> Void)?

    var body: some View {
        VStack(spacing: 16) {

            HStack {
                if let onBack {
                    Button(action: onBack) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(width: 36, height: 36)
                            .background(.white.opacity(0.12), in: Circle())
                    }
                } else {
                    Spacer().frame(width: 36)
                }

                Spacer()

                Text("Step \(step.index) of \(step.total)")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.white.opacity(0.6))
                    .monospacedDigit()
            }

            // Segmented progress bar
            HStack(spacing: 5) {
                ForEach(1...step.total, id: \.self) { i in
                    Capsule()
                        .fill(i <= step.index ? Color.brandPrimary : Color.white.opacity(0.15))
                        .frame(height: 4)
                        .animation(.easeInOut(duration: 0.4), value: step.index)
                }
            }

            // Title
            VStack(alignment: .leading, spacing: 4) {
                Text(step.title)
                    .font(.title2.bold())
                    .foregroundStyle(.white)

                Text(step.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.55))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 24)
        .padding(.top, 12)
    }
}

// MARK: - Journey Glass Card

struct JourneyCard<Content: View>: View {

    @ViewBuilder var content: Content

    var body: some View {
        content
            .padding(20)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(.white.opacity(0.1), lineWidth: 1)
            )
    }
}

// MARK: - Journey Styled TextField

/// A polished, pill-bordered text field meant to be dropped inside a JourneyCard.
/// Replaces the bare, borderless `TextField` previously used across the journey
/// flow — gives it a visible background, padding, rounded border, and a focus
/// highlight that picks up the brand color.
struct JourneyTextField: View {

    let placeholder: String
    @Binding var text: String
    var icon: String? = nil
    var keyboardType: UIKeyboardType = .default
    var submitLabel: SubmitLabel = .next
    var onSubmit: () -> Void = {}

    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(spacing: 10) {
            if let icon {
                Image(systemName: icon)
                    .font(.subheadline)
                    .foregroundStyle(isFocused ? Color.brandPrimary : .white.opacity(0.35))
                    .frame(width: 18)
            }

            TextField(
                "",
                text: $text,
                prompt: Text(placeholder).foregroundStyle(.white.opacity(0.3))
            )
            .foregroundStyle(.white)
            .font(.subheadline.weight(.medium))
            .keyboardType(keyboardType)
            .submitLabel(submitLabel)
            .focused($isFocused)
            .onSubmit(onSubmit)
            .tint(.brandPrimary)

            if !text.isEmpty {
                Button {
                    withAnimation(.easeInOut(duration: 0.15)) { text = "" }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.3))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(Color.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(
                    isFocused ? Color.brandPrimary.opacity(0.85) : Color.white.opacity(0.12),
                    lineWidth: isFocused ? 1.5 : 1
                )
        )
        .animation(.easeInOut(duration: 0.15), value: isFocused)
    }
}

// MARK: - Chip / Tag Selector

struct ChipGrid: View {

    let options: [String]
    @Binding var selected: Set<String>
    var maxSelection: Int = 99

    let columns = [GridItem(.adaptive(minimum: 90), spacing: 10)]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(options, id: \.self) { option in
                let isOn = selected.contains(option)
                Button {
                    withAnimation(.spring(duration: 0.2)) {
                        if isOn {
                            selected.remove(option)
                        } else if selected.count < maxSelection {
                            selected.insert(option)
                        }
                    }
                } label: {
                    Text(option)
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(isOn ? .black : .white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(isOn ? Color.brandPrimary : Color.white.opacity(0.1),
                                    in: Capsule())
                        .overlay(
                            Capsule()
                                .strokeBorder(isOn ? Color.clear : Color.white.opacity(0.15))
                        )
                }
                .buttonStyle(.plain)
            }
        }
    }
}

// MARK: - Journey CTA Button

struct JourneyCTAButton: View {

    let title: String
    var isDisabled: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(
                    isDisabled
                        ? AnyShapeStyle(Color.white.opacity(0.15))
                        : AnyShapeStyle(Color.brandPrimary),
                    in: RoundedRectangle(cornerRadius: 16)
                )
        }
        .disabled(isDisabled)
        .animation(.easeInOut(duration: 0.2), value: isDisabled)
    }
}

//
//  GlassTextField.swift
//  SineX-SwiftUI-iOS
//
//  Created by iOS Developer on 26/06/26.
//

import SwiftUI

struct GlassTextField: View {

    let icon: String
    let placeholder: String

    @Binding var text: String
    var isFocused: Bool = false

    var body: some View {

        HStack(spacing: 12) {

            Image(systemName: icon)
                .foregroundStyle(isFocused ? Color.brandPrimary : Color.textMuted)

            TextField(
                "",
                text: $text,
                prompt: Text(placeholder)
                    .foregroundStyle(Color.textMuted)
            )
            .foregroundStyle(Color.textPrimary)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
        }
        .padding(.horizontal, 16)
        .frame(height: 58)
        .background(Color.surface)
        .clipShape(
            RoundedRectangle(cornerRadius: 16)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    isFocused ? Color.borderFocused : Color.borderSubtle,
                    lineWidth: isFocused ? 1.5 : 1
                )
        }
        .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
}


struct GlassSecureField: View {

    let icon: String
    let placeholder: String

    @Binding var text: String
    @Binding var showPassword: Bool
    var isFocused: Bool = false

    var body: some View {

        HStack(spacing: 12) {

            Image(systemName: icon)
                .foregroundStyle(isFocused ? Color.brandPrimary : Color.textMuted)

            Group {
                if showPassword {
                    TextField(
                        "",
                        text: $text,
                        prompt: Text(placeholder)
                            .foregroundStyle(Color.textMuted)
                    )
                } else {
                    SecureField(
                        "",
                        text: $text,
                        prompt: Text(placeholder)
                            .foregroundStyle(Color.textMuted)
                    )
                }
            }
            .foregroundStyle(Color.textPrimary)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()

            Button {
                showPassword.toggle()
            } label: {
                Image(systemName:
                        showPassword
                      ? "eye.slash.fill"
                      : "eye.fill")
                .foregroundStyle(Color.textMuted)
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 58)
        .background(Color.surface)
        .clipShape(
            RoundedRectangle(cornerRadius: 16)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    isFocused ? Color.borderFocused : Color.borderSubtle,
                    lineWidth: isFocused ? 1.5 : 1
                )
        }
        .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
}

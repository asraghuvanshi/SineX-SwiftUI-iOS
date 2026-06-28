//
//  SignupView.swift
//  SineX-SwiftUI-iOS
//
//  Created by iOS Developer on 26/06/26.
//

import SwiftUI

struct SignupView: View {
    
    @Environment(AppRouter.self) private var router
    
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false
    
    @State private var dateOfBirth = Calendar.current.date(byAdding: .year, value: -18, to: Date())!
    
    @State private var gender: Gender = .male
    @State private var interestedIn: InterestedIn = .women
    @State private var acceptedTerms = false
    
    @FocusState private var focusedField: Field?
    
    enum Field {
        case fullName
        case email
        case password
    }
    
    var body: some View {
        
        ZStack {
            
            Color.backgroundPrimary
                .ignoresSafeArea()
            
            Color.purpleGlow
                .ignoresSafeArea()
                .frame(height: 400)
                .frame(maxHeight: .infinity, alignment: .top)
            
            ScrollView {
                
                VStack(spacing: 24) {
                    
                    Spacer(minLength: 40)
                    
                    Image(systemName: "person.crop.circle.badge.plus.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 90, height: 90)
                        .foregroundStyle(Color.primaryGradient)
                    
                    VStack(spacing: 8) {
                        
                        Text("Create Account")
                            .font(.largeTitle.bold())
                            .foregroundStyle(Color.textPrimary)
                        
                        Text("Join a community built for builders")
                            .foregroundStyle(Color.textSecondary)
                    }
                    
                    VStack(spacing: 24) {
                        
                        GlassTextField(
                            icon: "person.fill",
                            placeholder: "Full Name",
                            text: $fullName,
                            isFocused: focusedField == .fullName
                        )
                        .focused($focusedField, equals: .fullName)
                        
                        GlassTextField(
                            icon: "envelope.fill",
                            placeholder: "Email",
                            text: $email,
                            isFocused: focusedField == .email
                        )
                        .focused($focusedField, equals: .email)
                        
                        GlassSecureField(
                            icon: "lock.fill",
                            placeholder: "Password",
                            text: $password,
                            showPassword: $showPassword,
                            isFocused: focusedField == .password
                        )
                        .focused($focusedField, equals: .password)
                        
                        DatePicker(
                            "Date of Birth",
                            selection: $dateOfBirth,
                            in: ...Date(),
                            displayedComponents: .date
                        )
                        
                        VStack(alignment: .leading, spacing: 8) {
                            
                            Text("Gender")
                                .foregroundStyle(.white)
                            
                            Picker("Gender", selection: $gender) {
                                ForEach(Gender.allCases) {
                                    Text($0.title).tag($0)
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            
                            Text("Interested In")
                                .foregroundStyle(.white)
                            
                            Picker("Interested In", selection: $interestedIn) {
                                ForEach(InterestedIn.allCases) {
                                    Text($0.title).tag($0)
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                        
                        Toggle(isOn: $acceptedTerms) {
                            Text("I agree to the Terms & Privacy Policy")
                                .foregroundStyle(.white)
                        }
                        
                        AppGradientButton(
                            title: "Create Account",
                            isLoading: false
                        ) {
                            handleSignup()
                        }
                        .disabled(!acceptedTerms)
                        
                    }
                    .padding(.horizontal, 24)
                    
                    HStack {
                        
                        Text("Already have an account?")
                            .foregroundStyle(Color.textSecondary)
                        
                        Button("Sign In") {
                            router.pop()
                        }
                        .foregroundStyle(Color.brandPrimary)
                    }
                    
                    Spacer(minLength: 30)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .preferredColorScheme(.dark)
    }
    
    private func handleSignup() {
        
        focusedField = nil
        
        print(fullName)
        print(email)
        print(password)
        print(dateOfBirth)
        print(gender)
        print(interestedIn)
        router.push(.journeyProfession)
    }
}

enum Gender: String, CaseIterable, Identifiable {
    
    case male
    case female
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .male: return "Male"
        case .female: return "Female"
        }
    }
}

enum InterestedIn: String, CaseIterable, Identifiable {
    
    case men
    case women
    case everyone
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .men: return "Men"
        case .women: return "Women"
        case .everyone: return "Everyone"
        }
    }
}

//#Preview {
//    NavigationStack {
//        SignupView()
//            .environment(AppRouter())
//    }
//}

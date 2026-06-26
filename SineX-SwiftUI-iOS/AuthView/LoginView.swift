//
//  LoginView.swift
//  SineX-SwiftUI-iOS
//
//  Created by iOS Developer on 21/06/26.
//

import SwiftUI

struct LoginView: View {
    
    @Environment(AppRouter.self) private var router
    
    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false
    @FocusState private var focusedField: Field?
    
    enum Field {
        case email, password
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
                VStack(spacing: 30) {
                    
                    Spacer(minLength: 40)
                    
                    VStack(spacing: 24) {
                        
                        Image(systemName: "paperplane.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 90, height: 90)
                            .foregroundStyle(Color.primaryGradient)
                        
                        VStack(spacing: 8) {
                            Text("Welcome Back")
                                .font(.largeTitle.bold())
                                .foregroundStyle(Color.textPrimary)
                            
                            Text("Sign in to continue your journey")
                                .foregroundStyle(Color.textSecondary)
                        }
                        
                        VStack(spacing: 24) {
                            
                            GlassTextField(
                                icon: "envelope.fill",
                                placeholder: "Email",
                                text: $email,
                                isFocused: focusedField == .email
                            )
                            .focused($focusedField, equals: .email)
                            .keyboardType(.emailAddress)
                            
                            GlassSecureField(
                                icon: "lock.fill",
                                placeholder: "Password",
                                text: $password,
                                showPassword: $showPassword,
                                isFocused: focusedField == .password
                            )
                            .focused($focusedField, equals: .password)
                        }
                        
                        HStack {
                            Spacer()
                            
                            Button("Forgot Password?") {
                                router.pushAuth(.forgotPassword)
                            }
                            .font(.callout.bold())
                            .foregroundStyle(Color.textSecondary)
                        }
                        
                        AppGradientButton(
                            title: "Sign In",
                            isLoading: false
                        ) {
                            handleLogin()
                        }
                        
                        HStack {
                            Rectangle()
                                .fill(Color.borderSubtle)
                                .frame(height: 1)
                            
                            Text("OR")
                                .foregroundStyle(Color.textMuted)
                            
                            Rectangle()
                                .fill(Color.borderSubtle)
                                .frame(height: 1)
                        }
                        
                        HStack(spacing: 12) {
                            SocialButton(title: "Apple", icon: "apple.logo")
                            SocialButton(title: "Google", icon: "globe")
                        }
                    }
                    .padding(24)
                    
                    HStack {
                        Text("Don't have an account?")
                            .foregroundStyle(Color.textSecondary)
                        
                        Button("Sign Up") {
                            router.pushAuth(.signup)
                        }
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.brandPrimary)
                    }
                    
                    Spacer(minLength: 30)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
    
    private func handleLogin() {
        focusedField = nil
        // Hook up real auth here. On success:
        // SessionService.shared.save(token: idToken)
        // router.resetTo(.home)
    }
}

//#Preview {
//    LoginView()
//        .environment(AppRouter())
//}

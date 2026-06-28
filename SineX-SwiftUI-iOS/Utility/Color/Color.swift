//
//  Color.swift
//  SineX-SwiftUI-iOS
//
//  Created by iOS Developer on 21/06/26.
//

import Foundation
import SwiftUI


// MARK: - Brand Colors

extension Color {
    // Primary Colors
    static let brandPrimary = Color(hex: "#7C3AED")      // Vibrant Purple
    static let brandSecondary = Color(hex: "#A78BFA")    // Light Purple
    static let brandAccent = Color(hex: "#F59E0B")       // Warm Amber/Gold
    
    // Gradients
    static let primaryGradient = LinearGradient(
        colors: [
            Color.purple,
            Color.blue
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    
    static let purpleGlow = LinearGradient(
        colors: [
            Color(hex: "#7C3AED").opacity(0.3),
            Color(hex: "#4F46E5").opacity(0.1),
            Color.clear
        ],
        startPoint: .top,
        endPoint: .bottom
    )
    
    // Background Colors
    static let backgroundPrimary = Color(hex: "#0A0A0F")   // Deep almost-black
    static let backgroundSecondary = Color(hex: "#14141E") // Dark navy-purple
    static let surface = Color(hex: "#1A1A2E")             // Card background
    static let surfaceElevated = Color(hex: "#252540")     // Elevated card
    
    // Text Colors
    static let textPrimary = Color(hex: "#FFFFFF")
    static let textSecondary = Color(hex: "#94A3B8")       // Slate Gray
    static let textMuted = Color(hex: "#64748B")           // Darker slate
    
    // Accent Colors
    static let success = Color(hex: "#10B981")             // Emerald Green
    static let error = Color(hex: "#EF4444")               // Red
    static let warning = Color(hex: "#F59E0B")             // Amber
    
    // Border Colors
    static let borderSubtle = Color(hex: "#2D2D44")
    static let borderFocused = Color(hex: "#7C3AED")
    
    // Helper for hex colors
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

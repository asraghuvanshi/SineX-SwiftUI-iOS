//
//  JourneyLivenessView.swift
//  SineX-SwiftUI-iOS
//
//  Created by iOS Developer on 27/06/26.
//


import SwiftUI
import AVFoundation
import Combine

// MARK: - Liveness Verification View

struct JourneyLivenessView: View {
    
    @Environment(AppRouter.self) private var router
    @StateObject private var session = LivenessCameraSession()
    
    @State private var currentInstruction = 0
    @State private var completedInstructions: Set<Int> = []
    @State private var isVerified = false
    @State private var isCaptured = false
    @State private var capturedFrame: UIImage?
    @State private var showPermissionDenied = false
    @State private var isCapturing = false
    
    let instructions = [
        LivenessInstruction(icon: "face.smiling", text: "Look straight ahead", color: .blue),
        LivenessInstruction(icon: "arrow.turn.up.left", text: "Turn your head slightly left", color: .purple),
        LivenessInstruction(icon: "arrow.turn.up.right", text: "Turn your head slightly right", color: .pink),
        LivenessInstruction(icon: "eye", text: "Blink slowly", color: .teal),
    ]
    
    var body: some View {
        ZStack {
            Color.backgroundPrimary.ignoresSafeArea()
            
            Color.purpleGlow
                .ignoresSafeArea()
                .frame(height: 280)
                .frame(maxHeight: .infinity, alignment: .top)
            
            VStack(spacing: 0) {
                
                JourneyProgressHeader(
                    step: JourneyStep(
                        index: 5, total: 5,
                        title: "Identity Verification",
                        subtitle: "A quick liveness check keeps everyone safe."
                    ),
                    onBack: { router.pop() }
                )
                .padding(.top, 16)
                
                Spacer()
                
                if showPermissionDenied {
                    PermissionDeniedView()
                } else {
                    VStack(spacing: 28) {
                        
                        // Camera preview with oval overlay
                        ZStack {
                            LiveCameraPreview(session: session.captureSession)
                                .frame(width: 260, height: 320)
                                .clipShape(RoundedRectangle(cornerRadius: 24))
                            
                            // Oval face guide
                            Ellipse()
                                .strokeBorder(
                                    isVerified ? Color.green : Color.brandPrimary,
                                    lineWidth: 3
                                )
                                .frame(width: 200, height: 260)
                                .animation(.easeInOut(duration: 0.4), value: isVerified)
                            
                            // Captured flash overlay
                            if isCaptured {
                                Color.white.opacity(0.5)
                                    .frame(width: 260, height: 320)
                                    .clipShape(RoundedRectangle(cornerRadius: 24))
                                    .transition(.opacity)
                            }
                        }
                        .shadow(color: Color.brandPrimary.opacity(0.4), radius: 30)
                        
                        // Instruction steps
                        VStack(spacing: 12) {
                            ForEach(instructions.indices, id: \.self) { i in
                                let done = completedInstructions.contains(i)
                                let active = currentInstruction == i && !isVerified
                                
                                HStack(spacing: 12) {
                                    ZStack {
                                        Circle()
                                            .fill(done ? Color.green : (active ? Color.brandPrimary : Color.white.opacity(0.1)))
                                            .frame(width: 36, height: 36)
                                        
                                        if done {
                                            Image(systemName: "checkmark")
                                                .font(.caption.weight(.bold))
                                                .foregroundStyle(.white)
                                        } else {
                                            Image(systemName: instructions[i].icon)
                                                .font(.caption.weight(.semibold))
                                                .foregroundStyle(active ? .white : .white.opacity(0.4))
                                        }
                                    }
                                    
                                    Text(instructions[i].text)
                                        .font(.subheadline.weight(active ? .semibold : .regular))
                                        .foregroundStyle(done ? .green : (active ? .white : .white.opacity(0.4)))
                                    
                                    Spacer()
                                }
                                .padding(.horizontal, 24)
                                .animation(.easeInOut(duration: 0.3), value: currentInstruction)
                                .animation(.easeInOut(duration: 0.3), value: completedInstructions)
                            }
                        }
                    }
                }
                
                Spacer()
                
                // CTA
                if !isVerified {
                    JourneyCTAButton(
                        title: isCapturing ? "Capturing…" : "Capture Live Photo",
                        isDisabled: isCapturing || showPermissionDenied || !session.isRunning
                    ) {
                        captureCurrentStep()
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                } else {
                    JourneyCTAButton(title: "Verification Complete ✓") {
                        router.push(.journeyComplete)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            Task {
                let granted = await session.requestPermission()
                await MainActor.run {
                    if !granted { showPermissionDenied = true }
                }
            }
        }
        .onDisappear {
            session.stop()
        }
    }
    
    // MARK: Real capture per instruction step, driven by AVCapturePhotoOutput
    
    private func captureCurrentStep() {
        guard currentInstruction < instructions.count, !isCapturing else { return }
        isCapturing = true
        
        session.capturePhoto { image in
            Task { @MainActor in
                if let image {
                    capturedFrame = image
                }
                
                withAnimation { isCaptured = true }
                
                try? await Task.sleep(nanoseconds: 250_000_000)
                withAnimation { isCaptured = false }
                completedInstructions.insert(currentInstruction)
                
                try? await Task.sleep(nanoseconds: 400_000_000)
                
                if currentInstruction < instructions.count - 1 {
                    withAnimation { currentInstruction += 1 }
                } else {
                    withAnimation { isVerified = true }
                }
                
                isCapturing = false
            }
        }
    }
}

// MARK: - Liveness Instruction Model

struct LivenessInstruction {
    let icon: String
    let text: String
    let color: Color
}

// MARK: - Camera Session

@MainActor
final class LivenessCameraSession: NSObject, ObservableObject {
    
    let captureSession = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()
    private var isSetup = false
    
    @Published var isRunning = false
    
    private var photoCompletion: ((UIImage?) -> Void)?
    
    func requestPermission() async -> Bool {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            await setupCamera()
            return true
        case .notDetermined:
            let granted = await AVCaptureDevice.requestAccess(for: .video)
            if granted { await setupCamera() }
            return granted
        default:
            return false
        }
    }
    
    private func setupCamera() async {
        guard !isSetup else { return }
        isSetup = true
        
        captureSession.beginConfiguration()
        captureSession.sessionPreset = .photo
        
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
              let input = try? AVCaptureDeviceInput(device: device) else {
            captureSession.commitConfiguration()
            return
        }
        
        if captureSession.canAddInput(input) {
            captureSession.addInput(input)
        }
        
        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
        }
        
        // Mirror the front camera output so a captured selfie isn't flipped
        // relative to what the user sees in the preview.
        if let connection = photoOutput.connection(with: .video) {
            if connection.isVideoMirroringSupported {
                connection.automaticallyAdjustsVideoMirroring = false
                connection.isVideoMirrored = true
            }
        }
        
        captureSession.commitConfiguration()
        
        await Task.detached(priority: .userInitiated) { [captureSession] in
            captureSession.startRunning()
        }.value
        
        isRunning = captureSession.isRunning
    }
    
    func stop() {
        guard captureSession.isRunning else { return }
        Task.detached(priority: .userInitiated) { [captureSession] in
            captureSession.stopRunning()
        }
        isRunning = false
    }
    
    /// Captures a single still photo from the live session. Calls back on the main actor
    /// with the resulting UIImage, or nil if capture failed.
    func capturePhoto(completion: @escaping (UIImage?) -> Void) {
        guard isRunning else {
            completion(nil)
            return
        }
        
        photoCompletion = completion
        
        let settings = AVCapturePhotoSettings()
        settings.flashMode = .off
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
}

// MARK: - AVCapturePhotoCaptureDelegate

extension LivenessCameraSession: AVCapturePhotoCaptureDelegate {
    
    nonisolated func photoOutput(
        _ output: AVCapturePhotoOutput,
        didFinishProcessingPhoto photo: AVCapturePhoto,
        error: Error?
    ) {
        let image: UIImage?
        if let error {
            print("Liveness capture failed: \(error.localizedDescription)")
            image = nil
        } else if let data = photo.fileDataRepresentation() {
            image = UIImage(data: data)
        } else {
            image = nil
        }
        
        Task { @MainActor in
            self.photoCompletion?(image)
            self.photoCompletion = nil
        }
    }
}

// MARK: - Live Camera Preview

import UIKit

struct LiveCameraPreview: UIViewRepresentable {
    
    let session: AVCaptureSession
    
    func makeUIView(context: Context) -> PreviewContainerView {
        let view = PreviewContainerView()
        view.previewLayer.session = session
        view.previewLayer.videoGravity = .resizeAspectFill
        view.previewLayer.connection?.automaticallyAdjustsVideoMirroring = false
        view.previewLayer.connection?.isVideoMirrored = true
        return view
    }
    
    func updateUIView(_ uiView: PreviewContainerView, context: Context) {
        uiView.previewLayer.session = session
    }
    
    /// A UIView subclass that keeps its AVCaptureVideoPreviewLayer sized to its
    /// own bounds via layoutSubviews, instead of a stale, hardcoded CGRect.
    final class PreviewContainerView: UIView {
        let previewLayer = AVCaptureVideoPreviewLayer()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            layer.addSublayer(previewLayer)
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            layer.addSublayer(previewLayer)
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            previewLayer.frame = bounds
        }
    }
}

// MARK: - Permission Denied

struct PermissionDeniedView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "camera.fill.badge.ellipsis")
                .font(.system(size: 48))
                .foregroundStyle(.white.opacity(0.4))
            
            Text("Camera Access Required")
                .font(.headline)
                .foregroundStyle(.white)
            
            Text("Please enable camera access in Settings to complete identity verification.")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.5))
                .multilineTextAlignment(.center)
            
            Button("Open Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            .foregroundStyle(Color.brandPrimary)
        }
        .padding(32)
    }
}

// MARK: - Journey Complete View

struct JourneyCompleteView: View {
    
    @Environment(AppRouter.self) private var router
    
    @State private var appeared = false
    
    var body: some View {
        ZStack {
            Color.backgroundPrimary.ignoresSafeArea()
            Color.purpleGlow.ignoresSafeArea()
            
            VStack(spacing: 32) {
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(Color.brandPrimary.opacity(0.15))
                        .frame(width: 160, height: 160)
                    
                    Circle()
                        .fill(Color.brandPrimary.opacity(0.08))
                        .frame(width: 200, height: 200)
                    
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 64))
                        .foregroundStyle(Color.primaryGradient)
                        .scaleEffect(appeared ? 1 : 0.5)
                        .opacity(appeared ? 1 : 0)
                }
                .animation(.spring(duration: 0.6, bounce: 0.4).delay(0.2), value: appeared)
                
                VStack(spacing: 12) {
                    Text("You're All Set! 🎉")
                        .font(.largeTitle.bold())
                        .foregroundStyle(.white)
                    
                    Text("Your profile is under review. We'll notify you once it's approved — usually within a few hours.")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.55))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 20)
                .animation(.easeOut(duration: 0.5).delay(0.4), value: appeared)
                
                // Highlights
                VStack(spacing: 12) {
                    CompleteCheckRow(text: "Profile created")
                    CompleteCheckRow(text: "Education & skills saved")
                    CompleteCheckRow(text: "Photos uploaded")
                    CompleteCheckRow(text: "Identity verified")
                }
                .opacity(appeared ? 1 : 0)
                .animation(.easeOut(duration: 0.5).delay(0.6), value: appeared)
                
                Spacer()
                
                JourneyCTAButton(title: "Explore Matches") {
                    router.resetToAuth()
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
                .opacity(appeared ? 1 : 0)
                .animation(.easeOut(duration: 0.4).delay(0.8), value: appeared)
            }
        }
        .preferredColorScheme(.dark)
        .navigationBarBackButtonHidden(true)
        .onAppear { appeared = true }
    }
}

struct CompleteCheckRow: View {
    let text: String
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)
            Text(text)
                .foregroundStyle(.white.opacity(0.8))
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

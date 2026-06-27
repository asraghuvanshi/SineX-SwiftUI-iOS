//
//  JourneyPhotoCaptureView.swift
//  SineX-SwiftUI-iOS
//
//  Created by iOS Developer on 27/06/26.
//


import SwiftUI
import PhotosUI

struct JourneyPhotoCaptureView: View {

    @Environment(AppRouter.self) private var router

    // Up to 6 profile photos; first slot is "primary"
    @State private var photos: [UIImage?] = Array(repeating: nil, count: 6)
    @State private var selectedPhotoIndex: Int? = nil
    @State private var photoPickerItem: PhotosPickerItem? = nil
    @State private var showingSourcePicker = false
    @State private var showingCamera = false
    @State private var showingPhotoPicker = false

    var primaryPhoto: UIImage? { photos[0] }
    var filledCount: Int { photos.filter { $0 != nil }.count }
    var isValid: Bool { primaryPhoto != nil }

    let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

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
                            index: 4, total: 5,
                            title: "Add Your Photos",
                            subtitle: "First photo is your profile picture. Add up to 6."
                        ),
                        onBack: { router.pop() }
                    )
                    .padding(.top, 16)

                    // Photo Grid
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(0..<6, id: \.self) { index in
                            PhotoSlot(
                                image: photos[index],
                                isPrimary: index == 0,
                                onTap: {
                                    selectedPhotoIndex = index
                                    showingSourcePicker = true
                                },
                                onRemove: {
                                    withAnimation { photos[index] = nil }
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 24)

                    // Tip
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "lightbulb.fill")
                            .foregroundStyle(.yellow)
                            .font(.caption)
                            .padding(.top, 2)

                        Text("Photos with your face clearly visible get 3× more matches. Avoid group photos as your first picture.")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.5))
                    }
                    .padding(.horizontal, 24)

                    // Photo count indicator
                    HStack(spacing: 6) {
                        ForEach(0..<6, id: \.self) { i in
                            Circle()
                                .fill(i < filledCount ? Color.brandPrimary : Color.white.opacity(0.2))
                                .frame(width: 6, height: 6)
                        }
                    }

                    JourneyCTAButton(
                        title: "Continue",
                        isDisabled: !isValid
                    ) {
                        router.push(.journeyLivenessVerification)
                    }
                    .padding(.horizontal, 24)

                    Spacer(minLength: 32)
                }
            }
        }
        .preferredColorScheme(.dark)
        // Source picker: camera vs library
        .confirmationDialog("Choose Photo Source", isPresented: $showingSourcePicker) {
            Button("Take Photo") {
                showingCamera = true
            }
            Button("Choose from Library") {
                showingPhotoPicker = true
            }
            if let idx = selectedPhotoIndex, photos[idx] != nil {
                Button("Remove Photo", role: .destructive) {
                    photos[idx] = nil
                }
            }
            Button("Cancel", role: .cancel) {}
        }
        .sheet(isPresented: $showingCamera) {
            CameraPickerView { image in
                if let idx = selectedPhotoIndex {
                    photos[idx] = image
                }
            }
        }
        .photosPicker(
            isPresented: $showingPhotoPicker,
            selection: $photoPickerItem,
            matching: .images
        )
        .onChange(of: photoPickerItem) { _, item in
            Task {
                if let data = try? await item?.loadTransferable(type: Data.self),
                   let image = UIImage(data: data),
                   let idx = selectedPhotoIndex {
                    await MainActor.run { photos[idx] = image }
                }
            }
        }
    }
}

// MARK: - Photo Slot

struct PhotoSlot: View {

    let image: UIImage?
    let isPrimary: Bool
    let onTap: () -> Void
    let onRemove: () -> Void

    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Slot background
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.06))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(
                            isPrimary ? Color.brandPrimary.opacity(0.6) : Color.white.opacity(0.12),
                            lineWidth: isPrimary ? 1.5 : 1
                        )
                )
                .aspectRatio(3/4, contentMode: .fit)

            // Photo or placeholder
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .aspectRatio(3/4, contentMode: .fit)

                // Remove button
                Button(action: onRemove) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(.white, .black.opacity(0.7))
                }
                .padding(6)

            } else {
                VStack(spacing: 8) {
                    Image(systemName: isPrimary ? "person.crop.rectangle.badge.plus" : "plus.circle")
                        .font(.system(size: isPrimary ? 28 : 22))
                        .foregroundStyle(isPrimary ? Color.brandPrimary : .white.opacity(0.3))

                    if isPrimary {
                        Text("Main Photo")
                            .font(.caption2.weight(.semibold))
                            .foregroundStyle(Color.brandPrimary.opacity(0.8))
                    }
                }
            }
        }
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)
        .animation(.spring(duration: 0.3), value: image != nil)
    }
}


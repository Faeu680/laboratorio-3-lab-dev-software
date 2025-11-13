//
//  NewBenefitScreenViewModel.swift
//  Meritus
//
//  Created by Arthur Porto on 10/11/25.
//

import SwiftUI
import Combine
import Photos
import AVFoundation
import Domain

final class NewBenefitScreenViewModel: ObservableObject {
    
    private let presignedUrlUseCase: PresignedURLUseCaseProtocol
    
    @Published var name: String = ""
    @Published var description: String = ""
    @Published var cost: String = ""
    @Published var selectedImage: UIImage? {
        didSet {
            shouldShowCreateBenefitButton = selectedImage != nil
        }
    }
    
    @Published var isCameraPresented = false
    @Published var isPhotoLibraryPresented = false
    @Published var shouldShowCreateBenefitButton: Bool = false
    @Published var shouldShowPermissionsAlert = false
    
    init(presignedUrlUseCase: PresignedURLUseCaseProtocol) {
        self.presignedUrlUseCase = presignedUrlUseCase
    }
    
    func didTapAddPhoto() async {
        let hasPhotoLibrary = await checkPhotoLibraryPermission()
        shouldShowPermissionsAlert = !hasPhotoLibrary
        isPhotoLibraryPresented = hasPhotoLibrary
    }
    
    func didTapTakePhoto() async {
        let hasCamera = await checkCameraPermission()
        shouldShowPermissionsAlert = !hasCamera
        isCameraPresented = hasCamera
    }
    
    func didTapCreateBenefit() async {
//        let model = CreateBenefitModel(
//            name: name,
//            description: description,
//            photo: "",
//            cost: 10.0
//        )
//        
//        try? await createBenefitUseCase.execute(model)
    }
    
    private func getPresignedUrl() async {
        guard let selectedImage,
              let data = selectedImage.jpegData(compressionQuality: 0.9) else {
            // TODO: Compress errror sheet
            return
        }
        
        let fileName = "benefit-\(UUID().uuidString).jpg"
        let mimeType = "image/jpeg"
        
        do {
            try await presignedUrlUseCase.execute(
                originalName: fileName,
                mimeType: mimeType
            )
        } catch {
            
        }
    }
    
    private func checkCameraPermission() async -> Bool {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .authorized:
            return true
        case .notDetermined:
            return await withCheckedContinuation { continuation in
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    continuation.resume(returning: granted)
                }
            }
            
        case .denied, .restricted:
            return false
        @unknown default:
            return false
        }
    }
    
    private func checkPhotoLibraryPermission() async -> Bool {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        
        switch status {
        case .authorized, .limited:
            return true
        case .notDetermined:
            let newStatus = await withCheckedContinuation { continuation in
                PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
                    continuation.resume(returning: newStatus)
                }
            }
            return newStatus == .authorized || newStatus == .limited
        case .denied, .restricted:
            return false
        @unknown default:
            return false
        }
    }
}

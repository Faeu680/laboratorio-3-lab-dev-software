//
//  NewBenefitScreenViewModel.swift
//  Meritus
//
//  Created by Arthur Porto on 10/11/25.
//

import Foundation
import SwiftUI
import Combine
import Photos
import AVFoundation
import Domain

final class NewBenefitScreenViewModel: ObservableObject {
    
    // MARK: - Private Properties
    
    private let getPresignedUrlUseCase: GetPresignedURLUseCaseProtocol
    private let uploadImageWithPresignedUrlUseCase: UploadImageWithPresignedURLUseCaseProtocol
    private let createBenefitUseCase: CreateBenefitUseCaseProtocol
    
    // MARK: - Public Properties
    
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
    
    // MARK: - Init
    
    init(
        getPresignedUrlUseCase: GetPresignedURLUseCaseProtocol,
        uploadImageWithPresignedUrlUseCase: UploadImageWithPresignedURLUseCaseProtocol,
        createBenefitUseCase: CreateBenefitUseCaseProtocol
    ) {
        self.getPresignedUrlUseCase = getPresignedUrlUseCase
        self.uploadImageWithPresignedUrlUseCase = uploadImageWithPresignedUrlUseCase
        self.createBenefitUseCase = createBenefitUseCase
    }
    
    // MARK: - Public Methods
    
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
    
    // TODO: Olhar esses metodos encadeados
    
    func didTapCreateBenefit() async {
        await getPresignedUrl()
    }
    
    // MARK: - Private Methods
    
    private func getPresignedUrl() async {
        guard let selectedImage,
              let data = selectedImage.jpegData(compressionQuality: 0.9) else {
            // TODO: Compress errror sheet
            return
        }
        
        let fileName = "benefit-image\(UUID().uuidString).jpg"
        let mimeType = "image/jpeg"
        
        do {
            let result = try await getPresignedUrlUseCase.execute(
                originalName: fileName,
                mimeType: mimeType
            )
            
            let path = result.path
            let presignedUrl = result.presignedUrl
            
            await uploadImage(with: presignedUrl, for: data, in: path)
        } catch {
            // TODO: Mostar erro
        }
    }
    
    private func uploadImage(
        with url: URL,
        for data: Data,
        in path: String
    ) async {
        do {
            try await uploadImageWithPresignedUrlUseCase.execute(
                with: url,
                for: data
            )
            
            await createBenefit(for: path)
        } catch {
            // TODO: Mostar erro
        }
    }
    
    private func createBenefit(for path: String) async {
        let model = CreateBenefitModel(
            name: name,
            description: description,
            photo: path,
            cost: 10.0
        )
        
        do {
            try await createBenefitUseCase.execute(model)
        } catch {
            // TODO: Mostar erro
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

//
//  NewBenefitScreenView.swift
//  Meritus
//
//  Created by Arthur Porto on 10/11/25.
//

import SwiftUI
import Obsidian

struct NewBenefitScreenView: View {
    
    @StateObject private var viewModel: NewBenefitScreenViewModel
    
    private var cardImage: Image {
        guard let image = viewModel.selectedImage else {
            return Image(systemName: "photo")
        }
        return Image(uiImage: image)
    }
    
    init(viewModel: NewBenefitScreenViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: .size16) {
                    benefitCardView()
                    
                    nameInputView()
                    
                    descriptionInputView()
                    
                    costInputView()
                }
                .padding(.top, .size16)
            }
            .scrollIndicators(.never)
            .toolbarTitleDisplayMode(.inlineLarge)
            .navigationTitle("Novo Beneficio")
            
            if viewModel.shouldShowCreateBenefitButton {
                HStack {
                    createBenefitButtonView()
                    
                    removePhotoButtonView()
                }
                .padding(.horizontal, .size16)
            } else {
                HStack {
                    addPhotoButtonView()
                    
                    takePhotoButtonView()
                }
                .padding(.horizontal, .size16)
            }
            
            
        }
        .fullScreenCover(isPresented: $viewModel.isCameraPresented) {
            CameraPicker { selectedImage in
                viewModel.selectedImage = selectedImage
            }
            .ignoresSafeArea()
        }
        .fullScreenCover(isPresented: $viewModel.isPhotoLibraryPresented) {
            PhotoLibraryPicker { selectedImage in
                viewModel.selectedImage = selectedImage
            }
            .ignoresSafeArea()
        }
    }
}

extension NewBenefitScreenView {
    private func nameInputView() -> some View {
        ObsidianInput(
            text: $viewModel.name,
            label: "Nome",
            placeholder: "Nome",
            keyboardType: .emailAddress
        )
        .padding(.horizontal, .size16)
    }
}

extension NewBenefitScreenView {
    private func descriptionInputView() -> some View {
        ObsidianInput(
            text: $viewModel.description,
            label: "Descrição",
            placeholder: "Descrição",
            keyboardType: .emailAddress
        )
        .padding(.horizontal, .size16)
    }
}

extension NewBenefitScreenView {
    private func costInputView() -> some View {
        ObsidianInput(
            text: $viewModel.cost,
            label: "Preço",
            placeholder: "Preço",
            keyboardType: .emailAddress
        )
        .padding(.horizontal, .size16)
    }
}

extension NewBenefitScreenView {
    private func benefitCardView() -> some View {
        BenefitCard(
            title: viewModel.name,
            description: viewModel.description,
            price: viewModel.cost,
            image: cardImage
        )
        .padding(.horizontal, .size16)
    }
}

extension NewBenefitScreenView {
    private func addPhotoButtonView() -> some View {
        ObsidianButton(
            "Adicionar Foto",
            style: .primary,
        ) {
            Task {
                await viewModel.didTapAddPhoto()
            }
        }
    }
}

extension NewBenefitScreenView {
    private func takePhotoButtonView() -> some View {
        ObsidianButton(
            "Tirar Foto",
            style: .secondary,
        ) {
            Task {
                await viewModel.didTapTakePhoto()
            }
        }
    }
}

extension NewBenefitScreenView {
    private func createBenefitButtonView() -> some View {
        ObsidianButton(
            "Criar Beneficio",
            style: .primary,
        ) {
            Task {
                await viewModel.didTapCreateBenefit()
            }
        }
    }
}

extension NewBenefitScreenView {
    private func removePhotoButtonView() -> some View {
        ObsidianButton(
            "Remover Foto",
            style: .secondary,
        ) {
            viewModel.selectedImage = nil
        }
    }
}

extension NewBenefitScreenView {
    private struct CameraPicker: UIViewControllerRepresentable {
        @Environment(\.dismiss) private var dismiss
        var onImagePicked: (UIImage) -> Void

        func makeUIViewController(context: Context) -> UIImagePickerController {
            let picker = UIImagePickerController()
            picker.delegate = context.coordinator
            picker.sourceType = .camera
            picker.allowsEditing = false
            return picker
        }

        func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }

        final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
            let parent: CameraPicker
            init(_ parent: CameraPicker) {
                self.parent = parent
            }

            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                if let image = info[.originalImage] as? UIImage {
                    parent.onImagePicked(image)
                }
                parent.dismiss()
            }

            func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
                parent.dismiss()
            }
        }
    }
}

extension NewBenefitScreenView {
    private struct PhotoLibraryPicker: UIViewControllerRepresentable {
        @Environment(\.dismiss) private var dismiss
        var onImagePicked: (UIImage) -> Void

        func makeUIViewController(context: Context) -> UIImagePickerController {
            let picker = UIImagePickerController()
            picker.delegate = context.coordinator
            picker.sourceType = .photoLibrary
            picker.allowsEditing = false
            return picker
        }

        func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }

        final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
            let parent: PhotoLibraryPicker
            init(_ parent: PhotoLibraryPicker) {
                self.parent = parent
            }

            func imagePickerController(
                _ picker: UIImagePickerController,
                didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
            ) {
                if let image = info[.originalImage] as? UIImage {
                    parent.onImagePicked(image)
                }
                parent.dismiss()
            }

            func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
                parent.dismiss()
            }
        }
    }
}

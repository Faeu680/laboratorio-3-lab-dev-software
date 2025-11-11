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
    
    init(viewModel: NewBenefitScreenViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: .size16) {
                    nameInputView()
                    
                    descriptionInputView()
                    
                    costInputView()
                    
                    benefitCardView()
                }
                .padding(.top, .size16)
            }
            .scrollIndicators(.never)
            .toolbarTitleDisplayMode(.inlineLarge)
            .navigationTitle("Novo Beneficio")
            
            createBenefitButtonView()
        }
        .fullScreenCover(isPresented: $viewModel.isCameraPresented) {
            cameraScreenView()
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
            price: 850,
            image: Image("mock-porto-faria")
        )
        .padding(.horizontal, .size16)
    }
}

extension NewBenefitScreenView {
    private func createBenefitButtonView() -> some View {
        ObsidianButton(
            "Adicionar Foto",
            style: .primary,
        ) {
            viewModel.isCameraPresented.toggle()
        }
        .padding(.horizontal, .size16)
    }
}

extension NewBenefitScreenView {
    private func cameraScreenView() -> some View {
        CameraPicker { _ in }
            .ignoresSafeArea()
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

#Preview {
    ObsidianPreviewContainer {
        NewBenefitScreenView(viewModel: .init())
    }
}

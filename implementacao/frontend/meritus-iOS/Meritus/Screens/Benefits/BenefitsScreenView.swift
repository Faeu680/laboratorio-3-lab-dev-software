//
//  BenefitsScreenView.swift
//  Meritus
//
//  Created by Arthur Porto on 03/11/25.
//

import SwiftUI
import PhotosUI
import Obsidian

struct BenefitsScreenView: View {
    
    @StateObject private var viewModel: BenefitsScreenViewModel

    init(viewModel: BenefitsScreenViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView {
            ForEach(0..<10, id: \.self) { index in
                benefitCardView()
            }
        }
        .scrollIndicators(.never)
        .applyMeritusToolbarTitle()
        .sheet(isPresented: $viewModel.showCreateBenefit) {
            createBenefitSheetView()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.showCreateBenefit.toggle()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

extension BenefitsScreenView {
    private func benefitCardView() -> some View {
        BenefitCard(
            title: "Spa Premium Experience",
            description: "Dia completo de relaxamento em spa 5 estrelas com massagem e tratamento facial. Inclui acesso à sauna e piscina aquecida.",
            price: 850,
            image: Image("spa_header")
        )
        .padding(.horizontal, .size16)
    }
}

extension BenefitsScreenView {
    private func createBenefitSheetView() -> some View {
        NavigationStack {
            VStack {
                nameInputView()
                
                descriptionInputView()
                
                costInputView()
                
                createBenefitButtonView()
            }
            .padding(.horizontal, .size16)
            .presentationDetents([.medium, .medium])
            .navigationTitle("Novo Beneficio")
        }
    }
}

extension BenefitsScreenView {
    private func nameInputView() -> some View {
        ObsidianInput(
            text: $viewModel.name,
            label: "Nome",
            placeholder: "Nome",
            keyboardType: .emailAddress
        )
    }
}

extension BenefitsScreenView {
    private func descriptionInputView() -> some View {
        ObsidianInput(
            text: $viewModel.description,
            label: "Descrição",
            placeholder: "Descrição",
            keyboardType: .emailAddress
        )
    }
}

extension BenefitsScreenView {
    private func costInputView() -> some View {
        ObsidianInput(
            text: $viewModel.cost,
            label: "Preço",
            placeholder: "Preço",
            keyboardType: .emailAddress
        )
    }
}

extension BenefitsScreenView {
    private func createBenefitButtonView() -> some View {
        ObsidianButton(
            "Criar",
            style: .primary,
        ) {
            Task {
                await viewModel.didTapCreateBenefit()
            }
        }
    }
}


struct CameraPicker: UIViewControllerRepresentable {
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

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
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

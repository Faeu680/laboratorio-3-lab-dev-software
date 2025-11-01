//
//  SignUpScreenViewModel.swift
//  Meritus
//
//  Created by Arthur Porto on 01/11/25.
//

import Combine
import SwiftUI

enum SignUpType {
    case student
    case business
    
    enum FieldKey: Hashable {
        case name
        case email
        case password
        case cpf
        case rg
        case address
        case course
        case institutionId
        case cnpj
        case description
    }
    
    var fieldKeys: [FieldKey] {
        switch self {
        case .student:
            return [.name, .email, .password, .cpf, .rg, .address, .course, .institutionId]
        case .business:
            return [.name, .email, .password, .cnpj, .address, .description]
        }
    }
}

@MainActor
extension SignUpType.FieldKey {
    var label: LocalizedStringKey {
        switch self {
        case .name:
            return LocalizableKey.SignUpScreen.nameLabel
        case .email:
            return LocalizableKey.SignUpScreen.emailLabel
        case .password:
            return LocalizableKey.SignUpScreen.passwordLabel
        case .cpf:
            return LocalizableKey.SignUpScreen.cpfLabel
        case .rg:
            return LocalizableKey.SignUpScreen.rgLabel
        case .address:
            return LocalizableKey.SignUpScreen.addressLabel
        case .course:
            return LocalizableKey.SignUpScreen.courseLabel
        case .institutionId:
            return LocalizableKey.SignUpScreen.institutionIdLabel
        case .cnpj:
            return LocalizableKey.SignUpScreen.cnpjLabel
        case .description:
            return LocalizableKey.SignUpScreen.descriptionLabel
        }
    }
    
    var placeholder: LocalizedStringKey {
        switch self {
        case .name:
            return LocalizableKey.SignUpScreen.namePlaceholder
        case .email:
            return LocalizableKey.SignUpScreen.emailPlaceholder
        case .password:
            return LocalizableKey.SignUpScreen.passwordPlaceholder
        case .cpf:
            return LocalizableKey.SignUpScreen.cpfPlaceholder
        case .rg:
            return LocalizableKey.SignUpScreen.rgPlaceholder
        case .address:
            return LocalizableKey.SignUpScreen.addressPlaceholder
        case .course:
            return LocalizableKey.SignUpScreen.coursePlaceholder
        case .institutionId:
            return LocalizableKey.SignUpScreen.institutionIdPlaceholder
        case .cnpj:
            return LocalizableKey.SignUpScreen.cnpjPlaceholder
        case .description:
            return LocalizableKey.SignUpScreen.descriptionPlaceholder
        }
    }
    
    var keyboard: UIKeyboardType {
        switch self {
        case .email: return .emailAddress
        case .cpf, .cnpj: return .numberPad
        default: return .default
        }
    }
}
@MainActor
final class SignUpScreenViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    
    @Published private(set) var signUpType: SignUpType = .student
    @Published private(set) var isCurrentFormComplete: Bool = false
    @Published var fields: [SignUpType.FieldKey: String] = [:]
    
    init() {
        setupObservers()
    }
    
    func binding(_ key: SignUpType.FieldKey) -> Binding<String> {
        Binding(
            get: { self.fields[key, default: ""] },
            set: { self.fields[key] = $0 }
        )
    }
    
    func didTapStudent() {
        signUpType = .student
    }
    
    func didTapBusiness() {
        signUpType = .business
    }
    
    private func setupObservers() {
        Publishers.CombineLatest($fields, $signUpType)
            .map { fields, type in
                let required = type.fieldKeys
                return required.allSatisfy { key in
                    let value = fields[key]?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                    return !value.isEmpty
                }
            }
            .removeDuplicates()
            .sink { [weak self] isComplete in
                self?.isCurrentFormComplete = isComplete
            }
            .store(in: &cancellables)
    }
}

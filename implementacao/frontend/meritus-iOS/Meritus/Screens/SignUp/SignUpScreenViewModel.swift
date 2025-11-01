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

extension SignUpType.FieldKey {
    var label: String {
        switch self {
        case .name:          return "NOME"
        case .email:         return "EMAIL"
        case .password:      return "SENHA"
        case .cpf:           return "CPF"
        case .rg:            return "RG"
        case .address:       return "ENDEREÇO"
        case .course:        return "CURSO"
        case .institutionId: return "ID DA INSTITUIÇÃO"
        case .cnpj:          return "CNPJ"
        case .description:   return "DESCRIÇÃO"
        }
    }
    
    var placeholder: String {
        switch self {
        case .name:          return "Seu nome"
        case .email:         return "seu@email.com"
        case .password:      return "Crie uma senha"
        case .cpf:           return "000.000.000-00"
        case .rg:            return "Seu RG"
        case .address:       return "Rua, nº, bairro"
        case .course:        return "Seu curso"
        case .institutionId: return "Código/ID da instituição"
        case .cnpj:          return "00.000.000/0001-00"
        case .description:   return "Breve descrição"
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

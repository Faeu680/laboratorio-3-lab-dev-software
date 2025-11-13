//
//  LocalizableKey.swift
//  Meritus
//
//  Created by Arthur Porto on 01/11/25.
//

import SwiftUI

enum LocalizableKey {
    
    // MARK: - Sign Up Screen
    
    @MainActor
    enum SignUpScreen {
        static let nameLabel: LocalizedStringKey = "signup.field.name.label"
        static let namePlaceholder: LocalizedStringKey = "signup.field.name.placeholder"
        
        static let emailLabel: LocalizedStringKey = "signup.field.email.label"
        static let emailPlaceholder: LocalizedStringKey = "signup.field.email.placeholder"
        
        static let passwordLabel: LocalizedStringKey = "signup.field.password.label"
        static let passwordPlaceholder: LocalizedStringKey = "signup.field.password.placeholder"
        
        static let cpfLabel: LocalizedStringKey = "signup.field.cpf.label"
        static let cpfPlaceholder: LocalizedStringKey = "signup.field.cpf.placeholder"
        
        static let rgLabel: LocalizedStringKey = "signup.field.rg.label"
        static let rgPlaceholder: LocalizedStringKey = "signup.field.rg.placeholder"
        
        static let addressLabel: LocalizedStringKey = "signup.field.address.label"
        static let addressPlaceholder: LocalizedStringKey = "signup.field.address.placeholder"
        
        static let courseLabel: LocalizedStringKey = "signup.field.course.label"
        static let coursePlaceholder: LocalizedStringKey = "signup.field.course.placeholder"
        
        static let institutionIdLabel: LocalizedStringKey = "signup.field.institutionId.label"
        static let institutionIdPlaceholder: LocalizedStringKey = "signup.field.institutionId.placeholder"
        
        static let cnpjLabel: LocalizedStringKey = "signup.field.cnpj.label"
        static let cnpjPlaceholder: LocalizedStringKey = "signup.field.cnpj.placeholder"
        
        static let descriptionLabel: LocalizedStringKey = "signup.field.description.label"
        static let descriptionPlaceholder: LocalizedStringKey = "signup.field.description.placeholder"
    }
    
    // MARK: - Login Screen
    
    @MainActor
    enum LoginScreen {
        static let headerLabel: LocalizedStringKey = "login.header.label"
        
        static let emailLabel: LocalizedStringKey = "login.field.email.label"
        static let emailPlaceholder: LocalizedStringKey = "login.field.email.placeholder"
        
        static let passwordLabel: LocalizedStringKey = "login.field.password.label"
        static let passwordPlaceholder: LocalizedStringKey = "login.field.password.placeholder"
        
        static let loginButtonLabel: LocalizedStringKey = "login.button.login.label"
        static let signingInButtonLabel: LocalizedStringKey = "login.button.signingin.label"
        
        static let footerLabel: LocalizedStringKey = "login.footer.label"
    }
}

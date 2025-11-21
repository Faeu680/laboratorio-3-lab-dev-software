//
//  AppRouteFactory.swift
//  Meritus
//
//  Created by Arthur Porto on 17/10/25.
//

import DependencyInjection
import Session
import Domain

@MainActor
final class AppRouteFactory: AppRouteFactoryProtocol {
    
    private nonisolated(unsafe) let resolver: Resolver
    
    nonisolated init(resolver: Resolver) {
        self.resolver = resolver
    }
    
    func makeLogin(action: LoginScreenViewAction) -> LoginScreenView {
        let signInUseCase = resolver.resolveUnwrapping(SignInUseCaseProtocol.self)
        let session = resolver.resolveUnwrapping(SessionProtocol.self)
        let viewModel = LoginScreenViewModel(action: action, session: session, signInUseCase: signInUseCase)
        return LoginScreenView(viewModel: viewModel)
    }
    
    func makeSignUp() -> SignUpScreenView {
        let studentSignUpUseCase = resolver.resolveUnwrapping(SignUpStudentUseCaseProtocol.self)
        let companySignUpUseCase = resolver.resolveUnwrapping(SignUpCompanyUseCaseProtocol.self)
        let viewModel = SignUpScreenViewModel(
            studentSignUpUseCase: studentSignUpUseCase,
            companySignUpUseCase: companySignUpUseCase
        )
        return SignUpScreenView(viewModel: viewModel)
    }
    
    func makeHome() -> HomeScreenView {
        let session = resolver.resolveUnwrapping(SessionProtocol.self)
        let viewModel = HomeScreenViewModel(session: session)
        return HomeScreenView(viewModel: viewModel)
    }
    
    func makeExtract() -> ExtractScreenView {
        let getTransactionsUseCase = resolver.resolveUnwrapping(GetTransactionsUseCaseProtocol.self)
        let viewModel = ExtractScreenViewModel(getTransactionsUseCase: getTransactionsUseCase)
        return ExtractScreenView(viewModel: viewModel)
    }
    
    func makeBenefits() -> BenefitsScreenView {
        let createBenefitUseCase = resolver.resolveUnwrapping(CreateBenefitUseCaseProtocol.self)
        let viewModel = BenefitsScreenViewModel(createBenefitUseCase: createBenefitUseCase)
        return BenefitsScreenView(viewModel: viewModel)
    }
    
    func makeNewBenefit() -> NewBenefitScreenView {
        let getPresignedUrlUseCase = resolver.resolveUnwrapping(GetPresignedURLUseCaseProtocol.self)
        let uploadImageWithPresignedURLUseCase = resolver.resolveUnwrapping(UploadImageWithPresignedURLUseCaseProtocol.self)
        let createBenefitUseCase = resolver.resolveUnwrapping(CreateBenefitUseCaseProtocol.self)
        let viewModel = NewBenefitScreenViewModel(
            getPresignedUrlUseCase: getPresignedUrlUseCase,
            uploadImageWithPresignedUrlUseCase: uploadImageWithPresignedURLUseCase,
            createBenefitUseCase: createBenefitUseCase
        )
        return NewBenefitScreenView(viewModel: viewModel)
    }
    
    func makeRedeem() -> RedeemScreenView {
        let getBenefitsUseCase = resolver.resolveUnwrapping(GetBenefitsUseCaseProtocol.self)
        let viewModel = RedeemScreenViewModel(getBenefitsUseCase: getBenefitsUseCase)
        return RedeemScreenView(viewModel: viewModel)
    }
    
    func makeSettings() -> SettingsScreenView {
        let session = resolver.resolveUnwrapping(SessionProtocol.self)
        let viewModel = SettingsScreenViewModel(session: session)
        return SettingsScreenView(viewModel: viewModel)
    }
    
    func makeSelectLanguage() -> ResourceSelectScreenView<LanguageSelectScreenViewModel> {
        let viewModel = LanguageSelectScreenViewModel()
        return ResourceSelectScreenView(viewModel: viewModel)
    }
    
    func makeSelectColorScheme() -> ResourceSelectScreenView<ColorSchemeSelectScreenViewModel> {
        let viewModel = ColorSchemeSelectScreenViewModel()
        return ResourceSelectScreenView(viewModel: viewModel)
    }
    
    func makeSwitchAccount() -> SwitchAccountScreenView {
        let session = resolver.resolveUnwrapping(SessionProtocol.self)
        let viewModel = SwitchAccountScreenViewModel(session: session)
        return SwitchAccountScreenView(viewModel: viewModel)
    }
}

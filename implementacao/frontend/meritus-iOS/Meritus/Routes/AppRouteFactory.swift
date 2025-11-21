//
//  AppRouteFactory.swift
//  Meritus
//
//  Created by Arthur Porto on 17/10/25.
//

import DependencyInjection
import Session
import Domain

final class AppRouteFactory: AppRouteFactoryProtocol {
    
    private nonisolated(unsafe) let resolver: Resolver
    
    init(resolver: Resolver) {
        self.resolver = resolver
    }
    
    @MainActor
    func makeLogin() -> LoginScreenView {
        let signInUseCase = resolver.resolveUnwrapping(SignInUseCaseProtocol.self)
        let viewModel = LoginScreenViewModel(signInUseCase: signInUseCase)
        return LoginScreenView(viewModel: viewModel)
    }
    
    @MainActor
    func makeSignUp() -> SignUpScreenView {
        let studentSignUpUseCase = resolver.resolveUnwrapping(SignUpStudentUseCaseProtocol.self)
        let companySignUpUseCase = resolver.resolveUnwrapping(SignUpCompanyUseCaseProtocol.self)
        let viewModel = SignUpScreenViewModel(
            studentSignUpUseCase: studentSignUpUseCase,
            companySignUpUseCase: companySignUpUseCase
        )
        return SignUpScreenView(viewModel: viewModel)
    }
    
    @MainActor
    func makeHome() -> HomeScreenView {
        let session = resolver.resolveUnwrapping(SessionProtocol.self)
        let viewModel = HomeScreenViewModel(session: session)
        let view = HomeScreenView(viewModel: viewModel)
        return view
    }
    
    @MainActor
    func makeBenefits() -> BenefitsScreenView {
        let createBenefitUseCase = resolver.resolveUnwrapping(CreateBenefitUseCaseProtocol.self)
        let viewModel = BenefitsScreenViewModel(createBenefitUseCase: createBenefitUseCase)
        return BenefitsScreenView(viewModel: viewModel)
    }
    
    @MainActor
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
    
    @MainActor
    func makeRedeem() -> RedeemScreenView {
        let getBenefitsUseCase = resolver.resolveUnwrapping(GetBenefitsUseCaseProtocol.self)
        let viewModel = RedeemScreenViewModel(getBenefitsUseCase: getBenefitsUseCase)
        return RedeemScreenView(viewModel: viewModel)
    }
    
    @MainActor
    func makeSettings() -> SettingsScreenView {
        let session = resolver.resolveUnwrapping(SessionProtocol.self)
        let viewModel = SettingsScreenViewModel(session: session)
        return SettingsScreenView(viewModel: viewModel)
    }
    
    @MainActor
    func makeSelectLanguage() -> ResourceSelectScreenView<LanguageSelectScreenViewModel> {
        let viewModel = LanguageSelectScreenViewModel()
        return ResourceSelectScreenView(viewModel: viewModel)
    }
    
    @MainActor
    func makeSelectColorScheme() -> ResourceSelectScreenView<ColorSchemeSelectScreenViewModel> {
        let viewModel = ColorSchemeSelectScreenViewModel()
        return ResourceSelectScreenView(viewModel: viewModel)
    }
    
    @MainActor
    func makeSwitchAccount() -> SwitchAccountScreenView {
        let viewModel = SwitchAccountScreenViewModel()
        return SwitchAccountScreenView(viewModel: viewModel)
    }
}

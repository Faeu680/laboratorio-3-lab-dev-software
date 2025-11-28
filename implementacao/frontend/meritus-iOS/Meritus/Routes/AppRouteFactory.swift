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
    
    func makeLogin() -> LoginScreenView {
        let signInUseCase = resolver.resolveUnwrapping(SignInUseCaseProtocol.self)
        let session = resolver.resolveUnwrapping(SessionProtocol.self)
        let biometryManager = resolver.resolveUnwrapping(BiometryManagerProtocol.self)
        let viewModel = LoginScreenViewModel(
            session: session,
            signInUseCase: signInUseCase,
            biometryManager: biometryManager
        )
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
        let getBalanceUseCase = resolver.resolveUnwrapping(GetBalanceUseCaseProtocol.self)
        let getTransactionsUseCase = resolver.resolveUnwrapping(GetTransactionsUseCaseProtocol.self)
        let viewModel = ExtractScreenViewModel(
            getBalanceUseCase: getBalanceUseCase,
            getTransactionsUseCase: getTransactionsUseCase
        )
        return ExtractScreenView(viewModel: viewModel)
    }
    
    func makeTransfer() -> TransferScreenView {
        let session = resolver.resolveUnwrapping(SessionProtocol.self)
        let getBalanceUseCase = resolver.resolveUnwrapping(GetBalanceUseCaseProtocol.self)
        let makeTransferUseCase = resolver.resolveUnwrapping(MakeTransferUseCaseProtocol.self)
        let getStudentsOfInstitutionUseCase = resolver.resolveUnwrapping(GetStudentsOfInstitutionUseCaseProtocol.self)
        let biometryManager = resolver.resolveUnwrapping(BiometryManagerProtocol.self)
        let viewModel = TransferScreenViewModel(
            session: session,
            getBalanceUseCase: getBalanceUseCase,
            makeTransferUseCase: makeTransferUseCase,
            getStudentsOfInstitutionUseCase: getStudentsOfInstitutionUseCase,
            biometryManager: biometryManager
        )
        return TransferScreenView(viewModel: viewModel)
    }
    
    func makeBenefits() -> BenefitsScreenView {
        let getBenefitsUseCase = resolver.resolveUnwrapping(GetBenefitsUseCaseProtocol.self)
        let viewModel = BenefitsScreenViewModel(getBenefitsUseCase: getBenefitsUseCase)
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

//
//  AppRouteFactory.swift
//  Meritus
//
//  Created by Arthur Porto on 17/10/25.
//

import DependencyInjection
import Session
import Domain
import Obsidian

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
        let session = resolver.resolveUnwrapping(SessionProtocol.self)
        let getBalanceUseCase = resolver.resolveUnwrapping(GetBalanceUseCaseProtocol.self)
        let getBenefitsUseCase = resolver.resolveUnwrapping(GetBenefitsUseCaseProtocol.self)
        let redeemBenefitUseCase = resolver.resolveUnwrapping(RedeemBenefitUseCaseProtocol.self)
        let viewModel = BenefitsScreenViewModel(
            session: session,
            getBalanceUseCase: getBalanceUseCase,
            getBenefitsUseCase: getBenefitsUseCase,
            redeemBenefitUseCase: redeemBenefitUseCase
        )
        return BenefitsScreenView(viewModel: viewModel)
    }
    
    func makeMyBenefits() -> MyBenefitsScreenView {
        let getMyBenefitsUseCase = resolver.resolveUnwrapping(GetMyBenefitsUseCaseProtocol.self)
        let viewModel = MyBenefitsScreenViewModel(getMyBenefitsUseCase: getMyBenefitsUseCase)
        return MyBenefitsScreenView(viewModel: viewModel)
    }
    
    func makeBenefitInfo(benefit: RedeemBenefitModel) -> BenefitInfoScreenView {
        let viewModel = BenefitInfoScreenViewModel(benefit: benefit)
        return BenefitInfoScreenView(viewModel: viewModel)
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
    
    func makeSelectColorScheme() -> ResourceSelectScreenView<ColorSchemeSelectScreenViewModel> {
        let viewModel = ColorSchemeSelectScreenViewModel()
        return ResourceSelectScreenView(viewModel: viewModel)
    }
    
    func makeSwitchAccount() -> SwitchAccountScreenView {
        let session = resolver.resolveUnwrapping(SessionProtocol.self)
        let viewModel = SwitchAccountScreenViewModel(session: session)
        return SwitchAccountScreenView(viewModel: viewModel)
    }
    
    func makeFeedback(style: ObsidianFeedbackView.Style) -> ObsidianFeedbackView {
        return ObsidianFeedbackView(style)
    }
}

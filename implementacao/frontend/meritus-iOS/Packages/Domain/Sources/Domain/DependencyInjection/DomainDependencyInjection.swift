//
//  DomainDependencyInjection.swift
//  Domain
//
//  Created by Arthur Porto on 17/10/25.
//

import Foundation
import DependencyInjection
import Commons
import Session

public struct DomainDependencyInjection: DependencyModule {
    
    // MARK: - Public Methods
    
    public static func register(in container: Container) {
        registerUseCases(in: container)
    }
    
    // MARK: - Private Methods
    
    private static func registerUseCases(in container: Container) {
        container.register(SignInUseCaseProtocol.self) { resolver in
            let service = resolver.resolveUnwrapping(AuthServiceProtocol.self)
            let session = resolver.resolveUnwrapping(SessionProtocol.self)
            return SignInUseCase(service: service, session: session)
        }
        
        container.register(BootstrapSessionUseCaseProtocol.self) { resolver in
            let session = resolver.resolveUnwrapping(SessionProtocol.self)
            return BootstrapSessionUseCase(session: session)
        }
        
        container.register(SignUpStudentUseCaseProtocol.self) { resolver in
            let service = resolver.resolveUnwrapping(StudentsServiceProtocol.self)
            let session = resolver.resolveUnwrapping(SessionProtocol.self)
            return SignUpStudentUseCase(service: service, session: session)
        }
        
        container.register(CreateBenefitUseCaseProtocol.self) { resolver in
            let service = resolver.resolveUnwrapping(BenefitsServiceProtocol.self)
            return CreateBenefitUseCase(service: service)
        }
        
        container.register(SignUpCompanyUseCaseProtocol.self) { resolver in
            let service = resolver.resolveUnwrapping(CompaniesServiceProtocol.self)
            let session = resolver.resolveUnwrapping(SessionProtocol.self)
            return SignUpCompanyUseCase(service: service, session: session)
        }
        
        container.register(GetBenefitsUseCaseProtocol.self) { resolver in
            let service = resolver.resolveUnwrapping(BenefitsServiceProtocol.self)
            return GetBenefitsUseCase(service: service)
        }
        
        container.register(GetPresignedURLUseCaseProtocol.self) { resolver in
            let service = resolver.resolveUnwrapping(UploadServiceProtocol.self)
            return GetPresignedURLUseCase(service: service)
        }
        
        container.register(UploadImageWithPresignedURLUseCaseProtocol.self) { resolver in
            let service = resolver.resolveUnwrapping(UploadServiceProtocol.self)
            return UploadImageWithPresignedURLUseCase(service: service)
        }
        
        container.register(GetTransactionsUseCaseProtocol.self) { resolver in
            let service = resolver.resolveUnwrapping(TransactionsServiceProtocol.self)
            return GetTransactionsUseCase(service: service)
        }
        
        container.register(GetStudentsOfInstitutionUseCaseProtocol.self) { resolver in
            let service = resolver.resolveUnwrapping(StudentsServiceProtocol.self)
            return GetStudentsOfInstitutionUseCase(service: service)
        }
        
        container.register(MakeTransferUseCaseProtocol.self) { resolver in
            let service = resolver.resolveUnwrapping(TransactionsServiceProtocol.self)
            return MakeTransferUseCase(service: service)
        }
        
        container.register(GetBalanceUseCaseProtocol.self) { resolver in
            let service = resolver.resolveUnwrapping(TransactionsServiceProtocol.self)
            return GetBalanceUseCase(service: service)
        }
    }
}

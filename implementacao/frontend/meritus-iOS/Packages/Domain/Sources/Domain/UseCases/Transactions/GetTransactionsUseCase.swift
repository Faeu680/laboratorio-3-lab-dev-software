//
//  GetTransactionsUseCase.swift
//  Domain
//
//  Created by Arthur Porto on 21/11/25.
//

final class GetTransactionsUseCase: GetTransactionsUseCaseProtocol {
    private let service: TransactionsServiceProtocol
    
    init(service: TransactionsServiceProtocol) {
        self.service = service
    }
    
    func execute() async throws(GetTransactionsUseCaseError) {
        do {
            try await service.getExtract()
        } catch {
            throw .todo
        }
    }
}

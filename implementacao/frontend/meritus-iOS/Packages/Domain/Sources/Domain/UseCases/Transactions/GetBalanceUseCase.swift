//
//  GetBalanceUseCase.swift
//  Domain
//
//  Created by Arthur Porto on 21/11/25.
//

final class GetBalanceUseCase: GetBalanceUseCaseProtocol {
    private let service: TransactionsServiceProtocol
    
    init(service: TransactionsServiceProtocol) {
        self.service = service
    }
    
    func execute() async throws(GetBalanceUseCaseError) -> String {
        do {
            let response =  try await service.getBalance()
            return response
        } catch {
            throw .todo
        }
    }
}

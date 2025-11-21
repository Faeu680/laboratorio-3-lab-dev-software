//
//  MakeTransferUseCase.swift
//  Domain
//
//  Created by Arthur Porto on 21/11/25.
//

final class MakeTransferUseCase: MakeTransferUseCaseProtocol {
    
    private let service: TransactionsServiceProtocol
    
    init(service: TransactionsServiceProtocol) {
        self.service = service
    }
    
    func execute(_ transfer: MakeTransferModel) async throws(MakeTransferUseCaseError) {
        do {
            try await service.transfer(
                studentId: transfer.studentId,
                amount: transfer.amount,
                message: transfer.message
            )
        } catch {
            throw .todo
        }
    }
}

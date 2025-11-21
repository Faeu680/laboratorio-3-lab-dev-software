//
//  ExtractScreenViewModel.swift
//  Meritus
//
//  Created by Arthur Porto on 03/11/25.
//

import SwiftUI
import Combine
import Domain
import Obsidian

@MainActor
final class ExtractScreenViewModel: ObservableObject {
    
    private let getBalanceUseCase: GetBalanceUseCaseProtocol
    private let getTransactionsUseCase: GetTransactionsUseCaseProtocol
    
    @Published var balance: String? = nil
    @Published var transactions: [TransactionModel] = []
    
    init(
        getBalanceUseCase: GetBalanceUseCaseProtocol,
        getTransactionsUseCase: GetTransactionsUseCaseProtocol
    ) {
        self.getBalanceUseCase = getBalanceUseCase
        self.getTransactionsUseCase = getTransactionsUseCase
    }
    
    func onViewDidLoad() async {
        await getBalance()
        await getTransactions()
    }
    
    private func getBalance() async {
        do {
            let balance = try await getBalanceUseCase.execute()
            self.balance = balance
        } catch {
            
        }
    }
    
    private func getTransactions() async {
        do {
            let transactions = try await getTransactionsUseCase.execute()
            self.transactions = transactions
        } catch {
            
        }
    }
}

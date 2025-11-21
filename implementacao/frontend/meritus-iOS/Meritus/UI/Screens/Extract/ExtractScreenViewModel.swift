//
//  ExtractScreenViewModel.swift
//  Meritus
//
//  Created by Arthur Porto on 03/11/25.
//

import SwiftUI
import Combine
import Domain

@MainActor
final class ExtractScreenViewModel: ObservableObject {
    
    private let getTransactionsUseCase: GetTransactionsUseCaseProtocol
    
    init(getTransactionsUseCase: GetTransactionsUseCaseProtocol) {
        self.getTransactionsUseCase = getTransactionsUseCase
    }
    
    func onViewDidLoad() async {
        do {
            try await getTransactionsUseCase.execute()
        } catch {
            
        }
        
    }
}

//
//  BenefitsScreenViewModel.swift
//  Meritus
//
//  Created by Arthur Porto on 03/11/25.
//

import SwiftUI
import Combine
import Domain

@MainActor
final class BenefitsScreenViewModel: ObservableObject {
    private let getBenefitsUseCase: GetBenefitsUseCaseProtocol
    
    @Published var benefits: [BenefitModel] = []
    
    init(getBenefitsUseCase: GetBenefitsUseCaseProtocol) {
        self.getBenefitsUseCase = getBenefitsUseCase
    }
    
    func onViewDidLoad() async {
        do {
            let benefits = try await getBenefitsUseCase.execute()
            self.benefits = benefits
        } catch {
            
        }
    }
}

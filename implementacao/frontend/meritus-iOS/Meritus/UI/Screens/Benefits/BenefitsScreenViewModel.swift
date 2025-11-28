//
//  BenefitsScreenViewModel.swift
//  Meritus
//
//  Created by Arthur Porto on 03/11/25.
//

import SwiftUI
import Combine
import Domain
import Session

@MainActor
final class BenefitsScreenViewModel: ObservableObject {
    private let session: SessionProtocol
    private let getBalanceUseCase: GetBalanceUseCaseProtocol
    private let getBenefitsUseCase: GetBenefitsUseCaseProtocol
    
    let userRole: UserRole
    private(set) var selectedBenefit: BenefitModel?
    private(set) var balance: String = ""
    
    @Published var benefits: [BenefitModel] = []
    @Published var showRedeemSheet: Bool = false
    
    var finalBalance: String {
        guard let selectedBenefit else { return balance }
        let finalBalance = (Int(balance) ?? 0) - (Int(selectedBenefit.cost) ?? 0)
        return "\(finalBalance)"
    }
    
    init(
        session: SessionProtocol,
        getBalanceUseCase: GetBalanceUseCaseProtocol,
        getBenefitsUseCase: GetBenefitsUseCaseProtocol
    ) {
        self.session = session
        self.getBalanceUseCase = getBalanceUseCase
        self.getBenefitsUseCase = getBenefitsUseCase
        self.userRole = session.unsafeGetRole() ?? .student
    }
    
    func onViewDidLoad() async {
        await getBenefits()
        await getBalance()
    }
    
    func showRedeemSheet(for benefit: BenefitModel) {
        selectedBenefit = benefit
        showRedeemSheet = true
    }
    
    func dismissRedeemSheet() {
        showRedeemSheet = false
    }
    
    private func getBalance() async {
        do {
            let balance = try await getBalanceUseCase.execute()
            self.balance = balance
        } catch { }
    }
    
    private func getBenefits() async {
        do {
            let benefits = try await getBenefitsUseCase.execute()
            self.benefits = benefits
        } catch {
            
        }
    }
}

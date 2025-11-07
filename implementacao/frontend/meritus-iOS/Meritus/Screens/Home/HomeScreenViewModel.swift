//
//  HomeScreenViewModel.swift
//  Meritus
//
//  Created by Arthur Porto on 29/10/25.
//

import Combine
import Session

@MainActor
final class HomeScreenViewModel: ObservableObject {
    
    private let session: SessionProtocol
    
    let isStudent: Bool
    let isTeacher: Bool
    let isCompany: Bool
    
    init(session: SessionProtocol) {
        self.session = session
        
        let role = session.unsafeGetRole()
        self.isStudent = role == .student
        self.isTeacher = role == .teacher
        self.isCompany = role == .company
    }
    
    func didTapLogout() async {
        await session.destroy()
    }
}

//
//  ResourceSelectScreenView.swift
//  Meritus
//
//  Created by Arthur Porto on 18/11/25.
//

import SwiftUI
import Obsidian
import Commons

struct ResourceSelectScreenView<ViewModel>: View where ViewModel: ResourceSelectScreenViewModelProtocol {
    
    @StateObject private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ObsidianList(verticalPadding: .size16) {
            ForEach(Array(viewModel.availableResources.enumerated()), id: \.element) { index, resource in
                selectItemView(
                    resource: resource,
                    isSelected: viewModel.selectedResource == resource
                )
                .padding(.top, index == .zero ? .size24 : .zero)
            }
        }
        .scrollDisabled(true)
        .navigationTitle(viewModel.toolbarTitle)
        .toolbarTitleDisplayMode(.inlineLarge)
    }
}

extension ResourceSelectScreenView {
    private func selectItemView(
        resource: ViewModel.Resource,
        isSelected: Bool
    ) -> some View {
        ObsidianListItem(
            title: resourceTitle(resource),
            leading: ObsidianSelectIndicator(
                isSelected: isSelected
            ),
            borderStyle: .regular
        ) {
            await viewModel.select(resource)
        }
    }
}

extension ResourceSelectScreenView {
    private func resourceTitle(_ resource: ViewModel.Resource) -> String {
        if let resource = resource as? AppColorScheme {
            return resource.title
        }
        
        return ""
    }
}

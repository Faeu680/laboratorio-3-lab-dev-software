//
//  ResourceSelectScreenView.swift
//  Meritus
//
//  Created by Arthur Porto on 18/11/25.
//

import SwiftUI
import Obsidian

struct ResourceSelectScreenView<ViewModel>: View where ViewModel: ResourceSelectScreenViewModelProtocol {
    
    @StateObject private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ObsidianList {
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
            title: resource.title,
            leading: ObsidianSelectIndicator(
                isSelected: isSelected
            )
        )
        .onTapGesture {
            viewModel.select(resource)
        }
    }
}

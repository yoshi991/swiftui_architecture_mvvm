//
//  HomeScreen.swift
//  swiftui_architecture_mvvm
//
//  Created by yoshi on 2022/09/13.
//

import Domain
import SwiftUI
import UI_Core

public struct HomeScreen: View { // swiftlint:disable:this file_types_order
    @StateObject private var viewModel: HomeViewModel = .init()

    public var body: some View {
        NavigationView {
            Group {
                if viewModel.uiState.isInitial {
                    VStack {}
                } else {
                    HomeView(
                        items: viewModel.uiState.items,
                        hasNextPage: viewModel.uiState.hasNextPage
                    ) {
                        Task { await viewModel.next() }
                    } onTapItem: {
                        print("item tapped")
                    }
                }
            }
            .navigationTitle("Repository")
            .toolbar {
                HomeToolbar {
                } onClickDebug: {
                    viewModel.showSnackbar()
                } onClickSetting: {
                }
            }
        }
        .snackbar(
            isPresented: $viewModel.uiState.isShowingAlert,
            message: viewModel.uiState.alertMessage
        ) {
            Image(systemName: "star")
                .foregroundColor(.white)
        }
        .refreshable {
            await viewModel.refresh()
        }
        .task {
            await viewModel.fetch()
        }
    }

    public init() {}
}

private struct HomeToolbar: ToolbarContent {
    let onClickMenu: () -> Void
    let onClickDebug: () -> Void
    let onClickSetting: () -> Void

    var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                onClickMenu()
            } label: {
                Image(systemName: "line.3.horizontal")
            }
        }

        ToolbarItemGroup(placement: .navigationBarTrailing) {
            Button {
                onClickDebug()
            } label: {
                Image(systemName: "exclamationmark.circle")
            }
            Button {
                onClickSetting()
            } label: {
                Image(systemName: "gearshape.fill")
            }
        }
    }
}

private struct HomeView: View {
    let items: [RepositoryEntity]
    let hasNextPage: Bool
    let onAppearLoadingItem: (() -> Void)
    let onTapItem: () -> Void

    var body: some View {
        if items.isEmpty {
            ContentsEmptyView()
        } else {
            HomeContentsView(
                items: items,
                hasNextPage: hasNextPage,
                onAppearLoadingItem: onAppearLoadingItem,
                onTapItem: onTapItem
            )
        }
    }
}

private struct HomeContentsView: View {
    let items: [RepositoryEntity]
    let hasNextPage: Bool
    let onAppearLoadingItem: () -> Void
    let onTapItem: () -> Void

    var body: some View {
        ScrollView(.vertical) {
            LazyVStack {
                ForEach(items, id: \.id) { item in
                    RepositoryCardView(
                        item: item,
                        onTapGesture: onTapItem
                    )
                    .frame(maxWidth: .infinity)
                }

                if hasNextPage {
                    LoadingView()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .task { onAppearLoadingItem() }
                }
            }
            .padding()
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    private struct HomeContentsPreview: View {
        var body: some View {
            HomeContentsView(items: [RepositoryEntity.preview], hasNextPage: false) {} onTapItem: {}
        }
    }

    static var previews: some View {
        HomeContentsPreview()
    }
}

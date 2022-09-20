//
//  SearchRepoView.swift
//
//
//  Created by Yuki Okudera on 2022/09/19.
//

import Components
import ComposableArchitecture
import Models
import NavigationSearchBar
import SwiftUI

// MARK: - SearchRepoView
public struct SearchRepoView: View {
    let store: Store<SearchRepoCore.State, SearchRepoCore.Action>

    public init(store: Store<SearchRepoCore.State, SearchRepoCore.Action>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                ScrollView {
                    if viewStore.state.isLoading {
                        VStack {
                            Spacer()
                            LottieView(
                                asset: "octocat",
                                isAnimating: viewStore.binding(
                                    get: { $0.isLoading },
                                    send: SearchRepoCore.Action.loadingActive
                                )
                            )
                            .frame(width: 120, height: 120, alignment: .center)
                            Spacer()
                        }
                    } else {
                        LazyVStack {
                            ForEach(viewStore.state.gitHubRepositories) {
                                GitHubRepoItemView(gitHubRepo: $0)
                                    .id($0.id)
                            }
                            LottieView(
                                asset: "octocat",
                                isAnimating: viewStore.binding(
                                    get: { $0.isLoadingPage },
                                    send: SearchRepoCore.Action.loadingPageActive
                                )
                            )
                            .frame(width: 120, height: 120, alignment: .center)
                            .onAppear {
                                if !viewStore.state.gitHubRepositories.isEmpty {
                                    viewStore.send(.reachedBottom)
                                }
                            }
                        }
                    }
                }
                .navigationBarTitle(LocalizedStringKey("SearchRepo"))
                .navigationSearchBar(
                    text: viewStore.binding(get: \.searchQuery, send: SearchRepoCore.Action.searchQueryChanged),
                    options: [
                        .automaticallyShowsSearchBar: true,
                        .hidesNavigationBarDuringPresentation: true,
                        .hidesSearchBarWhenScrolling: true,
                        .placeholder: "Search the repository",
                    ],
                    actions: [
                        .onCancelButtonClicked: {
                            print("Cancel")
                        },
                        .onSearchButtonClicked: {
                            print("Search")
                            viewStore.send(.search)
                        },
                    ]
                )
            }
            .onDisappear { viewStore.send(.onDisappear) }
        }
    }
}

// MARK: - SearchRepoView_Previews
struct SearchRepoView_Previews: PreviewProvider {
    static var previews: some View {
        SearchRepoView(
            store: .init(
                initialState: .init(
                    searchQuery: "",
                    currentPage: 1,
                    isLoading: false,
                    isLoadingPage: false,
                    gitHubRepositories: .mock
                ),
                reducer: SearchRepoCore.reducer,
                environment: .init(
                    apiClient: .mockPreview(),
                    mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
                    uuid: UUID.init
                )
            )
        )
    }
}

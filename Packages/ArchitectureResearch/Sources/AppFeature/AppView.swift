//
//  AppView.swift
//
//
//  Created by Yuki Okudera on 2022/09/19.
//

import ComposableArchitecture
import SearchRepoFeature
import SwiftUI

// MARK: - AppView
public struct AppView: View {
    let store: Store<AppCore.State, AppCore.Action>

    public init(store: Store<AppCore.State, AppCore.Action>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            TabView(
                selection: viewStore.binding(
                    get: { $0.selectedTab },
                    send: AppCore.Action.selectedTabChange
                ),
                content: {
                    Group {
                        SearchRepoView(store: store.scope(
                            state: { $0.searchRepoState },
                            action: AppCore.Action.searchRepo
                        ))
                        .tabItem {
                            Image(systemName: "magnifyingglass")
                            Text(LocalizedStringKey("SearchRepo"))
                        }
                        .tag(AppCore.State.Tab.repo)
                    }
                }
            )
        }
    }
}

// MARK: - AppView_Previews
struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(
            store: .init(
                initialState: AppCore.State(),
                reducer: AppCore.reducer,
                environment: .init(
                    apiClient: .mockPreview(),
                    mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
                    uuid: UUID.init
                )
            )
        )
    }
}

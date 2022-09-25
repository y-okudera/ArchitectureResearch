//
//  AppCore.swift
//
//
//  Created by Yuki Okudera on 2022/09/19.
//

import ApiClient
import ComposableArchitecture
import Foundation
import SearchRepoFeature

public enum AppCore {

    // MARK: - State

    public struct State: Equatable {
        var appDelegateState: AppDelegateCore.State
        var searchRepoState: SearchRepoCore.State

        // swiftlint:disable nesting
        public enum Tab: Equatable {
            case repo
        }

        var selectedTab = Tab.repo

        public init() {
            appDelegateState = .init()
            searchRepoState = .init()
        }
    }

    // MARK: - Action

    public enum Action {
        case appDelegate(AppDelegateCore.Action)
        case searchRepo(SearchRepoCore.Action)
        case selectedTabChange(State.Tab)
    }

    // MARK: - Environment

    public struct Environment {
        var apiClient: ApiClient
        var mainQueue: AnySchedulerOf<DispatchQueue>
        var uuid: () -> UUID

        public init(
            apiClient: ApiClient,
            mainQueue: AnySchedulerOf<DispatchQueue>,
            uuid: @escaping () -> UUID
        ) {
            self.apiClient = apiClient
            self.mainQueue = mainQueue
            self.uuid = uuid
        }
    }

    // MARK: - Reducer

    public static let reducer: Reducer<State, Action, Environment> =
        .combine(
            AppDelegateCore.reducer.pullback(
                state: \State.appDelegateState,
                action: /Action.appDelegate,
                environment: { _ in
                    AppDelegateCore.Environment()
                }
            ),
            SearchRepoCore.reducer.pullback(
                state: \State.searchRepoState,
                action: /Action.searchRepo,
                environment: { environment in
                    SearchRepoCore.Environment(
                        apiClient: environment.apiClient,
                        mainQueue: environment.mainQueue,
                        uuid: environment.uuid
                    )
                }
            ),
            .init { state, action, _ in
                switch action {
                case .appDelegate:
                    return .none
                case .searchRepo:
                    return .none
                case let .selectedTabChange(selectedTab):
                    state.selectedTab = selectedTab
                    return .none
                }
            }
        )
}

//
//  SearchRepoCore.swift
//
//
//  Created by Yuki Okudera on 2022/09/19.
//

import ApiClient
import ComposableArchitecture
import Foundation
import Models

public enum SearchRepoCore {

    // MARK: - State

    public struct State: Equatable {
        public init(
            searchQuery: String,
            currentPage: Int,
            isLoading: Bool,
            isLoadingPage: Bool,
            gitHubRepositories: [GitHubRepo]
        ) {
            self.searchQuery = searchQuery
            self.currentPage = currentPage
            self.isLoading = isLoading
            self.isLoadingPage = isLoadingPage
            self.gitHubRepositories = gitHubRepositories
        }

        public init() {
            self.init(
                searchQuery: "",
                currentPage: 0,
                isLoading: false,
                isLoadingPage: false,
                gitHubRepositories: []
            )
        }

        var searchQuery: String
        var currentPage: Int
        let perPage = 20
        var isLoading: Bool
        var isLoadingPage: Bool
        var gitHubRepositories = [GitHubRepo]()
    }

    // MARK: - Action

    public enum Action: Equatable {
        case searchQueryChanged(String)
        case search
        case reachedBottom
        case searchRepoResponse(Result<ApiResponse<SearchRepoResponse>, ApiError>)
        case loadMoreRepoResponse(Result<ApiResponse<SearchRepoResponse>, ApiError>)
        case loadingActive(Bool)
        case loadingPageActive(Bool)
        case onDisappear
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

    public static let reducer = Reducer<State, Action, Environment> { state, action, environment in

        struct SearchRepoCancelId: Hashable {}

        switch action {
        case let .searchQueryChanged(searchQuery):
            state.searchQuery = searchQuery
            return .none
        case .search:
            state.gitHubRepositories = []
            state.currentPage = 0
            return .concatenate(
                .init(value: .loadingActive(true)),
                .init(value: .loadingPageActive(false)),
                environment.apiClient
                    .searchRepo(.init(searchQuery: state.searchQuery, page: 1, perPage: state.perPage))
                    .receive(on: environment.mainQueue)
                    .catchToEffect()
                    .map(Action.searchRepoResponse)
                    .cancellable(id: SearchRepoCancelId())
            )
        case .reachedBottom:
            return .concatenate(
                .init(value: .loadingActive(false)),
                .init(value: .loadingPageActive(true)),
                environment.apiClient
                    .searchRepo(.init(searchQuery: state.searchQuery, page: state.currentPage + 1, perPage: state.perPage))
                    .receive(on: environment.mainQueue)
                    .catchToEffect()
                    .map(Action.searchRepoResponse)
                    .cancellable(id: SearchRepoCancelId())
            )
        case let .searchRepoResponse(.success(response)):
            state.currentPage += 1
            response.response.items.forEach {
                state.gitHubRepositories.append($0)
            }
            return .concatenate(
                .init(value: .loadingActive(false)),
                .init(value: .loadingPageActive(false))
            )
        case let .searchRepoResponse(.failure(error)):
            return .concatenate(
                .init(value: .loadingActive(false)),
                .init(value: .loadingPageActive(false))
            )
        case let .loadMoreRepoResponse(.success(response)):
            response.response.items.forEach {
                state.gitHubRepositories.append($0)
            }
            return .concatenate(
                .init(value: .loadingActive(false)),
                .init(value: .loadingPageActive(false))
            )
        case let .loadMoreRepoResponse(.failure(error)):
            return .concatenate(
                .init(value: .loadingActive(false)),
                .init(value: .loadingPageActive(false))
            )
        case let .loadingActive(isLoading):
            state.isLoading = isLoading
            return .none

        case let .loadingPageActive(isLoading):
            state.isLoadingPage = isLoading
            return .none
        case .onDisappear:
            return .cancel(id: SearchRepoCancelId())
        }
    }
}

//
//  SearchRepoPresenter.swift
//
//
//  Created by Yuki Okudera on 2022/08/12.
//

import Domain
import Foundation

// MARK: - SearchRepoPresenter
protocol SearchRepoPresenter {
    var state: SearchRepoState { get }
    func search(searchQuery: String?) async throws -> [GitHubRepo]?
    func reachedBottom() async throws -> [GitHubRepo]
    func isEnabledLoadMore() async -> Bool
    func finishLoading() async
    func didSelect(data: GitHubRepo)
}

// MARK: - SearchRepoPresenterImpl
final class SearchRepoPresenterImpl: SearchRepoPresenter {

    private(set) var state: SearchRepoState
    private let searchRepoUseCase: SearchRepoUseCase
    private let loadMoreRepoUseCase: LoadMoreRepoUseCase
    private let readSearchRepoRequestDataUseCase: ReadSearchRepoRequestDataUseCase
    private let wireframe: SearchRepoWireframe

    init(
        state: SearchRepoState,
        searchRepoUseCase: SearchRepoUseCase,
        loadMoreRepoUseCase: LoadMoreRepoUseCase,
        readSearchRepoRequestDataUseCase: ReadSearchRepoRequestDataUseCase,
        wireframe: SearchRepoWireframe
    ) {
        self.state = state
        self.searchRepoUseCase = searchRepoUseCase
        self.loadMoreRepoUseCase = loadMoreRepoUseCase
        self.readSearchRepoRequestDataUseCase = readSearchRepoRequestDataUseCase
        self.wireframe = wireframe
    }

    func search(searchQuery: String?) async throws -> [GitHubRepo]? {
        let isLoading = await state.isLoading
        guard let searchQuery = searchQuery, !isLoading else {
            return nil
        }
        await state.updateLoadingState(isLoading: true)
        let searchedRepo = try await searchRepoUseCase.execute(searchQuery: searchQuery)
        await state.updateLoadingState(isLoading: false)
        return searchedRepo.items
    }

    func isEnabledLoadMore() async -> Bool {
        let isLoading = await state.isLoading
        let searchRepoData = readSearchRepoRequestDataUseCase.execute()
        return await searchRepoData.isEnabledLoadMore(isLoading: isLoading)
    }

    func reachedBottom() async throws -> [GitHubRepo] {
        await state.updateLoadingState(isLoading: true)
        let searchedRepo = try await loadMoreRepoUseCase.execute()
        await state.updateLoadingState(isLoading: false)
        return searchedRepo.items
    }

    func finishLoading() async {
        await state.updateLoadingState(isLoading: false)
    }

    func didSelect(data: GitHubRepo) {
        wireframe.pushGeneralWebView(initialUrl: data.htmlUrl)
    }
}

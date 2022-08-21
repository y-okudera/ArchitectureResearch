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
    func finishLoading() async
    func didSelect(data: GitHubRepo)
}

// MARK: - SearchRepoPresenterImpl
final class SearchRepoPresenterImpl: SearchRepoPresenter {

    private(set) var state: SearchRepoState
    private let searchRepoUseCase: SearchRepoUseCase
    private let wireframe: SearchRepoWireframe

    init(state: SearchRepoState, searchRepoUseCase: SearchRepoUseCase, wireframe: SearchRepoWireframe) {
        self.state = state
        self.searchRepoUseCase = searchRepoUseCase
        self.wireframe = wireframe
    }

    func search(searchQuery: String?) async throws -> [GitHubRepo]? {
        guard await state.isEnabledSearch(searchQuery: searchQuery) else {
            return nil
        }
        await state.update(isLoading: true)
        let viewData = try await searchRepoUseCase.execute(searchQuery: searchQuery ?? "", page: 1)
        let hasNext = await viewData.hasNext
        await state.update(isLoading: false, page: 2, searchQuery: searchQuery, hasNext: hasNext)
        let items = await viewData.items
        return items
    }

    func reachedBottom() async throws -> [GitHubRepo] {
        log("追加読み込み state.searchQuery: \(await state.searchQuery) state.page: \(await state.page)")
        await state.update(isLoading: true)
        let viewData = try await searchRepoUseCase.execute(searchQuery: state.searchQuery, page: state.page)
        let hasNext = await viewData.hasNext
        await state.update(isLoading: false, page: state.page + 1, searchQuery: state.searchQuery, hasNext: hasNext)
        let items = await viewData.items
        return items
    }

    func finishLoading() async {
        await state.update(isLoading: false)
    }

    func didSelect(data: GitHubRepo) {
        wireframe.pushGeneralWebView(initialUrl: data.htmlUrl)
    }
}

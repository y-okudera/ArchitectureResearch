//
//  SearchRepoPresenter.swift
//  
//
//  Created by Yuki Okudera on 2022/08/12.
//

import Domain
import Foundation

protocol SearchRepoPresenter {
    var state: SearchRepoState { get }
    func search(searchQuery: String?) async throws -> Bool
    func reachedBottom() async throws
    func finishLoading() async
    func didSelectRow(at indexPath: IndexPath) async
}

final class SearchRepoPresenterImpl: SearchRepoPresenter {

    private(set) var state: SearchRepoState
    private let gitHubRepoRepository: GitHubRepoRepository
    private let wireframe: SearchRepoWireframe

    init(state: SearchRepoState, gitHubRepoRepository: GitHubRepoRepository, wireframe: SearchRepoWireframe) {
        self.state = state
        self.gitHubRepoRepository = gitHubRepoRepository
        self.wireframe = wireframe
    }

    func search(searchQuery: String?) async throws -> Bool {
        guard await state.isEnabledSearch(searchQuery: searchQuery) else {
            return false
        }

        await state.update(isLoading: true)

        let viewData = try await gitHubRepoRepository.search(searchQuery: searchQuery ?? "", page: 1)

        state = .init(
            isLoading: false,
            page: 2,
            searchQuery: searchQuery ?? "",
            viewData: viewData
        )

        return true
    }

    func reachedBottom() async throws {
        log("追加読み込み state.searchQuery: \(await state.searchQuery) state.page: \(await state.page)")

        await state.update(isLoading: true)

        let viewData = try await gitHubRepoRepository.search(searchQuery: state.searchQuery, page: state.page)

        state = await .init(
            isLoading: false,
            page: state.page + 1,
            searchQuery: state.searchQuery,
            viewData: .init(
                hasNext: viewData.hasNext,
                items: state.viewData.items + viewData.items
            )
        )
    }

    func finishLoading() async {
        await state.update(isLoading: false)
    }

    func didSelectRow(at indexPath: IndexPath) async {
        let initialUrl = await state.viewData.items[indexPath.row].htmlUrl
        wireframe.pushGeneralWebView(initialUrl: initialUrl)
    }
}

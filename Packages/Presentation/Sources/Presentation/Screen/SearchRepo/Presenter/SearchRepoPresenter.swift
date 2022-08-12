//
//  SearchRepoPresenter.swift
//  
//
//  Created by Yuki Okudera on 2022/08/12.
//

import Core
import Domain
import Foundation

protocol SearchRepoPresenter {
    var state: SearchRepoState { get }
    func search(searchQuery: String?) async throws -> Bool
    func didScroll(offsetY: Double, threshold: Double, edgeOffset: Double) async throws -> Bool
    func finishLoading()
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
        guard !state.isLoading else {
            return false
        }
        guard let searchQuery = searchQuery, !searchQuery.isEmpty else {
            return false
        }
        state.update(isLoading: true)
        let viewData = try await gitHubRepoRepository.search(searchQuery: searchQuery, page: 1)
        state.update(isLoading: false, page: 2, searchQuery: searchQuery, viewData: viewData)
        return true
    }

    func didScroll(offsetY: Double, threshold: Double, edgeOffset: Double) async throws -> Bool {
        guard !state.isLoading else {
            return false
        }
        guard !state.searchQuery.isEmpty else {
            return false
        }
        guard state.viewData.hasNext else {
            return false
        }
        guard offsetY > threshold - edgeOffset else {
            return false
        }

        print("追加読み込み state.page = \(state.page)")
        state.update(isLoading: true)
        let viewData = try await gitHubRepoRepository.search(searchQuery: state.searchQuery, page: state.page)
        state.update(isLoading: false, page: state.page + 1)
        state.viewData.append(viewData: viewData)
        return true
    }

    func finishLoading() {
        state.update(isLoading: false)
    }
}

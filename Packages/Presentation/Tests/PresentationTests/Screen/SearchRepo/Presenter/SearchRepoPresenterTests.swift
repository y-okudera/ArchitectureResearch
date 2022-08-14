//
//  SearchRepoPresenterTests.swift
//  
//
//  Created by Yuki Okudera on 2022/08/15.
//

@testable import Presentation
import Infrastructure
import XCTest

final class SearchRepoPresenterTests: XCTestCase {

    private var searchRepoState: SearchRepoState!
    private var gitHubRepoRepositoryMock = GitHubRepoRepositoryMock()
    private var searchRepoWireframeMock = SearchRepoWireframeMock()

    override func setUp() {
        searchRepoState = SearchRepoState(
            isLoading: false,
            page: 1,
            searchQuery: "",
            viewData: .init(hasNext: true, items: [])
        )
        gitHubRepoRepositoryMock = GitHubRepoRepositoryMock()
        searchRepoWireframeMock = SearchRepoWireframeMock()
    }
}

extension SearchRepoPresenterTests {

    func testInit() async {
        // Exercise
        let searchRepoPresenterImpl = SearchRepoPresenterImpl(
            state: searchRepoState,
            gitHubRepoRepository: gitHubRepoRepositoryMock,
            wireframe: searchRepoWireframeMock
        )

        // Verify
        let isLoading = await searchRepoPresenterImpl.state.isLoading
        XCTAssertEqual(isLoading, false)
        let page = await searchRepoPresenterImpl.state.page
        XCTAssertEqual(page, 1)
        let searchQuery = await searchRepoPresenterImpl.state.searchQuery
        XCTAssertEqual(searchQuery, "")
        let hasNext = await searchRepoPresenterImpl.state.viewData.hasNext
        XCTAssertEqual(hasNext, true)
        XCTAssertEqual( searchRepoPresenterImpl.state.viewData.numberOfItems, 0)
    }
}

extension SearchRepoPresenterTests {

    func testSearchWhenIsLoading() async throws {
        // Setup
        let searchRepoPresenterImpl = SearchRepoPresenterImpl(
            state: searchRepoState,
            gitHubRepoRepository: gitHubRepoRepositoryMock,
            wireframe: searchRepoWireframeMock
        )
        await searchRepoPresenterImpl.state.update(isLoading: true)

        // Exercise
        let result = try await searchRepoPresenterImpl.search(searchQuery: "test")

        // Verify
        XCTAssertEqual(result, false)
    }

    func testSearch() async throws {
        // Setup
        gitHubRepoRepositoryMock.searchHandler = { _, _ in
            return .init(
                hasNext: true,
                items: [
                    .init(
                        id: 44838949,
                        fullName: "apple/swift",
                        description: "The Swift Programming Language",
                        stargazersCount: 60306,
                        language: "C++",
                        htmlUrl: URL(string: "https://github.com/apple/swift")!,
                        owner: .init(
                            id: 10639145,
                            login: "apple",
                            avatarUrl: URL(string: "https://avatars.githubusercontent.com/u/10639145?v=4")!,
                            htmlUrl: URL(string: "https://github.com/apple")!,
                            type: "Organization"
                        )
                    )
                ]
            )
        }

        let searchRepoPresenterImpl = SearchRepoPresenterImpl(
            state: searchRepoState,
            gitHubRepoRepository: gitHubRepoRepositoryMock,
            wireframe: searchRepoWireframeMock
        )

        // Exercise
        let result = try await searchRepoPresenterImpl.search(searchQuery: "test")

        // Verify
        XCTAssertEqual(result, true)
    }
}

extension SearchRepoPresenterTests {

    func testReachedBottomWhenCannotConnected() async throws {
        // Setup
        gitHubRepoRepositoryMock.searchHandler = { _, _ in
            throw ApiError.cannotConnected
        }
        searchRepoState = SearchRepoState(
            isLoading: false,
            page: 2,
            searchQuery: "test",
            viewData: .init(
                hasNext: false,
                items: [
                    .init(
                        id: 44838949,
                        fullName: "apple/swift",
                        description: "The Swift Programming Language",
                        stargazersCount: 60306,
                        language: "C++",
                        htmlUrl: URL(string: "https://github.com/apple/swift")!,
                        owner: .init(
                            id: 10639145,
                            login: "apple",
                            avatarUrl: URL(string: "https://avatars.githubusercontent.com/u/10639145?v=4")!,
                            htmlUrl: URL(string: "https://github.com/apple")!,
                            type: "Organization"
                        )
                    )
                ]
            )
        )

        let searchRepoPresenterImpl = SearchRepoPresenterImpl(
            state: searchRepoState,
            gitHubRepoRepository: gitHubRepoRepositoryMock,
            wireframe: searchRepoWireframeMock
        )

        do {
            // Exercise
            try await searchRepoPresenterImpl.reachedBottom()
        } catch {
            // Verify
            XCTAssertEqual((error as NSError).domain, "Infrastructure.ApiError")
            XCTAssertEqual((error as NSError).code, 0)
        }
    }

    func testReachedBottom() async throws {
        // Setup
        gitHubRepoRepositoryMock.searchHandler = { _, _ in
            return .init(
                hasNext: false,
                items: [
                    .init(
                        id: 790019,
                        fullName: "openstack/swift",
                        description: "OpenStack Storage (Swift). Mirror of code maintained at opendev.org.",
                        stargazersCount: 2323,
                        language: "Python",
                        htmlUrl: URL(string: "https://github.com/openstack/swift")!,
                        owner: .init(
                            id: 324574,
                            login: "openstack",
                            avatarUrl: URL(string: "https://avatars.githubusercontent.com/u/324574?v=4")!,
                            htmlUrl: URL(string: "https://github.com/openstack")!,
                            type: "Organization"
                        )
                    )
                ]
            )
        }
        searchRepoState = SearchRepoState(
            isLoading: false,
            page: 2,
            searchQuery: "test",
            viewData: .init(
                hasNext: false,
                items: [
                    .init(
                        id: 44838949,
                        fullName: "apple/swift",
                        description: "The Swift Programming Language",
                        stargazersCount: 60306,
                        language: "C++",
                        htmlUrl: URL(string: "https://github.com/apple/swift")!,
                        owner: .init(
                            id: 10639145,
                            login: "apple",
                            avatarUrl: URL(string: "https://avatars.githubusercontent.com/u/10639145?v=4")!,
                            htmlUrl: URL(string: "https://github.com/apple")!,
                            type: "Organization"
                        )
                    )
                ]
            )
        )

        let searchRepoPresenterImpl = SearchRepoPresenterImpl(
            state: searchRepoState,
            gitHubRepoRepository: gitHubRepoRepositoryMock,
            wireframe: searchRepoWireframeMock
        )

        // Expect no throw error.
        try await searchRepoPresenterImpl.reachedBottom()
    }
}

extension SearchRepoPresenterTests {

    func testFinishLoading() async {
        // Setup
        searchRepoState = SearchRepoState(
            isLoading: true,
            page: 1,
            searchQuery: "",
            viewData: .init(hasNext: true, items: [])
        )
        let searchRepoPresenterImpl = SearchRepoPresenterImpl(
            state: searchRepoState,
            gitHubRepoRepository: gitHubRepoRepositoryMock,
            wireframe: searchRepoWireframeMock
        )

        // Exercise
        await searchRepoPresenterImpl.finishLoading()

        // Verify
        let isLoading = await searchRepoPresenterImpl.state.isLoading
        XCTAssertEqual(isLoading, false)
    }
}

extension SearchRepoPresenterTests {

    func testDidSelectRow() async {
        // Setup
        searchRepoState = SearchRepoState(
            isLoading: false,
            page: 2,
            searchQuery: "test",
            viewData: .init(
                hasNext: false,
                items: [
                    .init(
                        id: 44838949,
                        fullName: "apple/swift",
                        description: "The Swift Programming Language",
                        stargazersCount: 60306,
                        language: "C++",
                        htmlUrl: URL(string: "https://github.com/apple/swift")!,
                        owner: .init(
                            id: 10639145,
                            login: "apple",
                            avatarUrl: URL(string: "https://avatars.githubusercontent.com/u/10639145?v=4")!,
                            htmlUrl: URL(string: "https://github.com/apple")!,
                            type: "Organization"
                        )
                    )
                ]
            )
        )

        let searchRepoPresenterImpl = SearchRepoPresenterImpl(
            state: searchRepoState,
            gitHubRepoRepository: gitHubRepoRepositoryMock,
            wireframe: searchRepoWireframeMock
        )

        // Exercise
        await searchRepoPresenterImpl.didSelectRow(at: [0, 0])

        // Verify
        XCTAssertEqual(searchRepoWireframeMock.pushGeneralWebViewCallCount, 1)
        XCTAssertEqual(searchRepoWireframeMock.pushGeneralWebViewArgValues[0], URL(string: "https://github.com/apple/swift")!)
    }
}

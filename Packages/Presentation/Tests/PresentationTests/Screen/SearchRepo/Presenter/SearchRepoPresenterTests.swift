//
//  SearchRepoPresenterTests.swift
//
//
//  Created by Yuki Okudera on 2022/08/15.
//

@testable import Presentation
import Domain
import XCTest

// MARK: - SearchRepoPresenterTests
final class SearchRepoPresenterTests: XCTestCase {

    private var searchRepoState: SearchRepoState!
    private var searchRepoUseCaseMock = SearchRepoUseCaseMock()
    private var loadMoreRepoUseCaseMock = LoadMoreRepoUseCaseMock()
    private var readSearchRepoDataUseCaseMock = ReadSearchRepoDataUseCaseMock()
    private var searchRepoWireframeMock = SearchRepoWireframeMock()

    override func setUp() {
        searchRepoState = SearchRepoState(isLoading: false)
        searchRepoUseCaseMock = SearchRepoUseCaseMock()
        searchRepoWireframeMock = SearchRepoWireframeMock()
    }
}

extension SearchRepoPresenterTests {

    func testInit() async {
        // Exercise
        let searchRepoPresenterImpl = SearchRepoPresenterImpl(
            state: searchRepoState,
            searchRepoUseCase: searchRepoUseCaseMock,
            loadMoreRepoUseCase: loadMoreRepoUseCaseMock,
            readSearchRepoDataUseCase: readSearchRepoDataUseCaseMock,
            wireframe: searchRepoWireframeMock
        )

        // Verify
        let isLoading = await searchRepoPresenterImpl.state.isLoading
        XCTAssertEqual(isLoading, false)
    }
}

extension SearchRepoPresenterTests {

    func testSearchWhenIsLoading() async throws {
        // Setup
        let searchRepoPresenterImpl = SearchRepoPresenterImpl(
            state: searchRepoState,
            searchRepoUseCase: searchRepoUseCaseMock,
            loadMoreRepoUseCase: loadMoreRepoUseCaseMock,
            readSearchRepoDataUseCase: readSearchRepoDataUseCaseMock,
            wireframe: searchRepoWireframeMock
        )
        await searchRepoPresenterImpl.state.updateLoadingState(isLoading: true)

        // Exercise
        let result = try await searchRepoPresenterImpl.search(searchQuery: "test")

        // Verify
        XCTAssertEqual(result, nil)
    }

    func testSearch() async throws {
        // Setup
        searchRepoUseCaseMock.executeHandler = { searchQuery in
            SearchedRepo(items: .stub, searchQuery: searchQuery, page: 1, hasNext: true)
        }

        let searchRepoPresenterImpl = SearchRepoPresenterImpl(
            state: searchRepoState,
            searchRepoUseCase: searchRepoUseCaseMock,
            loadMoreRepoUseCase: loadMoreRepoUseCaseMock,
            readSearchRepoDataUseCase: readSearchRepoDataUseCaseMock,
            wireframe: searchRepoWireframeMock
        )

        // Exercise
        let result = try await searchRepoPresenterImpl.search(searchQuery: "test")

        // Verify
        XCTAssertEqual(result, .stub)
        XCTAssertEqual(searchRepoUseCaseMock.executeCallCount, 1)
        XCTAssertEqual(searchRepoUseCaseMock.executeArgValues[0], "test")
    }
}

extension SearchRepoPresenterTests {

    func testReachedBottomWhenCannotConnected() async throws {
        // Setup
        loadMoreRepoUseCaseMock.executeHandler = {
            throw ApiError.cannotConnected
        }
        searchRepoState = SearchRepoState(isLoading: false)

        let searchRepoPresenterImpl = SearchRepoPresenterImpl(
            state: searchRepoState,
            searchRepoUseCase: searchRepoUseCaseMock,
            loadMoreRepoUseCase: loadMoreRepoUseCaseMock,
            readSearchRepoDataUseCase: readSearchRepoDataUseCaseMock,
            wireframe: searchRepoWireframeMock
        )

        do {
            // Exercise
            _ = try await searchRepoPresenterImpl.reachedBottom()
        } catch {
            // Verify
            XCTAssertEqual((error as NSError).domain, "Domain.ApiError")
            XCTAssertEqual((error as NSError).code, 0)
        }
    }

    func testReachedBottom() async throws {
        // Setup
        loadMoreRepoUseCaseMock.executeHandler = {
            SearchedRepo(items: .stub, searchQuery: "test", page: 1, hasNext: false)
        }
        searchRepoState = SearchRepoState(isLoading: false)

        let searchRepoPresenterImpl = SearchRepoPresenterImpl(
            state: searchRepoState,
            searchRepoUseCase: searchRepoUseCaseMock,
            loadMoreRepoUseCase: loadMoreRepoUseCaseMock,
            readSearchRepoDataUseCase: readSearchRepoDataUseCaseMock,
            wireframe: searchRepoWireframeMock
        )

        // Expect no throw error.
        _ = try await searchRepoPresenterImpl.reachedBottom()

        XCTAssertEqual(loadMoreRepoUseCaseMock.executeCallCount, 1)
    }
}

extension SearchRepoPresenterTests {

    func testFinishLoading() async {
        // Setup
        searchRepoState = SearchRepoState(isLoading: true)
        let searchRepoPresenterImpl = SearchRepoPresenterImpl(
            state: searchRepoState,
            searchRepoUseCase: searchRepoUseCaseMock,
            loadMoreRepoUseCase: loadMoreRepoUseCaseMock,
            readSearchRepoDataUseCase: readSearchRepoDataUseCaseMock,
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
        searchRepoState = SearchRepoState(isLoading: false)

        let searchRepoPresenterImpl = SearchRepoPresenterImpl(
            state: searchRepoState,
            searchRepoUseCase: searchRepoUseCaseMock,
            loadMoreRepoUseCase: loadMoreRepoUseCaseMock,
            readSearchRepoDataUseCase: readSearchRepoDataUseCaseMock,
            wireframe: searchRepoWireframeMock
        )
        let data = GitHubRepo(
            id: 44_838_949,
            fullName: "apple/swift",
            description: "The Swift Programming Language",
            stargazersCount: 60306,
            language: "C++",
            htmlUrl: URL(string: "https://github.com/apple/swift")!,
            owner: .init(
                id: 10_639_145,
                login: "apple",
                avatarUrl: URL(string: "https://avatars.githubusercontent.com/u/10639145?v=4")!,
                htmlUrl: URL(string: "https://github.com/apple")!,
                type: "Organization"
            )
        )

        // Exercise
        searchRepoPresenterImpl.didSelect(data: data)

        // Verify
        XCTAssertEqual(searchRepoWireframeMock.pushGeneralWebViewCallCount, 1)
        XCTAssertEqual(searchRepoWireframeMock.pushGeneralWebViewArgValues[0], URL(string: "https://github.com/apple/swift")!)
    }
}

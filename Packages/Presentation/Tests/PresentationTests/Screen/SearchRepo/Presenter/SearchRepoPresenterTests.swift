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
    private var searchRepoWireframeMock = SearchRepoWireframeMock()

    override func setUp() {
        searchRepoState = SearchRepoState(
            isLoading: false,
            page: 1,
            searchQuery: "",
            hasNext: true
        )
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
            wireframe: searchRepoWireframeMock
        )

        // Verify
        let isLoading = await searchRepoPresenterImpl.state.isLoading
        XCTAssertEqual(isLoading, false)
        let page = await searchRepoPresenterImpl.state.page
        XCTAssertEqual(page, 1)
        let searchQuery = await searchRepoPresenterImpl.state.searchQuery
        XCTAssertEqual(searchQuery, "")
        let hasNext = await searchRepoPresenterImpl.state.hasNext
        XCTAssertEqual(hasNext, true)
    }
}

extension SearchRepoPresenterTests {

    func testSearchWhenIsLoading() async throws {
        // Setup
        let searchRepoPresenterImpl = SearchRepoPresenterImpl(
            state: searchRepoState,
            searchRepoUseCase: searchRepoUseCaseMock,
            wireframe: searchRepoWireframeMock
        )
        await searchRepoPresenterImpl.state.update(isLoading: true)

        // Exercise
        let result = try await searchRepoPresenterImpl.search(searchQuery: "test")

        // Verify
        XCTAssertEqual(result, nil)
    }

    func testSearch() async throws {
        // Setup
        searchRepoUseCaseMock.executeHandler = { _, _ in
            .init(hasNext: true, items: .stub)
        }

        let searchRepoPresenterImpl = SearchRepoPresenterImpl(
            state: searchRepoState,
            searchRepoUseCase: searchRepoUseCaseMock,
            wireframe: searchRepoWireframeMock
        )

        // Exercise
        let result = try await searchRepoPresenterImpl.search(searchQuery: "test")

        // Verify
        XCTAssertEqual(result, .stub)
        XCTAssertEqual(searchRepoUseCaseMock.executeCallCount, 1)
        XCTAssertEqual(searchRepoUseCaseMock.executeArgValues[0].0, "test")
        XCTAssertEqual(searchRepoUseCaseMock.executeArgValues[0].1, 1)
    }
}

extension SearchRepoPresenterTests {

    func testReachedBottomWhenCannotConnected() async throws {
        // Setup
        searchRepoUseCaseMock.executeHandler = { _, _ in
            throw ApiError.cannotConnected
        }
        searchRepoState = SearchRepoState(
            isLoading: false,
            page: 2,
            searchQuery: "test",
            hasNext: false
        )

        let searchRepoPresenterImpl = SearchRepoPresenterImpl(
            state: searchRepoState,
            searchRepoUseCase: searchRepoUseCaseMock,
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
        searchRepoUseCaseMock.executeHandler = { _, _ in
            .init(hasNext: false, items: .stub)
        }
        searchRepoState = SearchRepoState(
            isLoading: false,
            page: 2,
            searchQuery: "test",
            hasNext: false
        )

        let searchRepoPresenterImpl = SearchRepoPresenterImpl(
            state: searchRepoState,
            searchRepoUseCase: searchRepoUseCaseMock,
            wireframe: searchRepoWireframeMock
        )

        // Expect no throw error.
        _ = try await searchRepoPresenterImpl.reachedBottom()

        XCTAssertEqual(searchRepoUseCaseMock.executeCallCount, 1)
        XCTAssertEqual(searchRepoUseCaseMock.executeArgValues[0].0, "test")
        XCTAssertEqual(searchRepoUseCaseMock.executeArgValues[0].1, 2)
    }
}

extension SearchRepoPresenterTests {

    func testFinishLoading() async {
        // Setup
        searchRepoState = SearchRepoState(
            isLoading: true,
            page: 1,
            searchQuery: "test",
            hasNext: true
        )
        let searchRepoPresenterImpl = SearchRepoPresenterImpl(
            state: searchRepoState,
            searchRepoUseCase: searchRepoUseCaseMock,
            wireframe: searchRepoWireframeMock
        )

        // Exercise
        await searchRepoPresenterImpl.finishLoading()

        // Verify
        let isLoading = await searchRepoPresenterImpl.state.isLoading
        XCTAssertEqual(isLoading, false)
    }
}

//extension SearchRepoPresenterTests {
//
//    func testDidSelectRow() async {
//        // Setup
//        searchRepoState = SearchRepoState(
//            isLoading: false,
//            page: 2,
//            searchQuery: "test",
//            hasNext: false
//        )
//
//        let searchRepoPresenterImpl = SearchRepoPresenterImpl(
//            state: searchRepoState,
//            searchRepoUseCase: searchRepoUseCaseMock,
//            wireframe: searchRepoWireframeMock
//        )
//
//        // Exercise
//        await searchRepoPresenterImpl.didSelect(data: )
//
//        // Verify
//        XCTAssertEqual(searchRepoWireframeMock.pushGeneralWebViewCallCount, 1)
//        XCTAssertEqual(searchRepoWireframeMock.pushGeneralWebViewArgValues[0], URL(string: "https://github.com/apple/swift")!)
//    }
//}

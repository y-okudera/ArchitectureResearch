//
//  SearchRepoPresenterTests.swift
//  
//
//  Created by Yuki Okudera on 2022/08/15.
//

@testable import Presentation
import Domain
import Infrastructure
import XCTest

final class SearchRepoPresenterTests: XCTestCase {

    private var searchRepoState: SearchRepoState!
    private var searchRepoUseCaseMock = SearchRepoUseCaseMock()
    private var searchRepoWireframeMock = SearchRepoWireframeMock()

    override func setUp() {
        searchRepoState = SearchRepoState(
            isLoading: false,
            page: 1,
            searchQuery: "",
            viewData: .init(hasNext: true, items: [])
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
            searchRepoUseCase: searchRepoUseCaseMock,
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
        searchRepoUseCaseMock.executeHandler = { _, _ in
            return .init(hasNext: true, items: .stub)
        }

        let searchRepoPresenterImpl = SearchRepoPresenterImpl(
            state: searchRepoState,
            searchRepoUseCase: searchRepoUseCaseMock,
            wireframe: searchRepoWireframeMock
        )

        // Exercise
        let result = try await searchRepoPresenterImpl.search(searchQuery: "test")

        // Verify
        XCTAssertEqual(result, true)
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
            viewData: .init(hasNext: false, items: .stub)
        )

        let searchRepoPresenterImpl = SearchRepoPresenterImpl(
            state: searchRepoState,
            searchRepoUseCase: searchRepoUseCaseMock,
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
        searchRepoUseCaseMock.executeHandler = { _, _ in
            return .init(hasNext: false, items: .stub)
        }
        searchRepoState = SearchRepoState(
            isLoading: false,
            page: 2,
            searchQuery: "test",
            viewData: .init(hasNext: false, items: .stub)
        )

        let searchRepoPresenterImpl = SearchRepoPresenterImpl(
            state: searchRepoState,
            searchRepoUseCase: searchRepoUseCaseMock,
            wireframe: searchRepoWireframeMock
        )

        // Expect no throw error.
        try await searchRepoPresenterImpl.reachedBottom()

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
            viewData: .init(hasNext: true, items: .stub)
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

extension SearchRepoPresenterTests {

    func testDidSelectRow() async {
        // Setup
        searchRepoState = SearchRepoState(
            isLoading: false,
            page: 2,
            searchQuery: "test",
            viewData: .init(hasNext: false, items: .stub)
        )

        let searchRepoPresenterImpl = SearchRepoPresenterImpl(
            state: searchRepoState,
            searchRepoUseCase: searchRepoUseCaseMock,
            wireframe: searchRepoWireframeMock
        )

        // Exercise
        await searchRepoPresenterImpl.didSelectRow(at: [0, 0])

        // Verify
        XCTAssertEqual(searchRepoWireframeMock.pushGeneralWebViewCallCount, 1)
        XCTAssertEqual(searchRepoWireframeMock.pushGeneralWebViewArgValues[0], URL(string: "https://github.com/apple/swift")!)
    }
}

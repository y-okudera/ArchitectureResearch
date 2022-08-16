//
//  SearchRepoResponse+.swift
//  
//
//  Created by Yuki Okudera on 2022/08/17.
//

@testable import Infrastructure
import XCTest

extension SearchRepoResponse {
    static var stub: Self {
        try! StubBuilder.build(assetName: "search_repositories")
    }

    func verifyEqualToStub() {
        XCTAssertEqual(self, Self.stub)
    }
}

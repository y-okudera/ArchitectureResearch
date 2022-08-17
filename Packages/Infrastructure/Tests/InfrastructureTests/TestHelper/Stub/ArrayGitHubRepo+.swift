//
//  ArrayGitHubRepo+.swift
//  
//
//  Created by Yuki Okudera on 2022/08/17.
//

@testable import Infrastructure
import Domain
import XCTest

extension Array where Element == GitHubRepo {
    func verifyEqualToStub(stub: Self = SearchRepoResponse.stub.items) {
        XCTAssertEqual(self, stub)
    }
}

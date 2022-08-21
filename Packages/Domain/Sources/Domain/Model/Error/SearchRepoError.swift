//
//  SearchRepoError.swift
//
//
//  Created by Yuki Okudera on 2022/08/22.
//

import Foundation

// MARK: - SearchRepoError
public enum SearchRepoError: Error {
    case noResults // 検索結果が0件
}

// MARK: LocalizedError
extension SearchRepoError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noResults:
            return "検索結果がありません。"
        }
    }

    public var recoverySuggestion: String? {
        switch self {
        case .noResults:
            return "検索語を変えて、再度お試しください。"
        }
    }
}

// MARK: CustomNSError
extension SearchRepoError: CustomNSError {

    /// The domain of the error.
    public static var errorDomain: String {
        "Domain.SearchRepoError"
    }

    /// The error code within the given domain.
    public var errorCode: Int {
        switch self {
        case .noResults:
            return 0
        }
    }

    /// The user-info dictionary.
    public var errorUserInfo: [String: Any] {
        switch self {
        case .noResults:
            return [:]
        }
    }
}

//
//  ApiResponse.swift
//  
//
//  Created by Yuki Okudera on 2022/08/12.
//

import Foundation

public struct ApiResponse<T: Decodable> {
    public let response: T
    public let statusCode: Int
    public let responseHeaderFields: [AnyHashable: Any]

    /// GitHub API specific property
    public let gitHubApiPagination: GitHubApiPagination?

    public init(response: T, httpURLResponse: HTTPURLResponse) {
        self.response = response
        self.statusCode = httpURLResponse.statusCode
        self.responseHeaderFields = httpURLResponse.allHeaderFields
        self.gitHubApiPagination = .init(httpURLResponse: httpURLResponse)
        log("Requested URL \(httpURLResponse.url?.absoluteString ?? "nil")")
    }
}

// MARK: GitHub API Pagination
public struct GitHubApiPagination {
    public let hasNext: Bool

    init(hasNext: Bool) {
        self.hasNext = hasNext
    }

    init(httpURLResponse: HTTPURLResponse) {
        guard let linkField = httpURLResponse.allHeaderFields["Link"] as? String else {
            self = .init(hasNext: false)
            return
        }

        let dictionary =
            linkField
            .components(separatedBy: ",")
            .reduce(into: [String: String]()) {
                let components = $1.components(separatedBy: "; ")
                let cleanPath = components[safe: 0]?.trimmingCharacters(
                    in: CharacterSet(charactersIn: " <>"))
                if let key = components[safe: 1] {
                    $0[key] = cleanPath
                }
            }

        let nextUrl: URL? = {
            guard let next = dictionary["rel=\"next\""] else {
                return nil
            }
            return URL(string: next)
        }()

#if DEBUG
        let firstUrl: URL? = {
            guard let first = dictionary["rel=\"first\""] else {
                return nil
            }
            return URL(string: first)
        }()
        let lastUrl: URL? = {
            guard let last = dictionary["rel=\"last\""] else {
                return nil
            }
            return URL(string: last)
        }()
        log("nextUrl", nextUrl?.absoluteString ?? "nil")
        log("firstUrl", firstUrl?.absoluteString ?? "nil")
        log("lastUrl", lastUrl?.absoluteString ?? "nil")
#endif

        self = .init(hasNext: nextUrl != nil)
    }
}

//
//  GitHubRepo.swift
//
//
//  Created by Yuki Okudera on 2022/09/19.
//

import Foundation

// MARK: - GitHubRepo
public struct GitHubRepo: Decodable, Hashable, Identifiable {
    public let id: Int64
    public let fullName: String
    public let description: String?
    public let stargazersCount: Int
    public let language: String?
    public let htmlUrl: URL
    public let owner: GitHubUser

    public init(
        id: Int64,
        fullName: String,
        description: String?,
        stargazersCount: Int,
        language: String?,
        htmlUrl: URL,
        owner: GitHubUser
    ) {
        self.id = id
        self.fullName = fullName
        self.description = description
        self.stargazersCount = stargazersCount
        self.language = language
        self.htmlUrl = htmlUrl
        self.owner = owner
    }
}

// MARK: - Mock
extension GitHubRepo {
    public static var mock: Self {
        .init(
            id: 44_838_949,
            fullName: "apple/swift",
            description: "The Swift Programming Language",
            stargazersCount: 60306,
            language: "C++",
            htmlUrl: URL(string: "https://github.com/apple/swift")!,
            owner: .mock
        )
    }
}

extension Array where Element == GitHubRepo {
    public static var mock: Self {
        [
            .mock,
        ]
    }
}

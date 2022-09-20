//
//  GitHubUser.swift
//
//
//  Created by Yuki Okudera on 2022/09/19.
//

import Foundation

// MARK: - GitHubUser
public struct GitHubUser: Decodable, Hashable {
    public let id: Int64
    public let login: String
    public let avatarUrl: URL
    public let htmlUrl: URL
    public let type: String

    public init(
        id: Int64,
        login: String,
        avatarUrl: URL,
        htmlUrl: URL,
        type: String
    ) {
        self.id = id
        self.login = login
        self.avatarUrl = avatarUrl
        self.htmlUrl = htmlUrl
        self.type = type
    }
}

// MARK: - Mock
extension GitHubUser {
    public static var mock: Self {
        .init(
            id: 10_639_145,
            login: "apple",
            avatarUrl: URL(string: "https://avatars.githubusercontent.com/u/10639145?v=4")!,
            htmlUrl: URL(string: "https://github.com/apple")!,
            type: "Organization"
        )
    }
}

//
//  GitHubUser.swift
//  
//
//  Created by Yuki Okudera on 2022/08/12.
//

import Foundation

public struct GitHubUser: Decodable {
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

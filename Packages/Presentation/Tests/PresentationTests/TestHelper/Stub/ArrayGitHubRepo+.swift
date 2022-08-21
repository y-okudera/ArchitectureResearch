//
//  ArrayGitHubRepo+.swift
//
//
//  Created by Yuki Okudera on 2022/08/17.
//

import Domain
import Foundation

extension Array where Element == GitHubRepo {
    static var stub: Self {
        [
            .init(
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
            ),
        ]
    }
}

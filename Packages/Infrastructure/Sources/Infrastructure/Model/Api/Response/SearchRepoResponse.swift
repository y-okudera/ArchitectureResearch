//
//  SearchRepoResponse.swift
//
//
//  Created by Yuki Okudera on 2022/08/12.
//

import Domain
import Foundation

struct SearchRepoResponse: Decodable, Equatable {
    let items: [GitHubRepo]
}

//
//  SearchRepoResponse.swift
//  
//
//  Created by Yuki Okudera on 2022/08/12.
//

import Domain
import Foundation

public struct SearchRepoResponse: Decodable {
    public let items: [GitHubRepo]
}

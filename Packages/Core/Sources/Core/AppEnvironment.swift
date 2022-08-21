//
//  AppEnvironment.swift
//
//
//  Created by Yuki Okudera on 2022/08/12.
//

import Domain
import Foundation
import Infrastructure

public protocol AppEnvironment {

    // MARK: - DataSource

    var apiRemoteDataSource: ApiRemoteDataSource { get }

    // MARK: - Repository

    var gitHubRepoRepository: GitHubRepoRepository { get }

    // MARK: - UseCase

    var searchRepoUseCase: SearchRepoUseCase { get }
}

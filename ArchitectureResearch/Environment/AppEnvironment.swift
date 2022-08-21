//
//  AppEnvironment.swift
//  ArchitectureResearch
//
//  Created by Yuki Okudera on 2022/08/12.
//

import Core
import Domain
import Infrastructure

final class Environment: AppEnvironment {

    // MARK: - DataSource

    var apiRemoteDataSource: ApiRemoteDataSource {
        ApiRemoteDataSourceImpl(urlSession: .shared)
    }

    // MARK: - Repository

    var gitHubRepoRepository: GitHubRepoRepository {
        GitHubRepoRepositoryImpl(apiRemoteDataSource: apiRemoteDataSource)
    }

    // MARK: - UseCase

    var searchRepoUseCase: SearchRepoUseCase {
        SearchRepoUseCaseImpl(gitHubRepoRepository: gitHubRepoRepository)
    }
}

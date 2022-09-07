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

    var webApiDataSource: WebApiDataSource {
        WebApiDataSourceImpl(urlSession: .shared)
    }

    var searchRepoDataSource: SearchRepoDataSource {
        SearchRepoRemoteDataSource(webApiDataSource: webApiDataSource)
    }

    // MARK: - Repository

    var gitHubRepoRepository: GitHubRepoRepository {
        GitHubRepoRepositoryImpl(remoteDataSource: searchRepoDataSource)
    }

    // MARK: - UseCase

    var searchRepoUseCase: SearchRepoUseCase {
        SearchRepoUseCaseImpl(gitHubRepoRepository: gitHubRepoRepository)
    }
}

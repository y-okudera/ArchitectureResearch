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

    private(set) lazy var searchedRepoRepository: SearchedRepoRepository = SearchedRepoRepositoryImpl(
        remoteDataSource: searchRepoDataSource,
        searchRepoRequestData: .init(searchQuery: nil, page: 0, hasNext: false) // Single instance
    )

    // MARK: - UseCase

    var searchRepoUseCase: SearchRepoUseCase {
        SearchRepoInteractor(searchedRepoRepository: searchedRepoRepository)
    }

    var loadMoreRepoUseCase: LoadMoreRepoUseCase {
        LoadMoreRepoInteractor(searchedRepoRepository: searchedRepoRepository)
    }

    var readSearchRepoRequestDataUseCase: ReadSearchRepoRequestDataUseCase {
        ReadSearchRepoRequestDataInteractor(searchedRepoRepository: searchedRepoRepository)
    }
}

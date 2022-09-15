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

    var webApiDataSource: WebApiDataSource { get }
    var searchRepoDataSource: SearchRepoDataSource { get }

    // MARK: - Repository

    var searchedRepoRepository: SearchedRepoRepository { get }

    // MARK: - UseCase

    var searchRepoUseCase: SearchRepoUseCase { get }
    var loadMoreRepoUseCase: LoadMoreRepoUseCase { get }
    var readSearchRepoDataUseCase: ReadSearchRepoDataUseCase { get }
}

//
//  SearchRepoDiffableDataSource.swift
//
//
//  Created by Yuki Okudera on 2022/08/22.
//

import Domain
import UIKit

// MARK: - SearchRepoDiffableDataSource
@MainActor
final class SearchRepoDiffableDataSource {

    init(tableView: UITableView!) {
        self.tableView = tableView
    }

    private weak var tableView: UITableView!

    private(set) lazy var dataSource: UITableViewDiffableDataSource<Section, Item> = {
        let dataSource = UITableViewDiffableDataSource<Section, Item>(tableView: tableView) { _, _, item in
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "GitHubRepoCell")

            Task {
                let contentConfiguration: UIListContentConfiguration = await {
                    var configuration = cell.defaultContentConfiguration()
                    configuration.text = item.data.fullName
                    configuration.secondaryText = item.data.description

                    let imageMaximumSize = CGSize(width: 35, height: 35)
                    configuration.imageProperties.maximumSize = imageMaximumSize
                    configuration.imageProperties.cornerRadius = imageMaximumSize.width / 2
                    configuration.image = await UIImage.load(url: item.data.owner.avatarUrl)

                    return configuration
                }()
                cell.contentConfiguration = contentConfiguration
            }
            return cell
        }
        dataSource.defaultRowAnimation = .fade
        return dataSource
    }()

    func set(data: [GitHubRepo]) {
        let snapshot: NSDiffableDataSourceSnapshot<Section, Item> = {
            var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
            snapshot.appendSections(Section.allCases)
            snapshot.appendItems(
                data.map { Item(data: $0) },
                toSection: .main
            )
            return snapshot
        }()
        dataSource.apply(snapshot)
    }

    func append(data: [GitHubRepo]) {
        let snapshot: NSDiffableDataSourceSnapshot<Section, Item> = {
            var snapshot = dataSource.snapshot()
            snapshot.appendItems(
                data.map { Item(data: $0) },
                toSection: .main
            )
            return snapshot
        }()
        dataSource.apply(snapshot)
    }
}

extension SearchRepoDiffableDataSource {
    enum Section: CaseIterable {
        case main
    }

    struct Item: Hashable {
        let id: Int
        let data: GitHubRepo

        init(data: GitHubRepo) {
            id = Int(data.id)
            self.data = data
        }
    }
}

//
//  SearchRepoViewController.swift
//  
//
//  Created by Yuki Okudera on 2022/08/12.
//

import Combine
import UIKit

final class SearchRepoViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView! {
        willSet {
            newValue.dataSource = self
            newValue.delegate = self
            newValue.keyboardDismissMode = .onDrag
        }
    }

    private var searchBar: UISearchBar!
    private(set) var presenter: SearchRepoPresenter!
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "リポジトリ検索"
        setupSearchBar()
        tableView
            .reachedBottomPublisher(offset: 100.0)
            .sink { [weak self] in self?.reachedBottom() }
            .store(in: &cancellables)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.indexPathsForSelectedRows?.forEach {
            tableView.deselectRow(at: $0, animated: true)
        }
    }

    func configure(presenter: SearchRepoPresenter) {
        self.presenter = presenter
    }
}

extension SearchRepoViewController {
    private func setupSearchBar() {
        guard let navigationBarBounds = navigationController?.navigationBar.bounds else {
            return
        }
        let searchBar = UISearchBar(frame: navigationBarBounds)
        searchBar.delegate = self
        searchBar.keyboardType = .default
        searchBar.placeholder = "リポジトリ名"

        navigationItem.titleView = searchBar
        navigationItem.titleView?.frame = searchBar.frame
        self.searchBar = searchBar
    }

    private func reachedBottom() {
        Task {
            do {
                let isEnabledLoadMore = await presenter.state.isEnabledLoadMore()
                if !isEnabledLoadMore {
                    return
                }
                showLoading(isOverlay: false)
                let loadingResult = try await presenter.reachedBottom()
                if loadingResult {
                    tableView.reloadData()
                }
                hideLoading()
            } catch {
                await showAlert(title: "エラー", message: error.localizedDescription, actionTitle: "OK")
                await presenter.finishLoading()
                reachedBottom()
            }
        }
    }
}

// MARK: - UISearchBarDelegate
extension SearchRepoViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        showLoading(isOverlay: true)
        Task {
            do {
                let searchResult = try await presenter.search(searchQuery: searchBar.text)
                if searchResult {
                    tableView.setContentOffset(.zero, animated: false)
                    tableView.reloadData()
                }
                hideLoading()
            } catch {
                await showAlert(title: "エラー", message: error.localizedDescription, actionTitle: "OK")
                await presenter.finishLoading()
                searchBarSearchButtonClicked(searchBar)
            }
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = false
        return true
    }
}

// MARK: - UITableViewDataSource
extension SearchRepoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.state.viewData.numberOfItems
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "GitHubRepoCell")

        Task {
            let contentConfiguration: UIListContentConfiguration = await {
                var configuration = cell.defaultContentConfiguration()

                let gitHubRepo = await presenter.state.viewData.items[indexPath.row]
                configuration.text = gitHubRepo.fullName
                configuration.secondaryText = gitHubRepo.description

                let imageMaximumSize = CGSize(width: 35, height: 35)
                configuration.imageProperties.maximumSize = imageMaximumSize
                configuration.imageProperties.cornerRadius = imageMaximumSize.width / 2
                configuration.image = await UIImage.load(url: gitHubRepo.owner.avatarUrl)

                return configuration
            }()
            cell.contentConfiguration = contentConfiguration
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SearchRepoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Task {
            await presenter.didSelectRow(at: indexPath)
        }
    }
}

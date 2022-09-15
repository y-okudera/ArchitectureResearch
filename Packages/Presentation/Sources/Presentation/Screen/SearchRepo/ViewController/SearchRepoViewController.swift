//
//  SearchRepoViewController.swift
//
//
//  Created by Yuki Okudera on 2022/08/12.
//

import Combine
import Domain
import UIKit

// MARK: - SearchRepoViewController
final class SearchRepoViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView! {
        willSet {
            newValue.delegate = self
            newValue.keyboardDismissMode = .onDrag
        }
        didSet {
            tableView.dataSource = searchRepoDiffableDataSource.dataSource
        }
    }

    private lazy var searchRepoDiffableDataSource = SearchRepoDiffableDataSource(tableView: self.tableView)
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
                let isEnabledLoadMore = await presenter.isEnabledLoadMore()
                if !isEnabledLoadMore {
                    return
                }
                showLoading(isOverlay: false)
                let searchResult = try await presenter.reachedBottom()
                searchRepoDiffableDataSource.append(data: searchResult)
                hideLoading()
            } catch SearchRepoError.noResults {
                let nsError = SearchRepoError.noResults as NSError
                await showAlert(title: nsError.localizedDescription, message: nsError.localizedRecoverySuggestion, actionTitle: "OK")
                await presenter.finishLoading()
                hideLoading()
            } catch {
                let nsError = error as NSError
                let result = await showConfirm(
                    title: nsError.localizedDescription,
                    message: nsError.localizedRecoverySuggestion,
                    actionTitle: "リトライ",
                    cancelActionTitle: "キャンセル"
                )
                await presenter.finishLoading()
                hideLoading()
                if result {
                    reachedBottom()
                }
            }
        }
    }
}

// MARK: UISearchBarDelegate
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
                if let searchResult = try await presenter.search(searchQuery: searchBar.text) {
                    searchRepoDiffableDataSource.set(data: searchResult)
                }
                hideLoading()
            } catch SearchRepoError.noResults {
                let nsError = SearchRepoError.noResults as NSError
                await showAlert(title: nsError.localizedDescription, message: nsError.localizedRecoverySuggestion, actionTitle: "OK")
                await presenter.finishLoading()
                hideLoading()
            } catch {
                let nsError = error as NSError
                let result = await showConfirm(
                    title: nsError.localizedDescription,
                    message: nsError.localizedRecoverySuggestion,
                    actionTitle: "リトライ",
                    cancelActionTitle: "キャンセル"
                )
                await presenter.finishLoading()
                hideLoading()
                if result {
                    searchBarSearchButtonClicked(searchBar)
                }
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

// MARK: UITableViewDelegate
extension SearchRepoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = searchRepoDiffableDataSource.dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        presenter.didSelect(data: item.data)
    }
}

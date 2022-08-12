//
//  SearchRepoViewController.swift
//  
//
//  Created by Yuki Okudera on 2022/08/12.
//

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "リポジトリ検索"
        setupSearchBar()
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
}

// MARK: - UISearchBarDelegate
extension SearchRepoViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        Task {
            do {
                let result = try await presenter.search(searchQuery: searchBar.text)
                if result {
                    tableView.setContentOffset(.zero, animated: false)
                    tableView.reloadData()
                }
            } catch {
                await showAlert(title: "エラー", message: error.localizedDescription, actionTitle: "OK")
                presenter.finishLoading()
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

// MARK: - UIScrollViewDelegate
extension SearchRepoViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleHeight = scrollView.frame.height - scrollView.contentInset.top - scrollView.contentInset.bottom
        Task {
            do {
                let result = try await presenter.didScroll(
                    offsetY: scrollView.contentOffset.y + scrollView.contentInset.top,
                    threshold: max(0.0, scrollView.contentSize.height - visibleHeight),
                    edgeOffset: 25.0
                )
                if result {
                    tableView.reloadData()
                }
            } catch {
                await showAlert(title: "エラー", message: error.localizedDescription, actionTitle: "OK")
                presenter.finishLoading()
                scrollViewDidScroll(scrollView)
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension SearchRepoViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.state.viewData.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "GitHubRepoCell")

        Task {
            let contentConfiguration: UIListContentConfiguration = await {
                var configuration = cell.defaultContentConfiguration()

                let gitHubRepo = presenter.state.viewData.items[indexPath.row]
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
        presenter.didSelectRow(at: indexPath)
    }
}

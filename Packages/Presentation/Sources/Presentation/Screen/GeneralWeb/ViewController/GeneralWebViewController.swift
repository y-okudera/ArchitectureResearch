//
//  GeneralWebViewController.swift
//
//
//  Created by Yuki Okudera on 2022/08/12.
//

import UIKit
import WebKit

// MARK: - GeneralWebViewController
final class GeneralWebViewController: UIViewController {

    @IBOutlet private weak var webView: WKWebView! {
        willSet {
            newValue.navigationDelegate = self
        }
    }

    private(set) var presenter: GeneralWebPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.load(URLRequest(url: presenter.state.initialUrl))
    }

    func configure(presenter: GeneralWebPresenter) {
        self.presenter = presenter
    }
}

extension GeneralWebViewController {
    private func reload() {
        if webView.url != nil {
            webView.reload()
        } else {
            webView.load(URLRequest(url: presenter.state.initialUrl))
        }
    }

    private func handleError(_ error: Error) {
        let nsError = error as NSError
        if nsError.domain != URLError.errorDomain || nsError.code != URLError.cancelled.rawValue {
            Task {
                await showAlert(title: "Error : \(nsError.code)", message: error.localizedDescription, actionTitle: "リトライ")
                reload()
            }
        }
    }
}

// MARK: WKNavigationDelegate
extension GeneralWebViewController: WKNavigationDelegate {
    // ページ読み込みが開始された
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showLoading(isOverlay: true)
    }

    // 読み込み開始時にエラーが発生した
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        hideLoading()
        handleError(error)
    }

    // 読み込み途中にエラーが発生した
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hideLoading()
        handleError(error)
    }

    // 読み込みが完了した
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideLoading()
    }
}

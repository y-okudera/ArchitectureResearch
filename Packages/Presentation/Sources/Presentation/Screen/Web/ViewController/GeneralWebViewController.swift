//
//  GeneralWebViewController.swift
//  
//
//  Created by Yuki Okudera on 2022/08/12.
//

import UIKit
import WebKit

final class GeneralWebViewController: UIViewController {

    @IBOutlet private weak var webView: WKWebView!

    private(set) var presenter: GeneralWebPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.load(URLRequest(url: presenter.state.initialUrl))
    }

    func configure(presenter: GeneralWebPresenter) {
        self.presenter = presenter
    }
}

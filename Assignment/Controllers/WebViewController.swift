//
//  WebViewController.swift
//  Assignment
//
//  Created by Nitin Singh on 12/05/21.
//

import UIKit
import WebKit

class WebViewController: UIViewController,WKUIDelegate, UIGestureRecognizerDelegate {
    @IBOutlet weak fileprivate var activityIndicator: UIActivityIndicatorView!
    fileprivate var webView: WKWebView!
    @IBOutlet weak var navView: UIView!
     public var urlString: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        setupWebView()
        loadWebViewRequest()
        self.title = ""
    }
    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    fileprivate func setupWebView() {
        let contentController = WKUserContentController()
        let webViewConfig = WKWebViewConfiguration()
        webViewConfig.userContentController = contentController
        let webViewFrame = CGRect(x: 0,
                                  y: navView.frame.height,
                                  width: view.frame.width,
                                  height: view.frame.height - navView.frame.height)
        webView = WKWebView(frame: webViewFrame, configuration: webViewConfig)
        view.addSubview(webView)
        view.sendSubviewToBack(webView)
    }
    
    fileprivate func loadWebViewRequest() {
        let url = URL(string: urlString)
        let request = URLRequest(url: url!)
        webView.load(request)
    }

}
extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        // Get details from navigationAction.request and decide what to do in regular/success/error case
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if activityIndicator.isAnimating {
            activityIndicator.stopAnimating()
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        handleWebViewError(error: error)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        handleWebViewError(error: error)
    }
    
    fileprivate func handleWebViewError(error: Error) {
        // Probaly show an alert and remove the webview controller
        print("Web view error: \(error)")
    }
}

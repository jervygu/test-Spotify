//
//  WebViewController.swift
//  Spotify-test
//
//  Created by Jervy Umandap on 9/3/21.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    
    var artistURL: URL? = nil
     
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
//        let myURL = URL(string:"https://www.apple.com")
        guard let myURL = artistURL else {
            return
        }
        let myRequest = URLRequest(url: myURL)
        webView.load(myRequest)
    }
    
    
    
}

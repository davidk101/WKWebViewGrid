//
//  ViewController.swift
//  wkwebviewgrid
//
//  Created by David Kumar on 7/24/21.
//

import Cocoa
import WebKit

class ViewController: NSViewController, WKNavigationDelegate {
    // every wkwebview must have a Core Animation layer behind it since macOS does not have that already
    
    var rows: NSStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create the stackView and add it to view
        rows = NSStackView()
        rows.orientation = .vertical
        rows.distribution = .fillEqually
        rows.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rows)
    
        // create auto layout constraints
        rows.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        rows.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        rows.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        rows.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        // create initial column with web view
        let column = NSStackView(views: [makeWebView()])
        column.distribution = .fillEqually
        
        // add column to rows stack view
        rows.addArrangedSubview(column)

    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func urlEntered(_ sender: NSTextField) {

        
    }
    
    @IBAction func navigationClicked(_ sender: NSSegmentedControl) {
        

        
    }
    
    @IBAction func adjustRows(_ sender: NSSegmentedControl) {
        

    }
    
    @IBAction func adjustColumns(_ sender: NSSegmentedControl) {

            
        }
        
    func makeWebView() -> NSView {
            
        let webView = WKWebView()
        webView.navigationDelegate = self
        webView.wantsLayer = true // for the added CA layer
        webView.load(URLRequest(url: URL(string: "https://www.davidkumar.tech")!)) // app transport security exemption may be needed here 
            
        return webView
            
    }
}


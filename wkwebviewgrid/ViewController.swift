//
//  ViewController.swift
//  wkwebviewgrid
//
//  Created by David Kumar on 7/24/21.
//

import Cocoa
import WebKit

class ViewController: NSViewController, WKNavigationDelegate, NSGestureRecognizerDelegate {
    
    // every wkwebview must have a Core Animation layer behind it since macOS does not have that already
    
    var rows: NSStackView!
    var selectedWebView: WKWebView!

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
        
        if sender.selectedSegment == 0 { // add row
                    
            // count how many columns we have so far
            let columnCount = (rows.arrangedSubviews[0] as! NSStackView).arrangedSubviews.count
            
            // make a new array of web views that contain the correct number of columns
            let viewArray = (0 ..< columnCount).map { _ in makeWebView() }

            // use that web view to create a new stack view
            let row = NSStackView(views: viewArray)

            row.distribution = .fillEqually
            rows.addArrangedSubview(row)
            
        } else {
            //ensure at least two rows
            guard rows.arrangedSubviews.count > 1 else {
                return
            }
            // pull out the final row, and make sure its a stack view
            guard let rowToRemove = rows.arrangedSubviews.last as? NSStackView else { return }
            // remove webview from screemn
            for cell in rowToRemove.arrangedSubviews {
                cell.removeFromSuperview()
                
            }
            // remove the whole stack view row
            rows.removeArrangedSubview(rowToRemove)
        }
    }
    
    @IBAction func adjustColumns(_ sender: NSSegmentedControl) {
        
        if sender.selectedSegment == 0 { // add column
            for case let row as NSStackView in rows.arrangedSubviews {
                row.addArrangedSubview(makeWebView())
            }
        }
        else { // remove column
            guard let firstRow = rows.arrangedSubviews.first as? NSStackView else {
                return
            }
            // ensure tow columns
            guard firstRow.arrangedSubviews.count > 1 else { return }
            // safe to delete a column
            for case let row as NSStackView in rows.arrangedSubviews {
                // loop over every row
                if let last = row.arrangedSubviews.last {
                    // remove lst web view in the column
                    row.removeView(last)
                    last.removeFromSuperview()
                }
            }
        }
    }
        
    func makeWebView() -> NSView {
            
        let webView = WKWebView()
        webView.navigationDelegate = self
        webView.wantsLayer = true // for the added CA layer
        webView.load(URLRequest(url: URL(string: "https://www.davidkumar.tech")!)) // app transport security exemption may be needed here
        
        // add gesture recognizer delegate 
        let recognizer = NSClickGestureRecognizer(target: self, action: #selector(webViewClicked))
        recognizer.delegate = self
        webView.addGestureRecognizer(recognizer)
        
        if selectedWebView == nil {
            select(webView: webView)
        }
            
        return webView
            
    }
    
    func select(webView: WKWebView) {
        
        selectedWebView = webView
        selectedWebView.layer?.borderWidth = 2
        selectedWebView.layer?.borderColor = NSColor.green.cgColor
        
    }
    
    @objc func webViewClicked(recognizer: NSClickGestureRecognizer) {
        
        // get the web view that triggered the gesture recoginzer
        guard let newSelectedWebView = recognizer.view as? WKWebView else { return }
        // deselect the currently selected web view if there is one
        if let selected = selectedWebView {
            selected.layer?.borderWidth = 0
        }
        // select the new view
        select(webView: newSelectedWebView)
        
    }
}


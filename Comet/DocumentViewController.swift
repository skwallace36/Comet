//
//  DocumentViewController.swift
//  Comet
//
//  Created by Stuart Wallace on 5/3/22.
//

import AppKit

class DocumentViewController: ChildViewController {
    
    let splitButtonV = NSButton()
    let splitButtonH = NSButton()
    weak var documentViewControllerSplitter: DocumentViewControllerSplitter?
    
    init(id: String) {
        super.init(nibName: nil, bundle: nil)
        view.identifier = .init(rawValue: id)
    }
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view.wantsLayer = true
        view.layer?.backgroundColor = .random
        view.translatesAutoresizingMaskIntoConstraints = false
        activateConstraints()
        
        splitButtonV.translatesAutoresizingMaskIntoConstraints = false
        splitButtonV.title = "V"
        splitButtonH.translatesAutoresizingMaskIntoConstraints = false
        splitButtonH.title = "H"
        let splitVClick = NSClickGestureRecognizer(target: self, action: #selector(splitVClicked))
        let splitHClick = NSClickGestureRecognizer(target: self, action: #selector(splitHClicked))
        splitButtonV.addGestureRecognizer(splitVClick)
        splitButtonH.addGestureRecognizer(splitHClick)
        view.addSubview(splitButtonV)
        view.addSubview(splitButtonH)
        NSLayoutConstraint.activate([
            splitButtonV.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            splitButtonV.bottomAnchor.constraint(equalTo: view.centerYAnchor),
            splitButtonV.widthAnchor.constraint(equalToConstant: 30),
            splitButtonV.heightAnchor.constraint(equalToConstant: 30),
            splitButtonH.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            splitButtonH.topAnchor.constraint(equalTo: view.centerYAnchor),
            splitButtonH.widthAnchor.constraint(equalToConstant: 30),
            splitButtonH.heightAnchor.constraint(equalToConstant: 30)
        ])
        
    }
    
    @objc func splitVClicked() {
        documentViewControllerSplitter?.split(self, .Vertically)
    }
    
    
    @objc func splitHClicked() {
        documentViewControllerSplitter?.split(self, .Horizontally)
    }
}

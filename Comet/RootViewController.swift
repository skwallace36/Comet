//
//  ViewController.swift
//  Comet
//
//  Created by Stuart Wallace on 4/29/22.
//

import Cocoa

class RootViewController: NSViewController {
   
    var sidebarViewController: SidebarViewController?
    var initialDocument: DocumentViewController?
    var splitDocumentBottom: DocumentViewController?
    
    var items = [ChildViewController]()
    var numDocs = 1
    

    init() { super.init(nibName: nil, bundle: nil) }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = NSView(frame: NSMakeRect(0.0, 0.0, 0, 0))
        sidebarViewController = SidebarViewController(nibName: nil, bundle: nil)
        initialDocument = DocumentViewController(id: "doc: \(numDocs)")
        numDocs += 1
        initialDocument?.documentViewControllerSplitter = self
        splitDocumentBottom = DocumentViewController(id: "bottom doc")
        splitDocumentBottom?.documentViewControllerSplitter = self
        guard let sidebarViewController = sidebarViewController else { return }
        guard let initialDocument = initialDocument else { return }
//        let splitDocumentBottom = splitDocumentBottom else { return}

//        items.append(contentsOf: [sidebarViewController, initialDocument, splitDocumentBottom])
        items.append(contentsOf: [sidebarViewController, initialDocument])
        sidebarViewController.rightNeighbors.append(initialDocument)
        initialDocument.leftNeighbors.append(sidebarViewController)
//        initialDocument.bottomNeighbors.append(splitDocumentBottom)
//        splitDocumentBottom.leftNeighbors.append(sidebarViewController)
//        splitDocumentBottom.topNeighbors.append(initialDocument)
        items.forEach {
            addChild($0)
            view.addSubview($0.view)
        }

        sidebarViewController.leftConstraint = sidebarViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor)
        sidebarViewController.rightConstraint = sidebarViewController.view.rightAnchor.constraint(equalTo: initialDocument.view.leftAnchor)
        sidebarViewController.topConstraint = sidebarViewController.view.topAnchor.constraint(equalTo: view.topAnchor)
        sidebarViewController.bottomConstraint = sidebarViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        initialDocument.leftConstraint = initialDocument.view.leftAnchor.constraint(equalTo: sidebarViewController.view.rightAnchor)
        initialDocument.rightConstraint = initialDocument.view.rightAnchor.constraint(equalTo: view.rightAnchor)
        initialDocument.topConstraint = initialDocument.view.topAnchor.constraint(equalTo: view.topAnchor)
        initialDocument.bottomConstraint = initialDocument.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        splitDocumentBottom.leftConstraint = splitDocumentBottom.view.leftAnchor.constraint(equalTo: sidebarViewController.view.rightAnchor)
//        splitDocumentBottom.rightConstraint = splitDocumentBottom.view.rightAnchor.constraint(equalTo: view.rightAnchor)
//        splitDocumentBottom.topConstraint = splitDocumentBottom.view.topAnchor.constraint(equalTo: initialDocument.view.bottomAnchor)
//        splitDocumentBottom.bottomConstraint = splitDocumentBottom.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        [sidebarViewController, initialDocument, splitDocumentBottom].forEach { $0.activateConstraints() }
        [sidebarViewController, initialDocument].forEach { $0.activateConstraints() }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        // view.window?.zoom(self)
        
        guard let sidebarViewController = sidebarViewController else { return }
        guard let initialDocument = initialDocument else { return}
        sidebarViewController.heightConstraint = sidebarViewController.view.heightAnchor.constraint(equalToConstant: view.frame.height)
        sidebarViewController.widthConstraint = sidebarViewController.view.widthAnchor.constraint(equalToConstant: view.frame.width/2)
        initialDocument.heightConstraint = initialDocument.view.heightAnchor.constraint(equalToConstant: view.frame.height)
        initialDocument.widthConstraint = initialDocument.view.widthAnchor.constraint(equalToConstant: view.frame.width/2)
        sidebarViewController.activateConstraints()
        initialDocument.activateConstraints()
    }
    
    
    func mouseMoved(event: NSEvent) {
        children.forEach { ($0 as? ChildViewController)?.mouseState?.mouseLocation(location: event.locationInWindow) }
    }
    
    func leftMouseDown(event: NSEvent) {
        children.forEach { ($0 as? ChildViewController)?.mouseState?.leftMouseDown(location: event.locationInWindow) }
    }
    
    func leftMouseUp(event: NSEvent) {
        children.forEach { ($0 as? ChildViewController)?.mouseState?.leftMouseUp(location: event.locationInWindow) }
    }
    
    func leftMouseDragged(event: NSEvent) {
        children.forEach { ($0 as? ChildViewController)?.mouseState?.leftMouseDragged(location: event.locationInWindow, event: event) }
    }
}

extension RootViewController: DocumentViewControllerSplitter {
    func split(_ document: DocumentViewController, _ direction: DocumentSplitDirection) {
        switch direction {
        case .Vertically:
            print("split v")
        case .Horizontally:
            print(document.view.frame)
            // exisiting document
            // ------------------
            // new document
            let newDocument = DocumentViewController(id: "doc: \(numDocs)")
            newDocument.documentViewControllerSplitter = self
            numDocs += 1
            guard let newBottomAnchor = document.bottomConstraint?.secondAnchor as? NSLayoutAnchor<NSLayoutYAxisAnchor> else { return }
            guard let newLeftAnchor = document.leftConstraint?.secondAnchor as? NSLayoutAnchor<NSLayoutXAxisAnchor> else { return }
            guard let newRightAnchor = document.rightConstraint?.secondAnchor as? NSLayoutAnchor<NSLayoutXAxisAnchor> else { return }
            guard let documentHeight = document.heightConstraint?.constant else { return }
            guard let newWidth = document.widthConstraint?.constant else { return }
            items.append(newDocument)
            addChild(newDocument)
            view.addSubview(newDocument.view)
            newDocument.leftConstraint = newDocument.view.leftAnchor.constraint(equalTo: newLeftAnchor)
            newDocument.rightConstraint = newDocument.view.rightAnchor.constraint(equalTo: newRightAnchor)
            newDocument.topConstraint = newDocument.view.topAnchor.constraint(equalTo: document.view.bottomAnchor)
            newDocument.bottomConstraint = newDocument.view.bottomAnchor.constraint(equalTo: newBottomAnchor)
            newDocument.heightConstraint = newDocument.view.heightAnchor.constraint(equalToConstant: documentHeight / 2.0)
            newDocument.widthConstraint = newDocument.view.widthAnchor.constraint(equalToConstant: newWidth)
            document.heightConstraint?.constant = documentHeight / 2.0
            document.bottomConstraint?.isActive = false
            document.bottomConstraint = document.view.bottomAnchor.constraint(equalTo: newDocument.view.topAnchor)
            document.bottomConstraint?.isActive = true
            document.bottomNeighbors.forEach { bottomNeighbor in
                bottomNeighbor.topConstraint?.isActive = false
                bottomNeighbor.topConstraint = bottomNeighbor.view.topAnchor.constraint(equalTo: newDocument.view.bottomAnchor)
                bottomNeighbor.topConstraint?.isActive = true
            }
            document.activateConstraints()
            newDocument.activateConstraints()
            newDocument.bottomNeighbors = document.bottomNeighbors
            document.bottomNeighbors = [newDocument]
        }
    }
}
// print(items.forEach { print(" \($0.view.identifier) \($0.heightConstraint?.constant)" ) })

enum DocumentSplitDirection {
    case Vertically
    case Horizontally
}

protocol DocumentViewControllerSplitter: AnyObject {
    func split(_ document: DocumentViewController, _ direction: DocumentSplitDirection)
}

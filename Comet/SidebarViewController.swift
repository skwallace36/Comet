//
//  SidebarViewController.swift
//  Comet
//
//  Created by Stuart Wallace on 4/29/22.
//

import Foundation


import AppKit

import Combine

class SidebarViewController: ChildViewController {
    
    
    
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        view.identifier = .init(rawValue: "sidebar view")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view.wantsLayer = true
        view.layer?.backgroundColor = .random
    }
    
    override func viewWillLayout() {
        super.viewWillLayout()
    }
}


extension CGColor {
    class var random: CGColor {
        return CGColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1.0)
    }
}

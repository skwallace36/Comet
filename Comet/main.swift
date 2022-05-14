//
//  main.swift
//  Comet
//
//  Created by Stuart Wallace on 4/29/22.
//

import AppKit

// 1
let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate

// 2
_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)

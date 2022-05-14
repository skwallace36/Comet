//
//  AppDelegate.swift
//  Comet
//
//  Created by Stuart Wallace on 4/29/22.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {

    
    private var window: NSWindow!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
//        NSScreen.screens.enumerated().forEach { print("screen \($0) size: \($1.frame.size)") }
        let screen = NSScreen.screens.last ?? NSScreen.main
//        window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 1, height: 1), styleMask: [.miniaturizable, .closable, .resizable, .titled], backing: .buffered, defer: false, screen: screen)
        window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 800, height: 600), styleMask: [.miniaturizable, .closable, .resizable, .titled], backing: .buffered, defer: false, screen: screen)
        let rootViewController = RootViewController()
        window.contentView = rootViewController.view
        window.makeKeyAndOrderFront(nil)

        
        NSEvent.addLocalMonitorForEvents(matching: .mouseMoved) { event in
            rootViewController.mouseMoved(event: event)
            return event
        }
        
        NSEvent.addLocalMonitorForEvents(matching: .leftMouseDragged, handler: { event in
            rootViewController.leftMouseDragged(event: event)
            return event
            
        })
        
        NSEvent.addLocalMonitorForEvents(matching: .leftMouseDown, handler: { event in
            rootViewController.leftMouseDown(event: event)
            return event
        })
        
        NSEvent.addLocalMonitorForEvents(matching: .leftMouseUp, handler: { event in
            rootViewController.leftMouseUp(event: event)
            return event
        })
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

}

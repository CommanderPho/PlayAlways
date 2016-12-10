//
//  AppRouter.swift
//  PlayAways
//
//  Created by Guilherme Rambo on 08/12/16.
//  Copyright © 2016 Guilherme Rambo. All rights reserved.
//

import Cocoa

final class AppRouter {
    
    private let statusItemController: StatusItemController
    private let playgroundMaker: PlaygroundMaker
    private let persistence: PersistenceHelper
    
    init(statusItemController: StatusItemController, playgroundMaker: PlaygroundMaker, persistence: PersistenceHelper) {
        self.statusItemController = statusItemController
        self.playgroundMaker = playgroundMaker
        self.persistence = persistence
    }
    
    func createPlayground(with options: MenuOptions) {
        let platform: PlaygroundPlatform
        var showOptions = false
        
        switch options {
        case .iOS:
            platform = .iOS
        case .iOSWithPanel:
            platform = .iOS
            showOptions = true
        case .macOS:
            platform = .macOS
        case .macOSWithPanel:
            platform = .macOS
            showOptions = true
        case .tvOS:
            platform = .tvOS
        case .tvOSWithPanel:
            platform = .tvOS
            showOptions = true
        }
        
        if showOptions {
            let panel = NSSavePanel()

            let titleFormat = NSLocalizedString("New %@ Playground", comment: "New [platform name] Playground")
            panel.title = String(format: titleFormat, platform.rawValue)
            
            panel.prompt = NSLocalizedString("Create", comment: "Create playground (button title)")
            
            guard panel.runModal() == NSFileHandlingPanelOKButton else {
                // cancelled
                return
            }
            
            guard let url = panel.url else { return }
            
            createPlayground(for: platform, at: url, usingDefaultName: false)
        } else {
            let url = storageLocationShowingPanelIfNeeded()
            
            createPlayground(for: platform, at: url, usingDefaultName: true)
        }
        
    }
    
    private func createPlayground(for platform: PlaygroundPlatform, at location: URL?, usingDefaultName defaultName: Bool) {
        var playgroundUrl: URL?
        
        guard let location = location else {
            // cancelled
            return
        }
        
        let directory = defaultName ? location.path : location.deletingLastPathComponent().path
        
        let name: String?
        
        if defaultName {
            name = nil
        } else {
            name = location.deletingPathExtension().lastPathComponent
        }
        
        do {
            playgroundUrl = try playgroundMaker.createPlayground(named: name, at: directory, platform: platform)
        } catch {
            handle(error)
        }
        
        if let url = playgroundUrl {
            NSWorkspace.shared().open(url)
        }
    }
    
    func storageLocationShowingPanelIfNeeded(force: Bool = false) -> URL? {
        if let path = persistence.storagePath, !force {
            return URL(fileURLWithPath: path)
        } else {
            let url = runStorageLocationPanel()
            persistence.storagePath = url?.path
            
            return url
        }
    }
    
    private func runStorageLocationPanel() -> URL? {
        let panel = NSOpenPanel()
        
        panel.prompt = NSLocalizedString("Select", comment: "Select (open panel button to set storage location)")
        panel.canChooseDirectories = true
        panel.canCreateDirectories = true
        panel.canChooseFiles = false
        panel.title = NSLocalizedString("Select a location to create playgrounds into", comment: "Select a location to create playgrounds into")
        
        if panel.runModal() != NSFileHandlingPanelOKButton {
            return nil
        } else {
            return panel.url
        }
    }
    
    private func handle(_ error: Error) {
        NSAlert(error: error).runModal()
    }
    
}

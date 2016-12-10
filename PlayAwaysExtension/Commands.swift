//
//  Commands.swift
//  PlayAwaysExtension
//
//  Created by Guilherme Rambo on 10/12/16.
//  Copyright © 2016 Guilherme Rambo. All rights reserved.
//

import Foundation
import XcodeKit
import PACore

class EmbeddedCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        PAInvocation.invoke(with: invocation.buffer.completeBuffer, platform: .iOS)
        
        completionHandler(nil)
    }
    
}

class MacCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        PAInvocation.invoke(with: invocation.buffer.completeBuffer, platform: .macOS)
        
        completionHandler(nil)
    }
    
}

class TVCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        PAInvocation.invoke(with: invocation.buffer.completeBuffer, platform: .tvOS)
        
        completionHandler(nil)
    }
    
}

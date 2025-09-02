//
//  websiteblockerprotocol.swift
//  drug-plug
//
//  Created by Morris Romagnoli on 31/08/2025.
//

import SwiftUI
import Combine

protocol WebsiteBlockerServiceProtocol: ObservableObject {
    var isBlocking: Bool { get set }
    var isEnabled: Bool { get set }
    var blockedWebsites: [String] { get set }
    
    func blockWebsites()
    func unblockAll()
    func breakMode()
    func addWebsiteToBlockList(_ website: String)
    func removeWebsiteFromBlockList(_ website: String)
    func updateBlockedWebsites(from text: String)
}
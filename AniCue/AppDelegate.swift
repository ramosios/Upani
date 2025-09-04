//
//  AppDelegate.swift
//  AniCue
//
//  Created by Jorge Ramos on 06/07/25.
//

import UIKit
import SwiftUICore
import OSLog

class AppDelegate: NSObject, UIApplicationDelegate {
    @ObservedObject var animeList = AnimeListManager.shared
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.example.unknown", category: "AppDelegate")
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        return true
    }
}

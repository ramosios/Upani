//
//  DownloadedAnimesFileNames.swift
//  AniCue
//
//  Created by Jorge Ramos on 23/08/25.
//
import Foundation

struct DownloadedAnimesFileNames {
    static let fileNames: [String] = {
        var names: [String] = []
        for i in stride(from: 1, to: 12001, by: 400) {
            let start = i
            let end = i + 399
            names.append("top_\(start)-\(end)_anime")
        }
        return names
    }()
}

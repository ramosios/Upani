//
//  UserPreferences.swift
//  AniCue
//
//  Created by Jorge Ramos on 16/06/25.
//
import Foundation

struct UserPreferences: Codable {
    var answers: [String]
}

private func dateRange(for releasePref: String) -> (String, String) {
    switch releasePref {
    case "recent":
        return ("2023-01-01", "2025-04-01")
    case "2022-2010":
        return ("2010-01-01", "2022-12-31")
    case "2000s":
        return ("2000-01-01", "2009-12-31")
    case "1990s or earlier":
        return ("1990-01-01", "1999-12-31")
    default:
        return ("", "")
    }
}

private func normalizedFormat(for includeMovies: String) -> String {
    switch includeMovies {
    case "no":
        return "TV"
    case "yes":
        return ""
    default:
        return ""
    }
}

func formatUserPreference(from answers: [String]) -> (startDate: String, endDate: String, format: String, minimumScore: Double) {
    guard answers.count >= 3 else {
        return ("", "", "", 5.0)
    }

    let releasePref = answers[0].lowercased()
    let includeMovies = answers[1].lowercased()
    let minimunScore = Double(answers[2]) ?? 5.0

    let dateRangeResult = dateRange(for: releasePref)
    let formatResult = normalizedFormat(for: includeMovies)

    return (dateRangeResult.0, dateRangeResult.1, formatResult, minimunScore)
}

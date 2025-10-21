import Foundation

struct Constants {
    static let resultsPrompt = 50
    static let resultsMatch = 200
    static let minimumFilterScore = 5.0
    static let menuItem = [
        MenuItem(name: "Matching", imageName: "UpaniBackground_Image3"),
        MenuItem(name: "Search", imageName: "UpaniBackground_Image3")
    ]
    static let matchingMenuItem = [
        MenuItem(name: "Best Rated", imageName: "UpaniBackground_Image3"),
        MenuItem(name: "Popular", imageName: "UpaniBackground_Image3"),
        MenuItem(name: "Romance", imageName: "UpaniBackground_Image3"),
        MenuItem(name: "Shounen", imageName: "UpaniBackground_Image3"),
        MenuItem(name: "Shoujo", imageName: "UpaniBackground_Image3"),
        MenuItem(name: "Seinen", imageName: "UpaniBackground_Image3"),
        MenuItem(name: "Sports", imageName: "UpaniBackground_Image3"),
        MenuItem(name: "Comedy", imageName: "UpaniBackground_Image3"),
        MenuItem(name: "Ecchi", imageName: "UpaniBackground_Image3")
    ]
    static let userPrefQuestions: [(question: String, icon: String)] = [
           ("Which release period are you looking for in anime?", "calendar"),
           ("Should Movies and OVAs be included in your results?", "magnifyingglass"),
           ("Set the minimum score for your recommendations", "star")
       ]

       static let userPrefOptions: [[String]] = [
           ["Recent", "2022-2010", "2000s", "1990s or earlier", "No preference"],
           ["Yes", "No"]
       ]

       static let userPrefExplanations: [String] = [
           "Select the time period of anime releases you are interested in.",
           "Choose whether to include Movies and OVAs in your search results.",
           "Anime below your selected score will not be recommended."
       ]
    static let genreDictionary: [String: Int] = [
        "Action": 1,
        "Adventure": 2,
        "Comedy": 4,
        "Avant Garde": 5,
        "Mystery": 7,
        "Drama": 8,
        "Ecchi": 9,
        "Fantasy": 10,
        "Hentai": 12,
        "Historical": 13,
        "Horror": 14,
        "Kids": 15,
        "Martial Arts": 17,
        "Mecha": 18,
        "Music": 19,
        "Parody": 20,
        "Samurai": 21,
        "Romance": 22,
        "School": 23,
        "Sci-Fi": 24,
        "Shoujo": 25,
        "Girls Love": 26,
        "Shounen": 27,
        "Boys Love": 28,
        "Space": 29,
        "Sports": 30,
        "Super Power": 31,
        "Vampire": 32,
        "Harem": 35,
        "Slice of Life": 36,
        "Supernatural": 37,
        "Military": 38,
        "Detective": 39,
        "Psychological": 40,
        "Suspense": 41,
        "Seinen": 42,
        "Josei": 43,
        "Award Winning": 46,
        "Gourmet": 47,
        "Workplace": 48,
        "Erotica": 49,
        "Adult Cast": 50,
        "Anthropomorphic": 51,
        "CGDCT": 52,
        "Childcare": 53,
        "Combat Sports": 54,
        "Delinquents": 55,
        "Educational": 56,
        "Gag Humor": 57,
        "Gore": 58,
        "High Stakes Game": 59,
        "Idols (Female)": 60,
        "Idols (Male)": 61,
        "Isekai": 62,
        "Iyashikei": 63,
        "Love Polygon": 64,
        "Magical Sex Shift": 65,
        "Mahou Shoujo": 66,
        "Medical": 67,
        "Mythopoeia": 68,
        "Organized Crime": 69,
        "Otaku Culture": 70,
        "Performing Arts": 71,
        "Pets": 72,
        "Reincarnation": 73,
        "Reverse Harem": 74,
        "Romantic Subtext": 75,
        "Showbiz": 76,
        "Survival": 77,
        "Team Sports": 78,
        "Time Travel": 79,
        "Video Game": 80,
        "Visual Arts": 81,
        "Racing": 3,
        "Strategy Game": 11
    ]
}

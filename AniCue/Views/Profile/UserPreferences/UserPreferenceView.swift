import SwiftUI

struct UserPreferenceView: View {
    @ObservedObject var viewModel = UserPreferencesViewModel.shared
    @State private var showingHelpIndex: Int?

    private let questions = [
        ("Which release period are you looking for in anime?", "calendar"),
        ("Should Movies and OVAs be included in your results?", "magnifyingglass"),
        ("Set the minimum score for your recommendations", "star")
    ]

    private let options: [[String]] = [
        ["Recent", "2022-2010", "2000s", "1990s or earlier", "No preference"],
        ["Yes", "No"]
    ]

    private let explanations = [
        "Select the time period of anime releases you are interested in.",
        "Choose whether to include Movies and OVAs in your search results.",
        "Anime below your selected score will not be recommended."
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Q1
                    PreferenceQuestionView(
                        icon: questions[0].1,
                        question: questions[0].0,
                        explanation: explanations[0],
                        options: options[0],
                        selectedAnswer: $viewModel.selectedAnswers[0],
                        showingHelp: Binding(
                            get: { showingHelpIndex == 0 },
                            set: { showingHelpIndex = $0 ? 0 : nil }
                        ),
                        onSelect: { _ in viewModel.saveAnswers() }
                    )

                    // Q2
                    PreferenceQuestionView(
                        icon: questions[1].1,
                        question: questions[1].0,
                        explanation: explanations[1],
                        options: options[1],
                        selectedAnswer: $viewModel.selectedAnswers[1],
                        showingHelp: Binding(
                            get: { showingHelpIndex == 1 },
                            set: { showingHelpIndex = $0 ? 1 : nil }
                        ),
                        onSelect: { _ in viewModel.saveAnswers() }
                    )

                    // Slider
                    MinimumScoreSliderView(
                        icon: questions[2].1,
                        question: questions[2].0,
                        explanation: explanations[2],
                        minimumScore: $viewModel.minimumScore,
                        showingHelp: Binding(
                            get: { showingHelpIndex == 2 },
                            set: { showingHelpIndex = $0 ? 2 : nil }
                        )
                    )
                }
                .padding()
            }
            .navigationTitle("Your Preferences")
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
        }
        // Global tap to dismiss all 
        .contentShape(Rectangle())
        .simultaneousGesture(
            TapGesture().onEnded {
                showingHelpIndex = nil
            }
        )
    }
}

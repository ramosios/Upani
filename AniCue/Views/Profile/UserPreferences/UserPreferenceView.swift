import SwiftUI

struct UserPreferenceView: View {
    @ObservedObject var viewModel = UserPreferencesViewModel.shared
    @State private var showingHelpIndex: Int?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Q1
                    PreferenceQuestionView(
                        icon: Constants.userPrefQuestions[0].icon,
                        question: Constants.userPrefQuestions[0].question,
                        explanation: Constants.userPrefExplanations[0],
                        options: Constants.userPrefOptions[0],
                        selectedAnswer: $viewModel.selectedAnswers[0],
                        showingHelp: Binding(
                            get: { showingHelpIndex == 0 },
                            set: { showingHelpIndex = $0 ? 0 : nil }
                        ),
                        onSelect: { _ in viewModel.saveAnswers() }
                    )

                    // Q2
                    PreferenceQuestionView(
                        icon: Constants.userPrefQuestions[1].icon,
                        question: Constants.userPrefQuestions[1].question,
                        explanation: Constants.userPrefExplanations[1],
                        options: Constants.userPrefOptions[1],
                        selectedAnswer: $viewModel.selectedAnswers[1],
                        showingHelp: Binding(
                            get: { showingHelpIndex == 1 },
                            set: { showingHelpIndex = $0 ? 1 : nil }
                        ),
                        onSelect: { _ in viewModel.saveAnswers() }
                    )

                    // Slider
                    MinimumScoreSliderView(
                        icon: Constants.userPrefQuestions[2].icon,
                        question: Constants.userPrefQuestions[2].question,
                        explanation: Constants.userPrefExplanations[2],
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
        .contentShape(Rectangle())
        .simultaneousGesture(
            TapGesture().onEnded {
                showingHelpIndex = nil
            }
        )
    }
}

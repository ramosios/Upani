import SwiftUI

struct DiscoverView: View {
    @StateObject private var viewModel = DiscoverViewModel()
    @ObservedObject var animeList = AnimeListManager.shared
    @State private var prompt = ""
    @State private var submittedPrompt: String?
    @FocusState private var inputIsFocused: Bool
    @State private var profileImage: UIImage?

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        if let error = viewModel.errorMessage {
                            ErrorBanner(message: error)
                                .padding(.horizontal)
                        }

                        if let prompt = submittedPrompt, !viewModel.isLoading, !viewModel.animes.isEmpty {
                            UserPromptView(prompt: prompt, profileImage: profileImage)
                        }

                        if viewModel.isLoading {
                            UpaniAnimation()
                                .padding(.top, 200)
                        } else if viewModel.noRecommendations {
                            Image("UpaniEmptyResults")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 240)
                                .padding(.top, 40)
                                .opacity(0.7)
                        } else {
                            AnimeListView(animes: viewModel.animes, source: .discover)
                        }
                    }
                    .padding(.vertical)
                }
                .onTapGesture {
                    inputIsFocused = false
                }
                .navigationBarTitleDisplayMode(.inline)

                if !viewModel.isLoading && viewModel.animes.isEmpty && !inputIsFocused {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Try one of these prompts")
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(SuggestedPrompts.randomThree()) { suggestion in
                                    Button(action: {
                                        prompt = suggestion.text
                                        sendPrompt()
                                    }, label: {
                                        HStack {
                                            Image(systemName: suggestion.iconName)
                                            Text(suggestion.text)
                                        }
                                        .font(.subheadline)
                                        .padding()
                                        .background(.thinMaterial)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                    })
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.bottom, 8)
                }

                ChatInputBarView(
                    text: $prompt,
                    isFocused: $inputIsFocused,
                    action: sendPrompt
                )
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
        }
        .onAppear(perform: loadProfileImage)
        /// Haptic feedback when loading state changes 
        .onChange(of: viewModel.isLoading) { oldValue, newValue in
            if oldValue && !newValue {
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
            }
        }
    }

    private func sendPrompt() {
        guard !prompt.isEmpty else { return }
        let messageToSend = prompt
        submittedPrompt = messageToSend
        prompt = ""
        inputIsFocused = false
        Task {
            await viewModel.getRecommendations(  for: messageToSend)
        }
    }

    private func loadProfileImage() {
        if let imageData = UserDefaults.standard.data(forKey: UserDefaultKeys.profileImageKey),
           let image = UIImage(data: imageData) {
            profileImage = image
        }
    }
}

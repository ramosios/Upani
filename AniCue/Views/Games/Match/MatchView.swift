//
//  MatchView.swift
//  AniCue
//
//  Created by Jorge Ramos on 10/08/25.
//
import SwiftUI

struct MatchView: View {
    let source: String
    @StateObject private var viewModel: MatchViewModel
    private let cardLimit = 5

    init(source: String) {
        self.source = source
        _viewModel = StateObject(wrappedValue: MatchViewModel(name: source))
    }

    var body: some View {
        VStack {
            ZStack {
                if viewModel.animes.isEmpty {
                    Text("No more anime!")
                        .font(.headline)
                        .foregroundColor(.gray)
                } else {
                    ForEach(Array(viewModel.animes.prefix(cardLimit).enumerated().reversed()), id: \.element.id) { index, anime in
                        MatchCardView(
                            anime: .constant(anime),
                            offset: Binding(
                                get: { viewModel.cardOffsets[anime.id] ?? .zero },
                                set: { viewModel.cardOffsets[anime.id] = $0 }
                            ),
                            onRemove: {
                                viewModel.swipeCard(for: anime)
                            }
                        )
                        .allowsHitTesting(index == 0)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.vertical)
        }
        .padding(.horizontal)
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationTitle("Find Your Match")
        .navigationBarTitleDisplayMode(.inline)
    }
}

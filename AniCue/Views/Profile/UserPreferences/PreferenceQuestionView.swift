//
//  PreferenceQuestionView.swift
//  AniCue
//
//  Created by Jorge Ramos on 03/07/25.
//
import SwiftUI
struct PreferenceQuestionView: View {
    let icon: String
    let question: String
    let explanation: String
    let options: [String]?
    @Binding var selectedAnswer: String
    @Binding var showingHelp: Bool
    var onSelect: ((String) -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.accentColor)
                Text(question)
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            .padding(.trailing, 40)
            if let options = options {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 130), spacing: 12)], spacing: 12) {
                    ForEach(options, id: \.self) { answer in
                        Button(
                            action: {
                                selectedAnswer = answer
                                onSelect?(answer)
                            },
                            label: {
                                Text(answer)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 10)
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        selectedAnswer == answer
                                        ? Color.accentColor
                                        : Color(.systemGray6)
                                    )
                                    .foregroundColor(
                                        selectedAnswer == answer
                                        ? .white
                                        : .primary
                                    )
                                    .clipShape(Capsule())
                                    .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
                            }
                        )
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray5))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .black.opacity(0.07), radius: 8, x: 0, y: 4)
        .overlay(
            VStack(alignment: .trailing, spacing: 4) {
                Button(
                    action: {
                        showingHelp.toggle()
                    },
                    label: {
                        Image(systemName: "questionmark.circle.fill")
                            .foregroundColor(.gray)
                            .padding(10)
                    }
                )
                .zIndex(2)
                if showingHelp {
                    Text(explanation)
                        .font(.callout)
                        .foregroundColor(.primary)
                        .padding(10)
                        .background(Color(.systemBackground))
                        .cornerRadius(10)
                        .shadow(radius: 4)
                        .frame(maxWidth: 220, alignment: .trailing)
                        .transition(.opacity)
                        .zIndex(1)
                }
            }
            .padding([.top, .trailing], 8),
            alignment: .topTrailing
        )
    }
}

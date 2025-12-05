import SwiftUI

struct MenuView: View {
    let sourceType: MenuSourceType
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 24) {
                    ForEach(sourceType.menuItems) { item in
                        NavigationLink(destination: sourceType.destination(for: item)) {
                            MenuCardView(menuItem: item)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle(sourceType.title)
        }
        .accentColor(.teal)
    }
}

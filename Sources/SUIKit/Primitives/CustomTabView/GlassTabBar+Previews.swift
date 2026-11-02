import SwiftUI

@available(iOS 26.0, *)
struct GlassTabBarPreview: View {
    @State private var selection: AppTab = .wallet
    @State private var showAdd = false

    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Бюджет").font(.largeTitle.bold())
                    RoundedRectangle(cornerRadius: 28)
                        .fill(.indigo.gradient)
                        .frame(height: 220)
                        .overlay {
                            Text("125 400 ₽").font(.largeTitle.bold()).foregroundStyle(.white)
                        }
                    Text("Транзакции").font(.title3.bold())
                    ForEach(0..<12) { index in
                        HStack {
                            Image(systemName: "cart").foregroundStyle(SemanticColors.accent)
                            Text("Покупка \(index + 1)")
                            Spacer()
                            Text("1 200 ₽").foregroundStyle(.secondary)
                        }
                        .padding(20)
                        .background(SemanticColors.card, in: .rect(cornerRadius: 16))
                    }
                }
                .padding(20)
                .padding(.bottom, 100)
            }
            GlassTabBar(selectedTab: $selection, onAddTapped: { showAdd = true })
        }
        .background(SemanticColors.screen)
        .alert("Добавить транзакцию", isPresented: $showAdd) {
            Button("Готово", role: .cancel) {}
        }
    }
}

@available(iOS 26.0, *)
#Preview("Glass Tab Bar · Light") {
    GlassTabBarPreview().preferredColorScheme(.light)
}

@available(iOS 26.0, *)
#Preview("Glass Tab Bar · Dark") {
    GlassTabBarPreview().preferredColorScheme(.dark)
}

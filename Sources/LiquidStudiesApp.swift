import SwiftUI

// Standalone offline design sample. All displayed values are fixtures.
@main
struct LiquidStudiesApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                Tab("首页", systemImage: "house") { HomePreview() }
                Tab("条件中心", systemImage: "square.grid.2x2") { destination("条件中心") }
                Tab("条件分析", systemImage: "chart.xyaxis.line") { destination("条件分析") }
                Tab("任务", systemImage: "checklist") { destination("任务") }
                Tab("我的", systemImage: "person.crop.circle") { destination("我的") }
            }
            .tint(.blue)
            .environment(\.locale, Locale(identifier: "zh_CN"))
        }
    }
    private func destination(_ title: String) -> some View {
        NavigationStack {
            ContentUnavailableView(title, systemImage: "doc.text", description: Text("离线设计示例"))
                .navigationTitle(title)
        }
    }
}

struct HomePreview: View {
    @Environment(\.horizontalSizeClass) private var sizeClass
    @ScaledMetric(relativeTo: .title2) private var ballSize = 42.0

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    account
                    shortcuts
                    draw
                    overview
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
                .padding(.bottom, 24)
                .frame(maxWidth: sizeClass == .regular ? 600 : .infinity)
                .frame(maxWidth: .infinity)
            }
            .background(Color(uiColor: .systemBackground))
            .navigationTitle("无忧28")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("通知", systemImage: "bell") { }
                }
            }
        }
    }

    private var account: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("账户余额 · 元").font(.subheadline).foregroundStyle(.secondary)
            Text("12,680.50")
                .font(.largeTitle.weight(.semibold)).monospacedDigit()
            HStack(spacing: 8) {
                Text("今日已结算盈亏").foregroundStyle(.secondary)
                Text("+286.80").fontWeight(.medium).foregroundStyle(.red)
            }.font(.subheadline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var shortcuts: some View {
        HStack(spacing: 12) {
            Button {} label: {
                Label("资金详情", systemImage: "wallet.bifold")
                    .frame(maxWidth: .infinity, minHeight: 44)
            }
            Button {} label: {
                Label("今日记录", systemImage: "doc.text")
                    .frame(maxWidth: .infinity, minHeight: 44)
            }
        }
        .font(.subheadline.weight(.medium))
        .buttonStyle(.bordered)
        .buttonBorderShape(.roundedRectangle(radius: 14))
        .controlSize(.small)
    }

    private var draw: some View {
        VStack(alignment: .leading, spacing: 22) {
            HStack(alignment: .firstTextBaseline) {
                Text("最新开奖").font(.headline)
                Spacer()
                Text("第 3281021 期").font(.caption).foregroundStyle(.secondary)
            }
            HStack(spacing: 0) {
                ball("3")
                operation("+")
                ball("8")
                operation("+")
                ball("6")
                operation("=")
                ball("17", result: true)
            }
            HStack {
                Text("大 · 单 · 杂六").foregroundStyle(.secondary)
                Spacer()
                Text("下一期").foregroundStyle(.secondary)
                Text("02:18").monospacedDigit().foregroundStyle(.blue)
            }.font(.caption)
        }
        .padding(20)
        .background(Color(uiColor: .secondarySystemBackground), in: RoundedRectangle(cornerRadius: 20))
    }

    private var overview: some View {
        VStack(alignment: .leading, spacing: 22) {
            HStack {
                Text("运行概览").font(.headline)
                Spacer()
                Text("演示数据").font(.caption).foregroundStyle(.tertiary)
            }
            LazyVGrid(columns: [GridItem(.flexible(), alignment: .leading), GridItem(.flexible(), alignment: .leading)], alignment: .leading, spacing: 26) {
                status("账户连接", value: "已连接", symbol: "link")
                status("异常状态", value: "暂无异常", symbol: "checkmark.shield")
                status("运行任务", value: "0 个运行中", symbol: "play.circle")
                status("任务记录", value: "查看记录", symbol: "clock.arrow.circlepath")
            }
        }
    }

    private func ball(_ value: String, result: Bool = false) -> some View {
        Text(value).font(.title2.weight(.medium)).monospacedDigit()
            .frame(width: ballSize, height: ballSize)
            .foregroundStyle(result ? Color.white : Color.primary)
            .background(result ? Color.blue : Color(uiColor: .systemBackground), in: Circle())
    }
    private func operation(_ value: String) -> some View {
        Text(value).font(.caption).foregroundStyle(.tertiary).frame(maxWidth: .infinity)
    }
    private func status(_ title: String, value: String, symbol: String) -> some View {
        Button {} label: {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: symbol)
                    .font(.body).foregroundStyle(.blue)
                    .frame(width: 22, height: 24)
                VStack(alignment: .leading, spacing: 6) {
                    Text(title).font(.caption).foregroundStyle(.secondary)
                    Text(value).font(.subheadline.weight(.medium)).foregroundStyle(.primary)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 48, alignment: .leading)
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
    }
}

import SwiftUI

// Offline visual fixtures. No production data, networking or transaction logic.
@main
struct LiquidStudiesApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                Tab("首页", systemImage: "house") { HomePreview() }
                Tab("条件中心", systemImage: "square.grid.2x2") { placeholder("条件中心") }
                Tab("条件分析", systemImage: "chart.xyaxis.line") { placeholder("条件分析") }
                Tab("任务", systemImage: "checklist") { placeholder("任务") }
                Tab("我的", systemImage: "person.crop.circle") { placeholder("我的") }
            }
            .tint(.blue)
            .environment(\.locale, Locale(identifier: "zh_CN"))
        }
    }
    private func placeholder(_ title: String) -> some View {
        NavigationStack {
            ContentUnavailableView(title, systemImage: "doc.text", description: Text("离线界面示例"))
                .navigationTitle(title)
        }
    }
}

struct HomePreview: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    HStack(alignment: .top, spacing: 20) {
                        amount("账户余额 · 元", value: "12,680", fraction: ".50", color: .primary)
                        Divider()
                        amount("今日已结算盈亏", value: "+286", fraction: ".80", color: .red)
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(20)
                    .cardSurface()

                    HStack {
                        Button("资金详情", systemImage: "wallet.bifold") { }
                            .frame(maxWidth: .infinity, minHeight: 44)
                        Divider().frame(height: 24)
                        Button("今日记录", systemImage: "doc.text") { }
                            .frame(maxWidth: .infinity, minHeight: 44)
                    }
                    .font(.subheadline)
                    .padding(4)
                    .cardSurface()

                    VStack(spacing: 22) {
                        HStack {
                            Text("最新开奖").font(.headline)
                            Spacer()
                            Text("第 3281021 期").font(.caption).foregroundStyle(.secondary)
                        }
                        HStack(spacing: 0) {
                            ball("3")
                            symbol("+")
                            ball("8")
                            symbol("+")
                            ball("6")
                            symbol("=")
                            ball("17", highlighted: true)
                        }
                        Divider()
                        HStack {
                            Text("下一期").foregroundStyle(.secondary)
                            Text("02:18").monospacedDigit().foregroundStyle(.blue)
                            Spacer()
                            Text("大 · 单 · 杂六").foregroundStyle(.secondary)
                        }
                        .font(.subheadline)
                    }
                    .padding(20)
                    .cardSurface()

                    HStack {
                        Text("运行概览").font(.headline)
                        Spacer()
                        Text("演示数据").font(.caption).foregroundStyle(.secondary)
                    }.padding(.top, 6)

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        status("账户连接", value: "已连接", symbol: "link")
                        status("异常状态", value: "暂无异常", symbol: "checkmark.shield")
                        status("运行任务", value: "0 个运行中", symbol: "play.circle")
                        status("任务记录", value: "查看记录", symbol: "clock.arrow.circlepath")
                    }
                }
                .frame(maxWidth: 600)
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 20)
                .frame(maxWidth: .infinity)
            }
            .background(Color(uiColor: .systemGroupedBackground))
            .navigationTitle("首页")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("通知", systemImage: "bell") { }
                }
            }
        }
    }
    private func amount(_ label: String, value: String, fraction: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(label).font(.caption).foregroundStyle(.secondary)
            (Text(value).font(.title2.bold()) + Text(fraction).font(.subheadline.bold()))
                .foregroundStyle(color).monospacedDigit()
        }.frame(maxWidth: .infinity, alignment: .leading)
    }
    private func ball(_ value: String, highlighted: Bool = false) -> some View {
        Text(value).font(.title2.weight(.medium)).monospacedDigit()
            .frame(width: 44, height: 44)
            .foregroundStyle(highlighted ? Color.white : Color.primary)
            .background(highlighted ? Color.blue : Color(uiColor: .tertiarySystemGroupedBackground), in: Circle())
    }
    private func symbol(_ value: String) -> some View {
        Text(value).font(.caption).foregroundStyle(.secondary).frame(maxWidth: .infinity)
    }
    private func status(_ title: String, value: String, symbol: String) -> some View {
        Button {} label: {
            VStack(alignment: .leading, spacing: 10) {
                Image(systemName: symbol).font(.title3).foregroundStyle(.blue)
                Text(title).font(.caption).foregroundStyle(.secondary)
                Text(value).font(.subheadline.weight(.semibold)).foregroundStyle(.primary)
            }
            .frame(maxWidth: .infinity, minHeight: 96, alignment: .leading)
            .padding(16)
            .cardSurface()
        }.buttonStyle(.plain)
    }
}

private extension View {
    func cardSurface() -> some View {
        background(Color(uiColor: .secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 24))
    }
}

import SwiftUI

// Isolated offline design fixtures; no networking or production data.
@main
struct LiquidStudiesApp: App {
    private var study: Int {
        let a = ProcessInfo.processInfo.arguments
        guard let i = a.firstIndex(of: "-study"), a.indices.contains(i + 1) else { return 0 }
        return min(max(Int(a[i + 1]) ?? 0, 0), 4)
    }
    var body: some Scene {
        WindowGroup { StudyRoot(study: study).environment(\.locale, Locale(identifier: "zh_CN")) }
    }
}
struct StudyRoot: View {
    let study: Int
    var body: some View {
        TabView {
            Tab("首页", systemImage: "house") { Home(study: study) }
            Tab("条件", systemImage: "square.grid.2x2") { destination("条件中心") }
            Tab("分析", systemImage: "chart.xyaxis.line") { destination("条件分析") }
            Tab("任务", systemImage: "checklist") { destination("任务") }
            Tab("我的", systemImage: "person.crop.circle") { destination("我的") }
        }.tint(.blue)
    }
    private func destination(_ title: String) -> some View {
        NavigationStack { ContentUnavailableView(title, systemImage: "doc.text", description: Text("离线设计样稿")).navigationTitle(title) }
    }
}
struct Home: View {
    let study: Int
    @State private var scope = 0
    @Environment(\.horizontalSizeClass) private var sizeClass
    private var title: String { ["总览", "今天", "开奖", "工作台", "无忧28"][study] }
    var body: some View {
        NavigationStack {
            Group {
                switch study {
                case 0: account
                case 1: today
                case 2: draw
                case 3: workspace
                default: grouped
                }
            }
            .navigationTitle(title).navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) { Button("通知", systemImage: "bell") { }.frame(minWidth: 44, minHeight: 44) }
                ToolbarItem(placement: .topBarTrailing) { Button("账户", systemImage: "person.crop.circle") { }.frame(minWidth: 44, minHeight: 44) }
            }
        }
    }
    private func canvas<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 26, content: content)
                .frame(maxWidth: sizeClass == .regular ? 640 : .infinity)
                .padding(.horizontal, 24).padding(.top, 12).padding(.bottom, 24)
                .frame(maxWidth: .infinity)
        }.background(Color(uiColor: .systemBackground))
    }
    // Account-led, one restrained column. No content glass.
    private var account: some View {
        canvas {
            VStack(alignment: .leading, spacing: 18) {
                HStack { Text("账户余额 · 元").foregroundStyle(.secondary); Spacer(); Label("已连接", systemImage: "checkmark.circle").font(.caption).foregroundStyle(.secondary) }
                Text("12,680.50").font(.largeTitle.bold()).monospacedDigit().lineLimit(1).minimumScaleFactor(0.7)
                HStack { Text("今日已结算").foregroundStyle(.secondary); Spacer(); Text("+286.80 元").fontWeight(.semibold).foregroundStyle(.red) }.font(.subheadline)
            }
            Divider()
            VStack(alignment: .leading, spacing: 18) {
                Heading(title: "最新开奖", detail: "3281021 期")
                Equation()
                DrawFooter()
            }
            Divider()
            VStack(alignment: .leading, spacing: 8) {
                Heading(title: "我的任务", detail: "2 个已暂停")
                TaskLine(id: "S0001", detail: "100 间隔 × 2 倍", amount: "10 元")
                Divider()
                TaskLine(id: "S0002", detail: "50 间隔 × 3 倍", amount: "1 元")
            }
            PendingNotice()
            NavigationLink { detail("资金明细") } label: { HStack { Text("查看资金明细"); Spacer(); Image(systemName: "arrow.right") }.frame(minHeight: 44) }
        }
    }
    // Daily editorial summary, profit is the hero.
    private var today: some View {
        canvas {
            VStack(alignment: .leading, spacing: 12) {
                Text("11月21日，星期六").font(.subheadline).foregroundStyle(.secondary)
                Text("今日已结算盈亏").font(.headline)
                Text("+286.80").font(.largeTitle.bold()).foregroundStyle(.red).monospacedDigit()
                Label("已结算记录统计 · 元", systemImage: "checkmark.circle").font(.caption).foregroundStyle(.secondary)
            }
            Divider()
            HStack(alignment: .top) {
                Metric(title: "账户余额", value: "12,680.50", note: "元")
                Spacer(minLength: 20)
                Metric(title: "任务状态", value: "0 / 2", note: "运行 / 已暂停")
            }
            Divider()
            VStack(alignment: .leading, spacing: 16) {
                Heading(title: "此刻", detail: "最新开奖")
                HStack(spacing: 20) {
                    ResultNumber()
                    VStack(alignment: .leading, spacing: 8) {
                        Text("第 3281021 期").font(.headline)
                        Text("3 + 8 + 6 · 大 / 单 / 杂六").font(.subheadline).foregroundStyle(.secondary)
                    }
                }
                HStack { Label("距离下一期", systemImage: "clock").foregroundStyle(.secondary); Spacer(); Text("02:18").monospacedDigit().fontWeight(.medium) }.font(.subheadline)
            }
            Divider()
            VStack(alignment: .leading, spacing: 12) {
                Text("待你关注").font(.title3.bold())
                PendingNotice()
                NavigationLink { detail("任务") } label: { HStack { Label("2 个任务已暂停", systemImage: "pause.circle"); Spacer(); Image(systemName: "chevron.right").font(.caption) }.frame(minHeight: 44) }
            }
        }
    }
    // Results-led, native segmented picker and compact recent-results ledger.
    private var draw: some View {
        canvas {
            Picker("开奖范围", selection: $scope) { Text("最新").tag(0); Text("历史").tag(1); Text("统计").tag(2) }.pickerStyle(.segmented)
            VStack(alignment: .leading, spacing: 20) {
                Heading(title: "第 3281021 期", detail: "已开奖")
                HStack {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("3 + 8 + 6").font(.title2).monospacedDigit()
                        Text("大 · 单 · 杂六").font(.subheadline).foregroundStyle(.secondary)
                    }
                    Spacer(minLength: 20)
                    ResultNumber()
                }
                DrawFooter()
            }
            Divider()
            VStack(alignment: .leading, spacing: 4) {
                Text("近期结果").font(.title3.bold()).padding(.bottom, 8)
                resultRow("3281020", "2 + 5 + 4", "11", "小 · 单")
                Divider()
                resultRow("3281019", "7 + 6 + 8", "21", "大 · 单")
                Divider()
                resultRow("3281018", "1 + 4 + 7", "12", "小 · 双")
            }
            Divider()
            HStack {
                Metric(title: "账户余额", value: "12,680.50", note: "元")
                Spacer(minLength: 16)
                Metric(title: "今日已结算", value: "+286.80", note: "元", positive: true)
            }
            PendingNotice()
        }
    }
    // Operational task workspace, built with standard grouped List rows.
    private var workspace: some View {
        List {
            Section {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("所有任务已暂停").font(.title2.bold())
                        Text("0 个运行中 · 2 个已暂停").font(.subheadline).foregroundStyle(.secondary)
                    }
                    Spacer()
                    Image(systemName: "pause.circle").font(.title).foregroundStyle(.secondary)
                }.padding(.vertical, 8)
            }
            Section("任务") {
                NavigationLink { detail("S0001") } label: { TaskLine(id: "S0001", detail: "100 间隔 × 2 倍", amount: "10 元") }
                NavigationLink { detail("S0002") } label: { TaskLine(id: "S0002", detail: "50 间隔 × 3 倍", amount: "1 元") }
            }
            Section("账户") {
                LabeledContent("账户余额", value: "12,680.50 元")
                LabeledContent { Text("+286.80 元").foregroundStyle(.red) } label: { Text("今日已结算") }
            }
            Section("最新开奖") {
                HStack(spacing: 16) {
                    Text("17").font(.title.bold()).foregroundStyle(.blue)
                    VStack(alignment: .leading, spacing: 6) {
                        Text("3281021 期 · 大 / 单 / 杂六").font(.subheadline)
                        Text("3 + 8 + 6").font(.caption).foregroundStyle(.secondary)
                    }; Spacer(minLength: 0)
                }.padding(.vertical, 4)
                LabeledContent("下一期", value: "02:18").monospacedDigit()
            }
            Section { PendingNotice() }
        }.listStyle(.insetGrouped).listSectionSpacing(.compact)
            .scrollContentBackground(.hidden).background(Color(uiColor: .systemBackground))
    }
    // Familiar grouped native directory with concise financial and result rows.
    private var grouped: some View {
        List {
            Section {
                HStack(spacing: 12) {
                    Image(systemName: "person.crop.circle.fill").font(.largeTitle).foregroundStyle(.blue)
                    VStack(alignment: .leading, spacing: 6) {
                        Text("我的账户").font(.headline)
                        Label("已连接 · 暂无异常", systemImage: "checkmark.circle").font(.caption).foregroundStyle(.secondary)
                    }; Spacer()
                }.padding(.vertical, 4)
            }
            Section("资金概览") {
                VStack(alignment: .leading, spacing: 10) {
                    Text("账户余额 · 元").font(.caption).foregroundStyle(.secondary)
                    Text("12,680.50").font(.largeTitle.bold()).monospacedDigit().lineLimit(1).minimumScaleFactor(0.7)
                    HStack { Text("今日已结算").foregroundStyle(.secondary); Spacer(); Text("+286.80 元").foregroundStyle(.red) }.font(.subheadline)
                }.padding(.vertical, 6)
                NavigationLink { detail("资金明细") } label: { Label("资金明细", systemImage: "wallet.bifold") }
            }
            Section("开奖") {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("第 3281021 期").font(.subheadline)
                        Text("3 + 8 + 6 · 大 / 单 / 杂六").font(.caption).foregroundStyle(.secondary)
                    }; Spacer()
                    Text("17").font(.largeTitle.weight(.semibold)).foregroundStyle(.blue)
                }.padding(.vertical, 4)
                LabeledContent("距离下一期", value: "02:18").monospacedDigit()
            }
            Section {
                NavigationLink { detail("任务") } label: {
                    LabeledContent { Text("2 个已暂停").foregroundStyle(.secondary) } label: { Label("我的任务", systemImage: "checklist") }
                }
                NavigationLink { detail("待确认记录") } label: {
                    LabeledContent { Text("2 笔").foregroundStyle(.secondary) } label: { Label("待确认记录", systemImage: "clock.badge.questionmark") }
                }
            } header: { Text("常用") } footer: { Text("待确认记录暂不计入今日已结算盈亏") }
        }.listStyle(.insetGrouped).listSectionSpacing(.compact)
            .scrollContentBackground(.hidden).background(Color(uiColor: .systemBackground))
    }
    private func detail(_ title: String) -> some View {
        ContentUnavailableView(title, systemImage: "doc.text", description: Text("离线设计样稿，不连接真实账户")).navigationTitle(title)
    }
    private func resultRow(_ issue: String, _ equation: String, _ result: String, _ type: String) -> some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 5) { Text(issue).font(.subheadline); Text(equation).font(.caption).foregroundStyle(.secondary) }
            Spacer()
            Text(result).font(.title3.weight(.semibold)).monospacedDigit()
            Text(type).font(.caption).foregroundStyle(.secondary)
        }.frame(minHeight: 52).accessibilityElement(children: .combine)
    }
}
struct Heading: View {
    let title: String
    let detail: String
    var body: some View {
        HStack(alignment: .firstTextBaseline) { Text(title).font(.headline); Spacer(minLength: 12); Text(detail).font(.caption).foregroundStyle(.secondary) }
    }
}
struct Metric: View {
    let title: String
    let value: String
    let note: String
    var positive = false
    var body: some View {
        VStack(alignment: .leading, spacing: 9) {
            Text(title).font(.caption).foregroundStyle(.secondary)
            Text(value).font(.title2.weight(.semibold)).monospacedDigit().foregroundStyle(positive ? Color.red : Color.primary).lineLimit(1).minimumScaleFactor(0.7)
            Text(note).font(.caption).foregroundStyle(.secondary)
        }.accessibilityElement(children: .combine)
    }
}
struct ResultNumber: View {
    @ScaledMetric(relativeTo: .largeTitle) private var numberSize = 64.0
    var body: some View {
        Text("17").font(.system(size: numberSize, weight: .semibold, design: .rounded)).monospacedDigit().foregroundStyle(.blue)
            .lineLimit(1).fixedSize(horizontal: true, vertical: false).accessibilityLabel("开奖结果，17")
    }
}
struct Equation: View {
    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            Text("3 + 8 + 6").font(.title).monospacedDigit().lineLimit(1).minimumScaleFactor(0.75)
            Text("=").font(.title3).foregroundStyle(.secondary); Spacer(minLength: 0)
            Text("17").font(.largeTitle.bold()).foregroundStyle(.blue).fixedSize()
        }.accessibilityElement(children: .ignore).accessibilityLabel("3 加 8 加 6，开奖结果 17")
    }
}
struct DrawFooter: View {
    var body: some View {
        HStack { Text("大 · 单 · 杂六"); Spacer(); Text("下一期 02:18").monospacedDigit() }.font(.caption).foregroundStyle(.secondary)
    }
}
struct TaskLine: View {
    let id: String
    let detail: String
    let amount: String
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "pause.circle").font(.title3).foregroundStyle(.secondary)
            VStack(alignment: .leading, spacing: 6) { Text(id).font(.body.weight(.medium)); Text(detail).font(.caption).foregroundStyle(.secondary) }
            Spacer(minLength: 8)
            VStack(alignment: .trailing, spacing: 6) { Text(amount).font(.subheadline); Text("起投金额").font(.caption).foregroundStyle(.secondary) }
        }.frame(minHeight: 60).accessibilityElement(children: .combine)
    }
}
struct PendingNotice: View {
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "clock.badge.questionmark").foregroundStyle(.secondary)
            VStack(alignment: .leading, spacing: 5) { Text("2 笔记录待确认").font(.subheadline); Text("暂不计入今日已结算盈亏").font(.caption).foregroundStyle(.secondary) }
            Spacer(minLength: 0)
        }.accessibilityElement(children: .combine)
    }
}

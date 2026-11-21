import SwiftUI

// Isolated, offline design studies. No production models or API client are linked.
@main
struct LiquidStudiesApp: App {
    private var study: Int {
        let arguments = ProcessInfo.processInfo.arguments
        guard let index = arguments.firstIndex(of: "-study"), arguments.indices.contains(index + 1) else { return 0 }
        return min(max(Int(arguments[index + 1]) ?? 0, 0), 9)
    }

    var body: some Scene {
        WindowGroup {
            StudyRoot(study: study)
                .preferredColorScheme(.light)
                .environment(\.locale, Locale(identifier: "zh_CN"))
        }
    }
}

struct StudyRoot: View {
    let study: Int
    @State private var tab = 0

    var body: some View {
        TabView(selection: $tab) {
            Tab("首页", systemImage: "house.fill", value: 0) {
                StudyHome(study: study)
            }
            Tab("条件中心", systemImage: "square.grid.2x2", value: 1) { placeholder("条件中心") }
            Tab("条件分析", systemImage: "chart.xyaxis.line", value: 2) { placeholder("条件分析") }
            Tab("任务", systemImage: "checklist", value: 3) { placeholder("任务") }
            Tab("我的", systemImage: "person.crop.circle", value: 4) { placeholder("我的") }
        }
        .tint(.blue)
    }

    private func placeholder(_ title: String) -> some View {
        NavigationStack {
            ContentUnavailableView(title, systemImage: "square.stack", description: Text("静态设计工程，仅首页用于视觉研究"))
                .navigationTitle(title)
        }
    }
}

struct StudyHome: View {
    let study: Int
    @State private var selection = 0
    @State private var page = 0
    @State private var showSheet = false
    @State private var expanded = true

    private var title: String {
        switch study {
        case 1: return "摘要"
        case 3: return "今天"
        case 5: return "账户"
        default: return "首页"
        }
    }

    var body: some View {
        NavigationStack {
            homeContent
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(study == 6 ? .inline : .large)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        if study == 6 {
                            Button("无忧28", systemImage: "circle.grid.2x2.fill") { }
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("通知", systemImage: "bell") { }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("账户", systemImage: "person.crop.circle") { }
                    }
                }
                .sheet(isPresented: $showSheet) {
                    NavigationStack {
                        List {
                            Section("任务") { TaskRow(id: "S0001", plan: "100 间隔 × 2 倍", stake: "10"); TaskRow(id: "S0002", plan: "50 间隔 × 3 倍", stake: "1") }
                            Section { PendingRow() }
                            Section { Label("账户已连接，暂无异常", systemImage: "checkmark.circle").foregroundStyle(.secondary) }
                        }
                        .listSectionSpacing(.compact).scrollContentBackground(.hidden)
                        .background(.white)
                        .navigationTitle("任务概览")
                        .navigationBarTitleDisplayMode(.inline)
                    }
                    .presentationDetents([.height(330), .large])
                    .presentationBackground(.regularMaterial)
                    .presentationDragIndicator(.visible)
                    .presentationBackgroundInteraction(.enabled)
                }
        }
    }

    @ViewBuilder private var homeContent: some View {
        switch study {
        case 0: standardList
        case 1: summaryScroll
        case 2: segmentedList
        case 3: countdownList
        case 4: modularScroll
        case 5: accountForm
        case 6: compactList
        case 7: sheetScroll
        case 8: pagingScroll
        default: disclosureList
        }
    }

    private var standardList: some View {
        List {
            Section {
                BalanceView(emphasized: true)
                ActionButtons()
            }
            Section("最新开奖") { DrawView() }
            taskSection
            Section { PendingRow() }
            demoSection
        }
        .listSectionSpacing(.compact).scrollContentBackground(.hidden)
        .background(Color.white)
    }

    private var summaryScroll: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("11月21日 星期六").font(.subheadline).foregroundStyle(.secondary)
                HStack(alignment: .top, spacing: 12) {
                    GroupBox {
                        VStack(alignment: .leading, spacing: 9) {
                            Text("12,680.50").font(.title2.weight(.semibold)).minimumScaleFactor(0.8).lineLimit(1)
                            Text("元").font(.caption).foregroundStyle(.secondary)
                        }.frame(maxWidth: .infinity, alignment: .leading)
                    } label: { Label("账户余额", systemImage: "wallet.bifold").font(.subheadline).foregroundStyle(.blue) }
                    GroupBox {
                        VStack(alignment: .leading, spacing: 9) {
                            Text("+286.80").font(.title2.weight(.semibold))
                            Text("今日 · 元").font(.caption).foregroundStyle(.secondary)
                        }.frame(maxWidth: .infinity, alignment: .leading)
                    } label: { Label("已结算盈亏", systemImage: "chart.line.uptrend.xyaxis").font(.subheadline).foregroundStyle(.red) }
                }
                GroupBox { DrawView() } label: { Label("最新开奖", systemImage: "number.circle").foregroundStyle(.blue) }
                GroupBox { TasksOverview() } label: { Label("任务", systemImage: "checklist") }
                PendingRow()
                demoText
            }.padding(.horizontal, 20).padding(.top, 8)
        }.background(.white)
    }

    private var segmentedList: some View {
        VStack(spacing: 0) {
            Picker("内容", selection: $selection) {
                Text("概览").tag(0); Text("开奖").tag(1); Text("任务").tag(2)
            }.pickerStyle(.segmented).padding(.horizontal, 20).padding(.top, 8).padding(.bottom, 8)
            List {
                Section { DrawView(large: true) }
                Section("账户") { BalanceView(); ActionButtons() }
                taskSection
                Section { PendingRow() }
                demoSection
            }.listStyle(.insetGrouped).listSectionSpacing(.compact).scrollContentBackground(.hidden)
        }.background(.white)
    }

    private var countdownList: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 10) {
                    Label("下一期开奖", systemImage: "clock").font(.subheadline).foregroundStyle(.secondary)
                    Text("02:18").font(.system(size: 48, weight: .light, design: .default)).monospacedDigit().foregroundStyle(.blue)
                    Text("最新第 3281021 期 · 大 / 单 / 杂六").font(.caption).foregroundStyle(.secondary)
                }.padding(.vertical, 6)
            }
            Section("最新开奖") { DrawView(showCountdown: false) }
            Section("账户") { BalanceView() }
            taskSection
            Section { PendingRow() }
            demoSection
        }.listSectionSpacing(.compact).scrollContentBackground(.hidden).background(.white)
    }

    private var modularScroll: some View {
        ScrollView {
            VStack(spacing: 18) {
                GroupBox { BalanceView(emphasized: true); ActionButtons() } label: { Label("账户", systemImage: "wallet.bifold") }
                HStack(alignment: .top, spacing: 12) {
                    GroupBox {
                        VStack(alignment: .leading, spacing: 9) {
                            Text("17").font(.system(size: 58, weight: .light)).foregroundStyle(.blue)
                            Text("3 + 8 + 6").font(.headline)
                            Text("大 / 单 / 杂六").font(.caption).foregroundStyle(.secondary)
                        }.frame(maxWidth: .infinity, alignment: .leading)
                    } label: { Text("最新开奖").font(.subheadline) }
                    GroupBox {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("02:18").font(.largeTitle.weight(.light)).monospacedDigit()
                            Label("等待开奖", systemImage: "clock").font(.caption).foregroundStyle(.secondary)
                            Text("3281021 期已开奖").font(.caption2).foregroundStyle(.secondary)
                        }.frame(maxWidth: .infinity, alignment: .leading)
                    } label: { Text("下一期").font(.subheadline) }
                }
                GroupBox { TasksOverview() } label: { Label("任务", systemImage: "checklist") }
                PendingRow()
                demoText
            }.padding(20)
        }.background(.white)
    }

    private var accountForm: some View {
        Form {
            Section {
                Label {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("无忧28").font(.headline)
                        Text("已连接 · 暂无异常").font(.caption).foregroundStyle(.secondary)
                    }
                } icon: { Image(systemName: "person.crop.circle.fill").font(.largeTitle).foregroundStyle(.blue) }
            }
            Section("资金") {
                LabeledContent("账户余额", value: "12,680.50 元")
                LabeledContent { Text("+286.80 元").foregroundStyle(.red).monospacedDigit() } label: { Text("今日已结算盈亏") }
                Button("资金明细", systemImage: "wallet.bifold") { }
            }
            Section("最新开奖") { DrawView() }
            Section("任务与记录") {
                LabeledContent("运行任务", value: "0 / 2")
                LabeledContent("已暂停", value: "2 个")
                PendingRow()
            }
            demoSection
        }.listSectionSpacing(.compact).scrollContentBackground(.hidden).background(.white)
    }

    private var compactList: some View {
        List {
            Section { DrawView(large: true) }
            Section {
                BalanceView(emphasized: true)
                ActionButtons()
            }
            taskSection
            Section { PendingRow() }
            demoSection
        }.listSectionSpacing(.compact).scrollContentBackground(.hidden).background(.white)
    }

    private var sheetScroll: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                BalanceView(emphasized: true)
                ActionButtons()
                DrawView(large: true)
                Button("查看任务与待确认记录", systemImage: "checklist") { showSheet = true }
                    .buttonStyle(.glass)
                demoText
            }.padding(24)
        }
        .background(.white)
        .task { showSheet = true }
    }

    private var pagingScroll: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                TabView(selection: $page) {
                    GroupBox { DrawView(large: true) } label: { Text("最新开奖") }.padding(.horizontal, 20).tag(0)
                    GroupBox { BalanceView() } label: { Text("账户") }.padding(.horizontal, 20).tag(1)
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                .frame(height: 220)
                VStack(spacing: 20) {
                    GroupBox { BalanceView(); ActionButtons() } label: { Label("账户", systemImage: "wallet.bifold") }
                    GroupBox { TasksOverview() } label: { Label("任务", systemImage: "checklist") }
                    PendingRow()
                    demoText
                }.padding(.horizontal, 20)
            }.padding(.top, 8)
        }.background(.white)
    }

    private var disclosureList: some View {
        List {
            Section { BalanceView(emphasized: true); ActionButtons() }
            Section { DrawView() }
            Section {
                DisclosureGroup(isExpanded: $expanded) {
                    TaskRow(id: "S0001", plan: "100 间隔 × 2 倍", stake: "10")
                    TaskRow(id: "S0002", plan: "50 间隔 × 3 倍", stake: "1")
                } label: {
                    LabeledContent("任务概览", value: "0 运行 / 2 暂停")
                }
            }
            Section { PendingRow() }
            demoSection
        }.listSectionSpacing(.compact).scrollContentBackground(.hidden).background(.white)
    }

    private var taskSection: some View {
        Section {
            TaskRow(id: "S0001", plan: "100 间隔 × 2 倍", stake: "10")
            TaskRow(id: "S0002", plan: "50 间隔 × 3 倍", stake: "1")
        } header: {
            HStack { Text("任务"); Spacer(); Text("0 运行 / 2 暂停") }
        }
    }

    private var demoText: some View {
        Text("静态视觉研究 · 演示数据").font(.caption2).foregroundStyle(.tertiary).frame(maxWidth: .infinity)
    }
    private var demoSection: some View {
        Section { } footer: { demoText }
    }
}

struct BalanceView: View {
    var emphasized = false
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading, spacing: 8) {
                Text("账户余额 · 元").font(.caption).foregroundStyle(.secondary)
                Text("12,680.50").font(emphasized ? .largeTitle.weight(.semibold) : .title2.weight(.semibold)).monospacedDigit().lineLimit(1).minimumScaleFactor(0.8)
            }
            Spacer(minLength: 12)
            VStack(alignment: .trailing, spacing: 8) {
                Text("今日已结算盈亏").font(.caption).foregroundStyle(.secondary)
                Text("+286.80").font(.title3.weight(.medium)).monospacedDigit().foregroundStyle(.red)
            }
        }.padding(.vertical, 3)
    }
}

struct ActionButtons: View {
    var body: some View {
        GlassEffectContainer(spacing: 12) {
            HStack(spacing: 12) {
                Button("资金明细", systemImage: "wallet.bifold") { }
                    .buttonStyle(.glass)
                Button("今日记录", systemImage: "doc.text") { }
                    .buttonStyle(.glass)
            }.controlSize(.regular).frame(maxWidth: .infinity)
        }.padding(.vertical, 5)
    }
}

struct DrawView: View {
    var large = false
    var showCountdown = true
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("第 3281021 期").font(.subheadline).foregroundStyle(.secondary)
                Spacer()
                Button("开奖历史", systemImage: "chevron.right") { }.font(.caption).labelStyle(.titleOnly)
            }
            HStack(alignment: .firstTextBaseline, spacing: 0) {
                number("3"); sign("+"); number("8"); sign("+"); number("6"); sign("=")
                Text("17").font(.system(size: large ? 52 : 44, weight: .medium)).foregroundStyle(.blue).monospacedDigit().lineLimit(1).fixedSize(horizontal: true, vertical: false).frame(minWidth: 62).layoutPriority(1)
            }
            HStack {
                Text("大 · 单 · 杂六").font(.caption).foregroundStyle(.secondary)
                Spacer()
                if showCountdown {
                    Text("下一期").font(.caption).foregroundStyle(.secondary)
                    Text("02:18").font(.headline).monospacedDigit().foregroundStyle(.blue)
                }
            }
        }.padding(.vertical, 6)
    }

    private func number(_ value: String) -> some View {
        Text(value).font(.system(size: large ? 34 : 30, weight: .regular)).monospacedDigit().frame(maxWidth: .infinity)
    }
    private func sign(_ value: String) -> some View {
        Text(value).font(.subheadline).foregroundStyle(.tertiary).frame(width: 16)
    }
}

struct TaskRow: View {
    let id: String
    let plan: String
    let stake: String
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "pause.circle").foregroundStyle(.secondary)
            VStack(alignment: .leading, spacing: 5) {
                Text(id).font(.subheadline.weight(.medium))
                Text("\(plan) · 起投 \(stake) 元").font(.caption2).foregroundStyle(.secondary)
            }
            Spacer(minLength: 4)
            Text("已暂停").font(.caption).foregroundStyle(.secondary)
        }.padding(.vertical, 4)
    }
}

struct TasksOverview: View {
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Label("0 运行", systemImage: "play.circle")
                Spacer()
                Label("2 暂停", systemImage: "pause.circle")
            }.font(.subheadline).foregroundStyle(.secondary)
            Divider()
            TaskRow(id: "S0001", plan: "100 间隔 × 2 倍", stake: "10")
            Divider()
            TaskRow(id: "S0002", plan: "50 间隔 × 3 倍", stake: "1")
        }
    }
}

struct PendingRow: View {
    var body: some View {
        Label {
            VStack(alignment: .leading, spacing: 5) {
                Text("2 笔记录待确认").font(.subheadline)
                Text("暂不计入今日已结算盈亏").font(.caption2).foregroundStyle(.secondary)
            }
        } icon: {
            Image(systemName: "clock.badge.questionmark").foregroundStyle(.orange)
        }.padding(.vertical, 3)
    }
}

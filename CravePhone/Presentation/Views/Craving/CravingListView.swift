
//
//  CravingListView.swift
//  CravePhone
//
//  Shows a list of cravings with filters. The new fields are passed into CravingCard automatically.
//
import SwiftUI
struct CravingListView: View {
    @ObservedObject var viewModel: CravingListViewModel
    
    @State private var searchText = ""
    @State private var selectedFilter: CravingFilter = .all
    
    enum CravingFilter: String, CaseIterable, Identifiable {
        case all            = "All"
        case recent         = "Recent"
        case highIntensity  = "High Intensity"
        case highResistance = "High Resistance"
        
        var id: String { self.rawValue }
    }
    
    var body: some View {
        ZStack {
            CraveTheme.Colors.primaryGradient
                .ignoresSafeArea(.all)
                .ignoresSafeArea(.keyboard, edges: .bottom)
            
            VStack(spacing: 0) {
                headerView
                searchAndFilterBar
                    .padding(.horizontal)
                    .padding(.top, 8)
                    .padding(.bottom, 4)
                
                if viewModel.isLoading {
                    loadingView
                } else if filteredCravings.isEmpty {
                    emptyCravingsView
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(filteredCravings) { craving in
                                CravingCard(craving: craving)
                                    .contextMenu {
                                        Button("View Details") {
                                            // Possibly open a detail view that also displays location/people/trigger
                                        }
                                        Button("Archive") {
                                            Task { await viewModel.archiveCraving(craving) }
                                        }
                                    }
                            }
                        }
                        .padding()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .alert(item: $viewModel.alertInfo) { info in
            Alert(
                title: Text(info.title),
                message: Text(info.message),
                dismissButton: .default(Text("OK"))
            )
        }
        .onAppear {
            Task { await viewModel.fetchCravings() }
        }
    }
    
    // MARK: - Filtered Cravings
    private var filteredCravings: [CravingEntity] {
        let cravings = viewModel.cravings
        
        // Filter by search text
        let searchFiltered = searchText.isEmpty
            ? cravings
            : cravings.filter {
                $0.cravingDescription.lowercased()
                    .contains(searchText.lowercased())
            }
        
        // Filter by selected filter
        switch selectedFilter {
        case .all:
            return searchFiltered
        case .recent:
            let oneWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
            return searchFiltered.filter { $0.timestamp >= oneWeekAgo }
        case .highIntensity:
            return searchFiltered.filter { $0.intensity >= 7.0 }
        case .highResistance:
            return searchFiltered
                .filter { $0.resistance >= 7.0 }
                .sorted { $0.resistance > $1.resistance }
        }
    }
    
    // MARK: - Header
    private var headerView: some View {
        VStack(spacing: 8) {
            HStack {
                Text("📝 Craving Logs")
                    .font(CraveTheme.Typography.heading)
                    .foregroundColor(CraveTheme.Colors.primaryText)
                Spacer()
                Menu {
                    Button("Sort by Date") {
                        // TODO
                    }
                    Button("Sort by Intensity") {
                        // TODO
                    }
                    Button("Sort by Resistance") {
                        // TODO
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.system(size: 20))
                        .foregroundColor(CraveTheme.Colors.primaryText)
                }
            }
            
            Text("Track to understand your cravings over time")
                .font(CraveTheme.Typography.subheading)
                .foregroundColor(CraveTheme.Colors.secondaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(CraveTheme.Colors.primaryGradient)
    }
    
    // MARK: - Search & Filter
    private var searchAndFilterBar: some View {
        VStack(spacing: 8) {
            // Search Field
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search cravings", text: $searchText)
                    .foregroundColor(CraveTheme.Colors.primaryText)
                
                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(8)
            .background(Color.black.opacity(0.2))
            .cornerRadius(10)
            
            // Filter Chips
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(CravingFilter.allCases) { filter in
                        FilterChip(
                            title: filter.rawValue,
                            isSelected: selectedFilter == filter
                        ) {
                            withAnimation {
                                selectedFilter = filter
                            }
                            CraveHaptics.shared.selectionChanged()
                        }
                    }
                }
                .padding(.vertical, 8)
            }
        }
    }
    
    // MARK: - Loading
    private var loadingView: some View {
        VStack {
            Spacer()
            ProgressView()
                .progressViewStyle(
                    CircularProgressViewStyle(tint: CraveTheme.Colors.accent)
                )
                .scaleEffect(1.5)
            Text("Loading cravings...")
                .font(CraveTheme.Typography.body)
                .foregroundColor(CraveTheme.Colors.secondaryText)
                .padding(.top, 16)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Empty
    private var emptyCravingsView: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(
                    CraveTheme.Colors.accent.opacity(0.7)
                )
            Text(
                searchText.isEmpty
                    ? "No cravings logged yet"
                    : "No matching cravings found"
            )
            .font(CraveTheme.Typography.subheading)
            .foregroundColor(CraveTheme.Colors.primaryText)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - FilterChip
    struct FilterChip: View {
        let title: String
        let isSelected: Bool
        let onTap: () -> Void
        
        var body: some View {
            Text(title)
                .font(
                    .system(size: 14, weight: isSelected ? .semibold : .regular)
                )
                .foregroundColor(
                    isSelected
                        ? CraveTheme.Colors.accent
                        : CraveTheme.Colors.primaryText
                )
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(
                            isSelected
                                ? CraveTheme.Colors.accent.opacity(0.2)
                                : Color.black.opacity(0.3)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(
                                    isSelected
                                        ? CraveTheme.Colors.accent
                                        : Color.gray.opacity(0.5),
                                    lineWidth: 1
                                )
                        )
                )
                .onTapGesture {
                    onTap()
                }
        }
    }
}


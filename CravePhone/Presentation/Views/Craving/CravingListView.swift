//=================================================
//  CravingListView.swift
//  CravePhone
//
//  PURPOSE:
//    - Display a searchable list of cravings, with filter chips for intensity/recent.
//    - Entire background ignores safe areas + keyboard edges.
//
//  ARCHITECTURE (SOLID):
//    - Single Responsibility: Show + filter cravings.
//
//  "DESIGNED FOR STEVE JOBS":
//    - Minimal friction, smooth transitions, clarity.
//
//  LAST UPDATED: <today's date>
//=================================================
import SwiftUI

struct CravingListView: View {
    // MARK: - Observed ViewModel
    @ObservedObject var viewModel: CravingListViewModel
    
    // MARK: - Local State
    @State private var searchText = ""
    @State private var selectedFilter: CravingFilter = .all
    
    // MARK: - Filter Enum
    enum CravingFilter: String, CaseIterable, Identifiable {
        case all          = "All"
        case high         = "High Intensity"
        case recent       = "Recent"
        
        var id: String { self.rawValue }
    }
    
    // MARK: - View Body
    var body: some View {
        ZStack {
            // Full-bleed gradient background + keyboard safe-area fix
            CraveTheme.Colors.primaryGradient
                .ignoresSafeArea(.all)
                .ignoresSafeArea(.keyboard, edges: .bottom)

            VStack(spacing: 0) {
                // Header
                headerView
                
                // Search & Filter Bar
                searchAndFilterBar
                    .padding(.horizontal)
                    .padding(.top, 8)
                    .padding(.bottom, 4)
                
                // Main Content
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
                                        Button("View Details") {}
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
        // Show any alerts triggered by the ViewModel
        .alert(item: $viewModel.alertInfo) { info in
            Alert(
                title: Text(info.title),
                message: Text(info.message),
                dismissButton: .default(Text("OK"))
            )
        }
        .onAppear {
            // Fetch cravings when this view appears
            Task { await viewModel.fetchCravings() }
        }
    }
    
    // MARK: - Filter Logic
    private var filteredCravings: [CravingEntity] {
        let cravings = viewModel.cravings
        
        // 1) Search-based filter
        let searchFiltered = searchText.isEmpty
            ? cravings
            : cravings.filter {
                $0.cravingDescription.lowercased()
                    .contains(searchText.lowercased())
            }
        
        // 2) Additional filter type
        switch selectedFilter {
        case .all:
            return searchFiltered
        case .high:
            return searchFiltered.filter { $0.intensity >= 7.0 }
        case .recent:
            let oneWeekAgo = Calendar.current.date(
                byAdding: .day,
                value: -7,
                to: Date()
            ) ?? Date()
            return searchFiltered.filter { $0.timestamp >= oneWeekAgo }
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        VStack(spacing: 8) {
            HStack {
                Text("📝 Craving Logs")
                    .font(CraveTheme.Typography.heading)
                    .foregroundColor(CraveTheme.Colors.primaryText)
                Spacer()
                Menu {
                    Button("Sort by Date") {}
                    Button("Sort by Intensity") {}
                    Button("Sort by Resistance") {}
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
        // Gradient behind the header
        .background(CraveTheme.Colors.primaryGradient)
    }
    
    // MARK: - Search & Filter Bar
    private var searchAndFilterBar: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search cravings", text: $searchText)
                    .foregroundColor(CraveTheme.Colors.primaryText)
                
                // Clear search icon
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
            
            // Filter chips
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
    
    // MARK: - Loading View
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
    
    // MARK: - Empty Cravings View
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
    
    // MARK: - Filter Chip
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

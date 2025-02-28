//
//  DependencyContainer.swift
//  CravePhone
//
//  Description:
//    The master container for all dependencies in the phone app.
//    Updated to fix the missing constructor params for AnalyticsManager.
//
//  Uncle Bob + Steve Jobs notes:
//    - Clean architecture: separate construction from usage.
//    - Minimal, Apple-like design: each dependency is clearly labeled,
//      so the code is easy to read and expand.
//
import SwiftUI
import SwiftData

@MainActor
public final class DependencyContainer: ObservableObject {
    
    @Published private(set) var modelContainer: ModelContainer
    
    // MARK: - Existing: Craving (Phone) Dependencies
    private lazy var cravingManager: CravingManager = {
        CravingManager(modelContext: modelContainer.mainContext)
    }()
    
    private lazy var cravingRepository: CravingRepository = {
        CravingRepositoryImpl(cravingManager: cravingManager)
    }()
    
    // MARK: - NEW: Analytics + AI Chat
    // 1) Storage (Placeholder or Real Implementation)
    private lazy var analyticsStorage: AnalyticsStorageProtocol = {
        // If you already have a real class (e.g. `AnalyticsStorage.swift`) that implements
        // `AnalyticsStorageProtocol`, replace `LocalAnalyticsStorage()` with it:
        return LocalAnalyticsStorage()
    }()
    
    // 2) Mapper
    private lazy var analyticsMapper: AnalyticsMapper = {
        AnalyticsMapper()
    }()
    
    // 3) Analytics Repository
    private lazy var analyticsRepository: AnalyticsRepositoryProtocol = {
        AnalyticsRepositoryImpl(storage: analyticsStorage, mapper: analyticsMapper)
    }()
    
    // 4) Analytics Aggregator
    private lazy var analyticsAggregator: AnalyticsAggregatorProtocol = {
        AnalyticsAggregatorImpl(storage: analyticsStorage)
    }()
    
    // 5) Pattern Detection
    private lazy var patternDetectionService: PatternDetectionServiceProtocol = {
        PatternDetectionServiceImpl(
            storage: analyticsStorage,
            configuration: analyticsConfig
        )
    }()
    
    // 6) Analytics Configuration
    private lazy var analyticsConfig: AnalyticsConfiguration = {
        // Use `AnalyticsConfiguration.shared` or create a fresh instance:
        //   AnalyticsConfiguration()
        // but typically you want a single shared config:
        return AnalyticsConfiguration.shared
    }()
    
    // 7) Analytics Manager
    private lazy var analyticsManager: AnalyticsManager = {
        AnalyticsManager(
            repository: analyticsRepository,
            aggregator: analyticsAggregator,
            patternDetection: patternDetectionService
        )
    }()
    
    // MARK: - AI Chat Dependencies
    private lazy var apiClient: APIClient = {
        APIClient()
    }()
    private lazy var baseURL: URL = {
        // Replace with your actual server URL
        URL(string: "https://your-crave-backend.com")!
    }()
    private lazy var aiChatRepository: AiChatRepositoryProtocol = {
        AiChatRepositoryImpl(apiClient: apiClient, baseURL: baseURL)
    }()
    private lazy var aiChatUseCase: AiChatUseCaseProtocol = {
        AiChatUseCase(repository: aiChatRepository)
    }()
    
    // MARK: - SwiftData Initialization
    public init() {
        // This might differ if you use `sharedModelContainer` from your code;
        // adjust as needed to create your container properly.
        let schema = Schema([CravingEntity.self, AnalyticsMetadata.self])
        do {
            self.modelContainer = try ModelContainer(for: schema)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
    
    // MARK: - Factory Methods
    private func makeAddCravingUseCase() -> AddCravingUseCaseProtocol {
        AddCravingUseCase(cravingRepository: cravingRepository)
    }
    
    private func makeFetchCravingsUseCase() -> FetchCravingsUseCaseProtocol {
        FetchCravingsUseCase(cravingRepository: cravingRepository)
    }
    
    private func makeArchiveCravingUseCase() -> ArchiveCravingUseCaseProtocol {
        ArchiveCravingUseCase(cravingRepository: cravingRepository)
    }
    
    // MARK: - Public Factories
    // (Craving)
    public func makeLogCravingViewModel() -> LogCravingViewModel {
        // FIXED: Changed parameter name from addCravingUseCase to cravingUseCase
        LogCravingViewModel(cravingUseCase: makeAddCravingUseCase())
    }
    
    public func makeCravingListViewModel() -> CravingListViewModel {
        CravingListViewModel(
            fetchCravingsUseCase: makeFetchCravingsUseCase(),
            archiveCravingUseCase: makeArchiveCravingUseCase()
        )
    }
    
    // (Analytics)
    public func makeAnalyticsViewModel() -> AnalyticsViewModel {
        AnalyticsViewModel(manager: analyticsManager)
    }
    
    // (AI Chat)
    public func makeChatViewModel() -> ChatViewModel {
        ChatViewModel(aiChatUseCase: aiChatUseCase)
    }
}

// MARK: - Placeholder Implementation for AnalyticsStorageProtocol
// If you have a real class that implements `AnalyticsStorageProtocol`,
// remove this and replace with your actual storage.
private final class LocalAnalyticsStorage: AnalyticsStorageProtocol {
    
    func store(_ event: AnalyticsDTO) async throws {
        // TODO: Save the event to SwiftData or a local DB
    }
    
    func fetchEvents(from startDate: Date, to endDate: Date) async throws -> [AnalyticsDTO] {
        // TODO: Query your local store
        return []
    }
    
    func fetchEvents(ofType eventType: String) async throws -> [AnalyticsDTO] {
        // TODO: Query your local store
        return []
    }
    
    func fetchMetadata(forCravingId cravingId: UUID) async throws -> AnalyticsMetadata? {
        // TODO: Query your local store
        return nil
    }
    
    func update(metadata: AnalyticsMetadata) async throws {
        // TODO: Update metadata
    }
    
    func storeBatch(_ events: [AnalyticsDTO]) async throws {
        // TODO: Save multiple events
    }
    
    func cleanupData(before date: Date) async throws {
        // TODO: Delete old data
    }
}

//
//  DependencyContainer.swift
//  CravePhone/PhoneApp/DI
//
//  UNCLE BOB BANGER VERSION - FULLY FIXED AND COMMENTED
//  This is the definitive, correct implementation that properly configures
//  the SwiftData schema to include ALL model types. This prevents the
//  persistence issues that were causing analytics data to disappear.
//
//  CLEAN/SOLID/GOF PRINCIPLES APPLIED:
//  - Dependency Injection (DI): All dependencies are created and injected here
//  - Single Responsibility (S): Each component has one clear purpose
//  - Open/Closed (O): Extend behavior without modifying (via protocols)
//  - Factory Method (GOF): Creates objects without specifying exact class
//
import SwiftUI
import SwiftData

@MainActor
public final class DependencyContainer: ObservableObject {
    
    // MARK: - Published: SwiftData ModelContainer
    // This is a published property so SwiftUI can react to changes
    @Published private(set) var modelContainer: ModelContainer
    
    // MARK: - ModelContext
    // Single shared context for all repositories
    private lazy var modelContext: ModelContext = {
        ModelContext(modelContainer)
    }()
    
    // MARK: - Craving Dependencies
    private lazy var cravingManager: CravingManager = {
        CravingManager(modelContext: modelContext)
    }()
    
    private lazy var cravingRepository: CravingRepository = {
        // CravingRepositoryImpl expects 'modelContext'
        CravingRepositoryImpl(modelContext: modelContext)
    }()
    
    // MARK: - Speech Dependencies
    private lazy var speechService: SpeechToTextServiceProtocol = {
        SpeechToTextServiceImpl()
    }()
    
    // MARK: - Analytics Dependencies
    private lazy var analyticsStorage: AnalyticsStorageProtocol = {
        // Uses the same modelContext as everything else for data consistency
        AnalyticsStorage(modelContext: modelContext)
    }()
    
    private lazy var analyticsRepository: AnalyticsRepository = {
        AnalyticsRepositoryImpl(storage: analyticsStorage)
    }()
    
    private lazy var analyticsAggregator: AnalyticsAggregatorProtocol = {
        AnalyticsAggregator()
    }()
    
    private lazy var analyticsConfig: AnalyticsConfiguration = {
        AnalyticsConfiguration.shared
    }()
    
    private lazy var patternDetectionService: PatternDetectionServiceProtocol = {
        PatternDetectionServiceImpl(
            storage: analyticsStorage,
            configuration: analyticsConfig
        )
    }()
    
    private lazy var analyticsManager: AnalyticsManager = {
        AnalyticsManager(
            repository: analyticsRepository,
            aggregator: analyticsAggregator,
            patternDetection: patternDetectionService
        )
    }()
    
    // MARK: - AI Chat Dependencies
    private lazy var backendClient: CraveBackendAPIClient = {
        CraveBackendAPIClient()
    }()
    
    private lazy var aiChatRepository: AiChatRepositoryProtocol = {
        AiChatRepositoryImpl(backendClient: backendClient)
    }()
    
    private lazy var aiChatUseCase: AiChatUseCaseProtocol = {
        AiChatUseCase(repository: aiChatRepository)
    }()
    
    // MARK: - Init
    // This is where the SwiftData schema is defined
    public init() {
        // CRITICAL FIX: ALL @Model classes MUST be included in this schema
        // If any @Model is missing, its data won't be persisted!
        let schema = Schema([
            CravingEntity.self,      // Persists CravingEntity
            AnalyticsMetadata.self,  // Persists AnalyticsMetadata
            AnalyticsDTO.self        // BANGER FIX: Persists AnalyticsDTO - previously missing!
        ])
        
        // Configure persistence: isStoredInMemoryOnly = false enables disk storage
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )
        
        do {
            // Create the container with our schema and configuration
            self.modelContainer = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
        } catch {
            // If this fails, the app can't function properly
            fatalError("CRITICAL ERROR: Failed to create ModelContainer: \(error)")
        }
    }
    
    // MARK: - Factory Methods (Dependency Injection)
    // These public methods provide ViewModels with their dependencies
    
    public func makeChatViewModel() -> ChatViewModel {
        ChatViewModel(aiChatUseCase: aiChatUseCase)
    }
    
    public func makeLogCravingViewModel() -> LogCravingViewModel {
        LogCravingViewModel(
            cravingRepo: cravingRepository,
            analyticsRepo: analyticsRepository,
            speechService: speechService
        )
    }
    
    public func makeCravingListViewModel() -> CravingListViewModel {
        CravingListViewModel(
            fetchCravingsUseCase: makeFetchCravingsUseCase(),
            archiveCravingUseCase: makeArchiveCravingUseCase()
        )
    }
    
    public func makeAnalyticsViewModel() -> AnalyticsViewModel {
        // This viewModel uses the analytics manager which now has properly persisted data
        AnalyticsViewModel(manager: analyticsManager)
    }
    
    // MARK: - Private: Craving Use Cases
    private func makeAddCravingUseCase() -> AddCravingUseCaseProtocol {
        AddCravingUseCase(cravingRepository: cravingRepository)
    }
    
    private func makeFetchCravingsUseCase() -> FetchCravingsUseCaseProtocol {
        FetchCravingsUseCase(cravingRepository: cravingRepository)
    }
    
    private func makeArchiveCravingUseCase() -> ArchiveCravingUseCaseProtocol {
        ArchiveCravingUseCase(cravingRepository: cravingRepository)
    }
}

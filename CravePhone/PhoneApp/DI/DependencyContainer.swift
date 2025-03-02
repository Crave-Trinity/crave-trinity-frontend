//=================================================================
// 6) DependencyContainer.swift
//   CravePhone/PhoneApp/DI/DependencyContainer.swift
//=================================================================

import SwiftUI
import SwiftData

@MainActor
public final class DependencyContainer: ObservableObject {
    // 1) Store the container
    @Published private(set) var modelContainer: ModelContainer
    
    // 2) Create a single ModelContext referencing that container
    private lazy var modelContext: ModelContext = {
        ModelContext(modelContainer)
    }()

    // MARK: - Craving
    private lazy var cravingManager: CravingManager = {
        // Use modelContext, not modelContainer.context
        CravingManager(modelContext: modelContext)
    }()
    
    private lazy var cravingRepository: CravingRepository = {
        CravingRepositoryImpl(manager: cravingManager)
    }()

    // MARK: - Analytics
    private lazy var analyticsStorage: AnalyticsStorageProtocol = {
        // Pass the same modelContext to AnalyticsStorage
        AnalyticsStorage(modelContext: modelContext)
    }()
    
    private lazy var analyticsMapper: AnalyticsMapper = {
        AnalyticsMapper()
    }()
    
    private lazy var analyticsRepository: AnalyticsRepositoryProtocol = {
        AnalyticsRepositoryImpl(storage: analyticsStorage, mapper: analyticsMapper)
    }()
    
    private lazy var analyticsAggregator: AnalyticsAggregatorProtocol = {
        AnalyticsAggregatorImpl(storage: analyticsStorage)
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
    
    // MARK: - AI Chat - No Changes needed here, this is correct
    private lazy var apiClient: APIClient = {
        APIClient()
    }()

    //No longer need baseURL here
    
    private lazy var aiChatRepository: AiChatRepositoryProtocol = {
        AiChatRepositoryImpl(apiClient: apiClient) // Pass only apiClient
    }()
    
    private lazy var aiChatUseCase: AiChatUseCaseProtocol = {
        AiChatUseCase(repository: aiChatRepository)
    }()
    
    // MARK: - Init
    public init() {
        // Define the schema from your model classes.
        let schema = Schema([CravingEntity.self, AnalyticsMetadata.self])
        
        // Create a ModelConfiguration
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )
        
        do {
            // Initialize the container
            self.modelContainer = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
    
    // MARK: - Public Factories
    public func makeChatViewModel() -> ChatViewModel {
        ChatViewModel(aiChatUseCase: aiChatUseCase)
    }
    
    public func makeLogCravingViewModel() -> LogCravingViewModel {
        LogCravingViewModel(cravingRepository: cravingRepository)
    }
    
    public func makeCravingListViewModel() -> CravingListViewModel {
        CravingListViewModel(
            fetchCravingsUseCase: makeFetchCravingsUseCase(),
            archiveCravingUseCase: makeArchiveCravingUseCase()
        )
    }
    
    public func makeAnalyticsViewModel() -> AnalyticsViewModel {
        AnalyticsViewModel(manager: analyticsManager)
    }
    
    // MARK: - Private Craving-Specific Use Cases
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

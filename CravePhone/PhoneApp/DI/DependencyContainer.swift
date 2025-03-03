//=================================================================
// 6) DependencyContainer.swift
//   CravePhone/PhoneApp/DI/DependencyContainer.swift
//=================================================================


import SwiftUI
import SwiftData

@MainActor
public final class DependencyContainer: ObservableObject {
    
    // MARK: - Published Properties
    @Published private(set) var modelContainer: ModelContainer
    
    // MARK: - ModelContext
    private lazy var modelContext: ModelContext = {
        ModelContext(modelContainer)
    }()
    
    // MARK: - Craving Dependencies
    private lazy var cravingManager: CravingManager = {
        CravingManager(modelContext: modelContext)
    }()
    
    private lazy var cravingRepository: CravingRepository = {
        CravingRepositoryImpl(manager: cravingManager)
    }()
    
    // MARK: - Speech Dependencies
    private lazy var speechService: SpeechToTextServiceProtocol = {
        SpeechToTextServiceImpl()
    }()
    
    // MARK: - Analytics Dependencies
    private lazy var analyticsStorage: AnalyticsStorageProtocol = {
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
    
    // MARK: - AI Chat Dependencies
    /// Replaces old `APIClient` with the new `CraveBackendAPIClient`
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
    public init() {
        // Here we set up SwiftData models
        let schema = Schema([
            CravingEntity.self,
            AnalyticsMetadata.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            self.modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
    
    // MARK: - Factory Methods
    
    /// Returns the main ChatViewModel
    public func makeChatViewModel() -> ChatViewModel {
        ChatViewModel(aiChatUseCase: aiChatUseCase)
    }
    
    /// Returns the Craving Log screen ViewModel
    public func makeLogCravingViewModel() -> LogCravingViewModel {
        LogCravingViewModel(
            cravingRepository: cravingRepository,
            speechService: speechService
        )
    }
    
    /// Returns the Craving List screen ViewModel
    public func makeCravingListViewModel() -> CravingListViewModel {
        CravingListViewModel(
            fetchCravingsUseCase: makeFetchCravingsUseCase(),
            archiveCravingUseCase: makeArchiveCravingUseCase()
        )
    }
    
    /// Returns the Analytics Dashboard screen ViewModel
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

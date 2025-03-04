//
//  DependencyContainer.swift
//  CravePhone/PhoneApp/DI
//
//  PURPOSE:
//    Master container for SwiftData-based repositories & services.
//    Creates all Repos and Use Cases in one place for easy injection.
//    (Assumes: CravingRepositoryImpl now uses init(modelContext: ModelContext),
//     AnalyticsRepositoryImpl now uses init(storage: AnalyticsStorageProtocol) with no mapper,
//     The unified aggregator is AnalyticsAggregator (returning BasicAnalyticsResult),
//     and LogCravingViewModel is initialized with cravingRepo, analyticsRepo, speechService.)
//
import SwiftUI
import SwiftData
@MainActor
public final class DependencyContainer: ObservableObject {
    
    // MARK: - Published: SwiftData ModelContainer
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
        // CravingRepositoryImpl expects 'modelContext'
        CravingRepositoryImpl(modelContext: modelContext)
    }()
    
    // MARK: - Speech Dependencies
    private lazy var speechService: SpeechToTextServiceProtocol = {
        SpeechToTextServiceImpl()
    }()
    
    // MARK: - Analytics Dependencies
    private lazy var analyticsStorage: AnalyticsStorageProtocol = {
        AnalyticsStorage(modelContext: modelContext)
    }()
    
    // Change from AnalyticsRepositoryProtocol to AnalyticsRepository
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
        // Now uses the consolidated AnalyticsRepository
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
    public init() {
        let schema = Schema([
            CravingEntity.self,
            AnalyticsMetadata.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            self.modelContainer = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
    
    // MARK: - Factory Methods
    public func makeChatViewModel() -> ChatViewModel {
        ChatViewModel(aiChatUseCase: aiChatUseCase)
    }
    
    public func makeLogCravingViewModel() -> LogCravingViewModel {
        // Updated initializer: expects 'cravingRepo', 'analyticsRepo', and 'speechService'
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

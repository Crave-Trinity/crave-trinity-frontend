//
// File: CravePhone/PhoneApp/DI/DependencyContainer.swift
// PURPOSE: Single source of truth for object creation.
// UNCLE BOB + STEVE JOBS STYLE – COMPLETE PASTE & RUN
//
import SwiftUI
import SwiftData

@MainActor
internal final class DependencyContainer: ObservableObject {
    
    // MARK: - SwiftData Model Container
    @Published private(set) var modelContainer: ModelContainer
    private lazy var modelContext: ModelContext = modelContainer.mainContext
    
    // MARK: - Cravings
    private lazy var cravingRepository: CravingRepository = {
        CravingRepositoryImpl(modelContext: modelContext)
    }()
    
    // MARK: - Analytics
    private lazy var analyticsStorage: AnalyticsStorageProtocol = {
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
    
    // MARK: - AI Chat
    private lazy var backendClient: CraveBackendAPIClient = {
        CraveBackendAPIClient()
    }()
    
    private lazy var aiChatRepository: AiChatRepositoryProtocol = {
        AiChatRepositoryImpl(backendClient: backendClient)
    }()
    
    private lazy var aiChatUseCase: AiChatUseCaseProtocol = {
        AiChatUseCase(repository: aiChatRepository)
    }()
    
    // MARK: - Auth
    private lazy var authRepository: AuthRepository = {
        AuthRepositoryImpl(backendClient: backendClient)
    }()
    
    // MARK: - Initialization
    internal init() {
        // Configure SwiftData schema for domain objects
        let schema = Schema([
            CravingEntity.self,
            AnalyticsMetadata.self,
            AnalyticsDTO.self
        ])
        
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )
        do {
            self.modelContainer = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
        } catch {
            fatalError("CRITICAL ERROR: Failed to create ModelContainer: \(error)")
        }
    }
    
    // MARK: - Factory Methods for ViewModels
    // All internal, returning internal or private types.
    
    internal func makeChatViewModel() -> ChatViewModel {
        ChatViewModel(aiChatUseCase: aiChatUseCase)
    }
    
    internal func makeLogCravingViewModel() -> LogCravingViewModel {
        LogCravingViewModel(
            cravingRepo: cravingRepository,
            analyticsRepo: analyticsRepository,
            speechService: SpeechToTextServiceImpl()
        )
    }
    
    internal func makeCravingListViewModel() -> CravingListViewModel {
        CravingListViewModel(cravingRepo: cravingRepository)
    }
    
    internal func makeAnalyticsViewModel() -> AnalyticsViewModel {
        AnalyticsViewModel(manager: analyticsManager)
    }
    
    internal func makeSplashViewModel(coordinator: AppCoordinator) -> SplashViewModel {
        SplashViewModel(coordinator: coordinator)
    }
    
    internal func makeLoginViewModel(coordinator: AppCoordinator) -> LoginViewModel {
        LoginViewModel(authRepository: authRepository, coordinator: coordinator)
    }
}

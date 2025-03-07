// File: CravePhone/PhoneApp/DI/DependencyContainer.swift
// PURPOSE: Acts as the single source of truth for object creation.
//          All dependencies are created and injected here so that the rest of the app remains decoupled.
import SwiftUI
import SwiftData

@MainActor
public final class DependencyContainer: ObservableObject {
    
    // MARK: - SwiftData Model Container
    @Published private(set) var modelContainer: ModelContainer
    // Use the container's mainContext for our repositories.
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
    
    // MARK: - Auth (Google OAuth and Email/Password)
    // Notice how we inject the backend client into AuthRepositoryImpl.
    private lazy var authRepository: AuthRepository = {
        AuthRepositoryImpl(backendClient: backendClient)
    }()
    
    // MARK: - Initialization
    public init() {
        // Configure SwiftData schema for our domain objects.
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
    
    func makeChatViewModel() -> ChatViewModel {
        ChatViewModel(aiChatUseCase: aiChatUseCase)
    }
    
    func makeLogCravingViewModel() -> LogCravingViewModel {
        LogCravingViewModel(
            cravingRepo: cravingRepository,
            analyticsRepo: analyticsRepository,
            speechService: SpeechToTextServiceImpl()
        )
    }
    
    func makeCravingListViewModel() -> CravingListViewModel {
        CravingListViewModel(cravingRepo: cravingRepository)
    }
    
    func makeAnalyticsViewModel() -> AnalyticsViewModel {
        AnalyticsViewModel(manager: analyticsManager)
    }
    
    func makeSplashViewModel(coordinator: AppCoordinator) -> SplashViewModel {
        SplashViewModel(coordinator: coordinator)
    }
    
    // Factory method for creating LoginViewModel
    // Now requires an AppCoordinator to enable navigation upon login
    func makeLoginViewModel(coordinator: AppCoordinator) -> LoginViewModel {
        LoginViewModel(authRepository: authRepository, coordinator: coordinator)
    }
}

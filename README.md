# CRAVE-TRINITY 🍒 MVP — Personalized Cravings Management App

**CRAVE-Trinity** is a watchOS/iOS/VisonOS stack built with **SwiftUI**/**SwiftData**, helping you track and manage your cravings through a clean, intuitive interface. Whether it’s late-night snacks or midday munchies, CRAVE ensures you stay in control.

<h3 align="center">CraveyWatch Demo</h3>
<p align="center">
    <img src="https://raw.githubusercontent.com/The-Obstacle-Is-The-Way/crave-trinity/main/CravePhone/Resources/Images/CraveyWatchDemo.gif" width="350"/>
</p>
<p align="center"><em>Seamless craving logging with a tap on your Apple Watch.</em></p>

📄 YC MVP Planning Document → https://docs.google.com/document/d/1kcK9C_-ynso44XMNej9MHrC_cZi7T8DXjF1hICOXOD4/edit?tab=t.0 

📄 Timeline of commits:
* 📌 **Feb 12–13:** [**CRAVE** (iOS MVP)](https://github.com/The-Obstacle-Is-The-Way/CRAVECRAVE) – Zero to basic SwiftUI app, craving logging.  
* 📌 **Feb 14–15:** [**crave-refactor** (Clean Architecture)](https://github.com/The-Obstacle-Is-The-Way/crave-refactor) – SwiftData + analytics debugging, major refactor.  
* 📌 **Feb 16–18:** [**isolated-crave-watch** (Apple Watch MVP)](https://github.com/The-Obstacle-Is-The-Way/isolated-crave-watch) – On-wrist craving logging, watch-to-phone sync.  
* 📌 **Feb 19:** [**crave-trinity** (Unified iOS + Watch + Vision)](https://github.com/The-Obstacle-Is-The-Way/crave-trinity) – Single codebase with AR/VR hooks for future expansion.

💡 Built in 7 days from scratch while learning Swift with AI acceleration and basecode abstraction. 
* Commit history proves my iteration speed—over 200 solving real programming problems. It wasn’t just copy-pasta spaghetti; I debugged, refactored, and solved SwiftData issues. I can learn, execute fast, and build something real. The marathon continues.

---

### **From humble MVP to Unicorn**  
📍 CRAVE has the potential to scale from simple B2C to aggregated population level data analytics 

<p align="center">
    <img src="https://raw.githubusercontent.com/The-Obstacle-Is-The-Way/crave-trinity/main/CravePhone/Resources/Images/high-vision-one-png.png" alt="CRAVE Vision" width="100%"/>
</p>

---

### **Individualized care & Biopsychosocial framework**
📍 CRAVE starts as a simple app, but can integrate personalized care in the medical biopsychosocial framework. 

<p align="center">
    <img src="https://raw.githubusercontent.com/The-Obstacle-Is-The-Way/crave-trinity/main/CravePhone/Resources/Images/high-vision-two-png.png" alt="CRAVE Impact" width="100%"/>
</p>

---

📂 Project Structure

```bash
jj@Johns-MacBook-Pro-3 crave-trinity % tree -I ".git"
.
├── CravePhone
│   ├── Data
│   │   ├── DTOs
│   │   │   ├── AnalyticsDTO.swift
│   │   │   └── CravingDTO.swift
│   │   ├── DataSources
│   │   │   ├── Local
│   │   │   │   └── AnalyticsStorage.swift
│   │   │   └── Remote
│   │   │       ├── APIClient.swift
│   │   │       └── ModelContainer.swift
│   │   ├── Mappers
│   │   │   ├── AnalyticsMapper.swift
│   │   │   └── CravingMapper.swift
│   │   └── Repositories
│   │       ├── AnalyticsAggregatorImpl.swift
│   │       ├── AnalyticsRepositoryImpl.swift
│   │       ├── CravingManager.swift
│   │       ├── CravingRepositoryImpl.swift
│   │       └── PatternDetectionServiceImpl.swift
│   ├── Domain
│   │   ├── Entities
│   │   │   ├── Analytics
│   │   │   │   ├── AnalyticsEntity.swift
│   │   │   │   ├── AnalyticsEvent.swift
│   │   │   │   ├── AnalyticsMetadata.swift
│   │   │   │   └── BasicAnalyticsResult.swift
│   │   │   └── Craving
│   │   │       ├── CravingEntity.swift
│   │   │       └── CravingEvent.swift
│   │   ├── Interfaces
│   │   │   ├── Analytics
│   │   │   │   ├── AnalyticsAggregatorProtocol.swift
│   │   │   │   ├── AnalyticsRepositoryProtocol.swift
│   │   │   │   ├── AnalyticsStorageProtocol.swift
│   │   │   │   └── PatternDetectionServiceProtocol.swift
│   │   │   └── Repositories
│   │   │       ├── AnalyticsRepository.swift
│   │   │       └── CravingRepository.swift
│   │   ├── Services
│   │   └── UseCases
│   │       ├── Analytics
│   │       │   ├── AnalyticsAggregator.swift
│   │       │   ├── AnalyticsManager.swift
│   │       │   ├── AnalyticsProcessor.swift
│   │       │   ├── AnalyticsService.swift
│   │       │   ├── AnalyticsUseCases.swift
│   │       │   ├── EventTrackingService.swift
│   │       │   └── PatternDetectionService.swift
│   │       ├── Craving
│   │       │   ├── CravingAnalyzer.swift
│   │       │   ├── CravingUseCases.swift
│   │       │   └── DummyAddCravingUseCase.swift
│   │       └── PhoneConnectivityService.swift
│   ├── PhoneApp
│   │   ├── DI
│   │   │   └── DependencyContainer.swift
│   │   ├── Navigation
│   │   │   ├── AppCoordinator.swift
│   │   │   └── CRAVETabView.swift
│   │   └── PhoneApp.swift
│   ├── Presentation
│   │   ├── Common
│   │   │   ├── AlertInfo.swift
│   │   │   ├── DesignSystem
│   │   │   │   ├── Components
│   │   │   │   │   ├── CraveHaptics.swift
│   │   │   │   │   ├── CraveMinimalButton.swift
│   │   │   │   │   └── CraveTextEditor.swift
│   │   │   │   └── CraveTheme.swift
│   │   │   └── Extensions
│   │   │       ├── Date+Extensions.swift
│   │   │       └── View+Extensions.swift
│   │   ├── Configuration
│   │   │   ├── AnalyticsConfiguration+Defaults.swift
│   │   │   └── AnalyticsConfiguration.swift
│   │   ├── ViewModels
│   │   │   ├── Analytics
│   │   │   │   ├── AnalyticsDashboardViewModel.swift
│   │   │   │   └── AnalyticsViewModel.swift
│   │   │   └── Craving
│   │   │       ├── CravingListViewModel.swift
│   │   │       └── LogCravingViewModel.swift
│   │   └── Views
│   │       ├── Analytics
│   │       │   ├── AnalyticsDashboardView.swift
│   │       │   └── Components
│   │       │       ├── AnalyticsCharts.swift
│   │       │       ├── AnalyticsInsight.swift
│   │       │       └── InfiniteMarqueeTextView.swift
│   │       └── Craving
│   │           ├── Components
│   │           │   └── CravingCard.swift
│   │           ├── CoordinatorHostView.swift
│   │           ├── CravingIntensitySlider.swift
│   │           ├── CravingListView.swift
│   │           └── LogCravingView.swift
│   ├── Resources
│   │   ├── Assets.xcassets
│   │   │   ├── AccentColor.colorset
│   │   │   │   └── Contents.json
│   │   │   ├── AppIcon.appiconset
│   │   │   │   └── Contents.json
│   │   │   └── Contents.json
│   │   ├── Docs
│   │   │   ├── AnalyticsAPIReference.md
│   │   │   ├── AnalyticsArchitechture.md
│   │   │   └── AnalyticsImplementationGuide.md
│   │   ├── Images
│   │   │   ├── crave-architecture.svg
│   │   │   ├── crave-execution-flow.svg
│   │   │   ├── crave-logging-flow.svg
│   │   │   ├── crave-navigation-states.svg
│   │   │   ├── high-vision-one.svg
│   │   │   └── high-vision-two.svg
│   │   └── Preview Content
│   │       └── Preview Assets.xcassets
│   │           └── Contents.json
│   └── Tests
│       ├── AnalyticsTests
│       │   ├── Data
│       │   │   ├── AnalyticsAggregatorTests.swift
│       │   │   ├── AnalyticsConfigurationTests.swift
│       │   │   ├── AnalyticsCoordinatorTests.swift
│       │   │   ├── AnalyticsManagerTests.swift
│       │   │   ├── AnalyticsProcessorTests.swift
│       │   │   └── AnalyticsStorageTests.swift
│       │   ├── Domain
│       │   │   ├── AnalyticsEventTests.swift
│       │   │   ├── AnalyticsInsightTests.swift
│       │   │   ├── AnalyticsPatternTests.swift
│       │   │   └── AnalyticsPredictionTests.swift
│       │   └── Integration
│       │       ├── AnalyticsModelTests.swift
│       │       └── CravingAnalyticsIntegrationTests.swift
│       ├── CravingTests
│       │   ├── CravingManagerTests.swift
│       │   ├── CravingModelTests.swift
│       │   └── InteractionDataTests.swift
│       ├── Domain
│       │   ├── CravePhoneUITests.swift
│       │   └── CravePhoneUITestsLaunchTests.swift
│       ├── Integration
│       │   ├── CravePhoneUITests.swift
│       │   └── CravePhoneUITestsLaunchTests.swift
│       └── UITests
│           ├── CravePhoneUITests.swift
│           └── CravePhoneUITestsLaunchTests.swift
├── CraveTrinity.xcodeproj
│   ├── project.pbxproj
│   ├── project.xcworkspace
│   │   ├── contents.xcworkspacedata
│   │   ├── xcshareddata
│   │   │   └── swiftpm
│   │   │       └── configuration
│   │   └── xcuserdata
│   │       └── jj.xcuserdatad
│   │           └── UserInterfaceState.xcuserstate
│   ├── xcshareddata
│   │   └── xcschemes
│   │       ├── CravePhone.xcscheme
│   │       └── CraveWatch Watch App.xcscheme
│   └── xcuserdata
│       └── jj.xcuserdatad
│           └── xcschemes
│               └── xcschememanagement.plist
├── CraveVision
│   ├── Assets.xcassets
│   │   ├── AccentColor.colorset
│   │   │   └── Contents.json
│   │   ├── AppIcon.solidimagestack
│   │   │   ├── Back.solidimagestacklayer
│   │   │   │   ├── Content.imageset
│   │   │   │   │   └── Contents.json
│   │   │   │   └── Contents.json
│   │   │   ├── Contents.json
│   │   │   ├── Front.solidimagestacklayer
│   │   │   │   ├── Content.imageset
│   │   │   │   │   └── Contents.json
│   │   │   │   └── Contents.json
│   │   │   └── Middle.solidimagestacklayer
│   │   │       ├── Content.imageset
│   │   │       │   └── Contents.json
│   │   │       └── Contents.json
│   │   └── Contents.json
│   ├── ContentView.swift
│   ├── CraveVisionApp.swift
│   ├── CraveVisionTests
│   │   └── CraveVisionTests.swift
│   ├── Info.plist
│   ├── Packages
│   │   └── RealityKitContent
│   │       ├── Package.realitycomposerpro
│   │       │   ├── ProjectData
│   │       │   │   └── main.json
│   │       │   └── WorkspaceData
│   │       │       ├── SceneMetadataList.json
│   │       │       └── Settings.rcprojectdata
│   │       ├── Package.swift
│   │       ├── README.md
│   │       └── Sources
│   │           └── RealityKitContent
│   │               ├── RealityKitContent.rkassets
│   │               │   ├── Materials
│   │               │   │   └── GridMaterial.usda
│   │               │   └── Scene.usda
│   │               └── RealityKitContent.swift
│   └── Preview Content
│       └── Preview Assets.xcassets
│           └── Contents.json
├── CraveWatch
│   ├── Core
│   │   ├── Data
│   │   │   ├── DataSources
│   │   │   │   └── Local
│   │   │   │       └── LocalCravingScore.swift
│   │   │   ├── Mappers
│   │   │   │   └── CravingMapper.swift
│   │   │   └── Repositories
│   │   │       └── CravingRepository.swift
│   │   ├── Domain
│   │   │   ├── Entities
│   │   │   │   └── WatchCravingEntity.swift
│   │   │   ├── Interfaces
│   │   │   │   └── CravingRepositoryProtocol.swift
│   │   │   ├── UseCases
│   │   │   │   ├── EmergencyTriggerUseCase.swift
│   │   │   │   ├── LogCravingUseCase.swift
│   │   │   │   └── LogVitalUseCase.swift
│   │   │   └── WatchCravingError.swift
│   │   ├── Presentation
│   │   │   ├── Common
│   │   │   │   └── WatchCraveTextEditor.swift
│   │   │   ├── ViewModels
│   │   │   │   ├── CravingLogViewModel.swift
│   │   │   │   ├── EmergencyTriggerViewModel.swift
│   │   │   │   └── VitalsViewModel.swift
│   │   │   └── Views
│   │   │       ├── Components
│   │   │       │   ├── VerticalIntensityBar.swift
│   │   │       │   └── VerticalToggleBar.swift
│   │   │       ├── CravingIntensityView.swift
│   │   │       ├── CravingLogView.swift
│   │   │       ├── CravingPagesView.swift
│   │   │       ├── EmergencyTriggerView.swift
│   │   │       └── VitalsView.swift
│   │   ├── Resources
│   │   │   ├── Assets.xcassets
│   │   │   │   ├── AccentColor.colorset
│   │   │   │   │   └── Contents.json
│   │   │   │   ├── AppIcon.appiconset
│   │   │   │   │   └── Contents.json
│   │   │   │   └── Contents.json
│   │   │   └── Preview Content
│   │   │       └── Preview Assets.xcassets
│   │   │           └── Contents.json
│   │   ├── Services
│   │   │   ├── OfflineCravingSyncManager.swift
│   │   │   ├── WatchConnectivityService.swift
│   │   │   └── WatchHapticManager.swift
│   │   └── Tests
│   │       ├── Integration
│   │       │   ├── MockWatchConnectivityService.swift
│   │       │   └── OfflineCravingSyncManagerTests.swift
│   │       └── Unit
│   │           ├── CravingLogViewModelTests.swift
│   │           ├── EmergencyTriggerViewModelTests.swift
│   │           └── VitalsViewModelTests.swift
│   └── WatchApp
│       ├── DI
│       │   └── WatchDependencyContainer.swift
│       ├── Navigation
│       │   └── WatchCoordinator.swift
│       └── WatchApp.swift
└── README.md
```
---

## Architecture

<img src="https://github.com/The-Obstacle-Is-The-Way/CRAVE/blob/main/CRAVEApp/Resources/Docs/Images/crave-architecture.svg" alt="CRAVE Architecture" width="100%"/>

---

## Logging Flow

<img src="https://github.com/The-Obstacle-Is-The-Way/CRAVE/blob/main/CRAVEApp/Resources/Docs/Images/crave-logging-flow.svg" alt="CRAVE Logging Flow" width="100%"/>

---

## Navigation States

<img src="https://github.com/The-Obstacle-Is-The-Way/CRAVE/blob/main/CRAVEApp/Resources/Docs/Images/crave-navigation-states.svg" alt="CRAVE Navigation States" width="100%"/>

---

## Code Execution Flow 

<img src="https://github.com/The-Obstacle-Is-The-Way/CRAVE/blob/main/CRAVEApp/Resources/Docs/Images/crave-execution-flow.svg" alt="CRAVE Execution Flow" width="100%"/>

---

*This MVP has a solid MVVM foundation, and I'm in the process of pivoting to find a technical cofounder for YC. Once that's secured, I'll revisit and refine the code further.*

## 🌟 Architecture & Features

### Data Layer
- **SwiftData Integration**: Harnesses `@Model` for modern persistence and efficient CRUD operations.  
- **Soft Deletions**: Archives cravings instead of fully removing them, preserving data for potential analytics.  
- **Data Manager**: A dedicated `CravingManager` ensures thread-safe data access and state consistency.

### Design System
- **Centralized Tokens**: Unified colors, typography, and spacing for a polished, cohesive design.  
- **Reusable Components**: Custom buttons, text editors, and haptic feedback helpers.  
- **Adaptive Layout**: Responsive UI that looks great on various iOS screens.

### Core Features
- **Quick Logging**: Rapid craving entry with instant persistence.  
- **Smart History**: Cravings are grouped by date, with friendly placeholders if no data exists.  
- **Easy Management**: Swipe-to-archive, bulk edits, and other intuitive actions keep your list tidy.

### Technical Excellence
- **MVVM Architecture**: Leverages `@Observable` for clean, scalable state management.  
- **Comprehensive Testing**: Unit tests, UI tests, and ephemeral in-memory data configurations using XCTest.  
- **Performance Focus**: Swift animations, minimal overhead, and optimized data fetches keep the app smooth.

---

## 🚀 Roadmap
💎 Ultra Dank Roadmap for Voice, AI, and Analytics Integration

---

### **Phase 1: iOS Voice Recording Integration**
**Goal:** Let users record, store, and access voice logs for cravings.

**Steps:**
- **Implement Voice Recording:**  
  Use iOS's AVFoundation to build a simple voice recorder within the LogCravingView.
- **Data Integration:**  
  Extend SwiftData models to store audio files alongside text-based craving logs.
- **UI/UX:**  
  Add a recording button/icon (🍒🎙️) that toggles recording and playback.

**Deliverable:**  
A basic voice recording feature fully integrated into the iOS app.

---

### **Phase 2: Apple Watch Connectivity & Voice Recording**
**Goal:** Enable seamless voice recording on the Apple Watch with connectivity to iOS.

**Steps:**
- **Develop a WatchKit Companion App:**  
  Create a watchOS interface for recording and managing voice logs.
- **Connectivity Pairing:**  
  Leverage WatchConnectivity to sync recordings between the watch and iOS.
- **Smooth Integration:**  
  Ensure the watchOS UI is minimal and intuitive with immediate feedback.

**Deliverable:**  
A fully functional Apple Watch app that pairs with the iOS app, capturing voice recordings on the go.

---

### **Phase 3: Whisper AI API Integration**
**Goal:** Automate transcription and initial analysis of voice recordings.

**Steps:**
- **Integrate Whisper API:**  
  Connect to the Whisper AI API to convert voice recordings to text.
- **Real-Time Transcription:**  
  Process recordings from both iOS and watchOS in near real-time.
- **Display & Storage:**  
  Show transcriptions alongside existing craving logs, with options to edit or annotate.

**Deliverable:**  
Transcribed voice logs seamlessly integrated into the app’s craving history.

---

### **Phase 4: Rudimentary AI Analysis Module**
**Goal:** Offer users optional, experimental insights from their voice logs and cravings.

**Steps:**
- **Develop a Sandbox AI Module:**  
  Create an untrained AI module to analyze text and audio data for patterns (frequency, tone, sentiment).
- **User Opt-In:**  
  Allow users to choose whether to run this experimental analysis.
- **Basic Insights:**  
  Display simple analytics or trends that indicate potential trigger patterns.

**Deliverable:**  
A rudimentary AI analysis feature providing basic, actionable insights based on users’ logs.

---

### **Phase 5: Advanced Internal AI Integration**
**Goal:** Build and integrate a custom AI model for deep analysis of cravings and recordings.

**Steps:**
- **Data Collection & Model Training:**  
  Use gathered user data (with consent) to train a custom AI model in a controlled environment.
- **Internal AI Module:**  
  Integrate the model into the app for real-time, advanced pattern recognition and insights.
- **UI/UX Enhancements:**  
  Optimize insight displays to be actionable and user-friendly.

**Deliverable:**  
A robust internal AI capability that augments user data with advanced insights and predictive analytics.

---

### **Phase 6: Advanced Analytics & Insight Integration**
**Goal:** Provide deep analytics on craving patterns with contextual data.

**Steps:**
- **Craving Analytics Dashboard:**  
  Build a dashboard to analyze date/time trends, frequency, and patterns in cravings.
- **Location Analysis (Opt-In):**  
  Integrate location services to track where cravings occur; include user opt-in for privacy.
- **Watch Vitals Analytics:**  
  Capture and analyze watch metrics (heart rate, activity) during craving events.
- **Data Visualization:**  
  Use charts and graphs to present analytics in a clean, minimal UI.

**Deliverable:**  
A comprehensive analytics module offering users actionable insights into their craving behavior, including temporal trends, location contexts, and physiological data from the watch.

---

### **🔥 Best Steps Forward**
- **Iterate & Test:**  
  Run UI tests and gather user feedback at every phase to keep data and UI in sync.
- **Documentation:**  
  Maintain thorough documentation to support iterative development and onboarding.
- **Technical Cofounder:**  
  Prioritize finding a technical cofounder for YC to accelerate MVP refinement.
- **MVP Focus:**  
  Nail core functionalities (voice recording and connectivity) before scaling AI and analytics features.

---

## ⚙️ Development

Built with:
- **SwiftUI**  
- **SwiftData**  
- **Combine**  
- **XCTest**

**Requirements**:
- iOS 17.0+  
- Xcode 15.0+

### Setup & Installation
1. **Clone the repository**:  
   ```bash
   git clone https://github.com/YOUR_USERNAME/CRAVE.git
   cd CRAVE
   ```
2. **Open in Xcode**:  
   Double-click `CRAVE.xcodeproj` or open it via `File > Open...`
3. **Run the project**:  
   Select a simulator or device, then press <kbd>Cmd</kbd> + <kbd>R</kbd>.
4. *(Optional)* **Run Tests**:  
   <kbd>Cmd</kbd> + <kbd>U</kbd> to execute unit and UI tests.

---

## 🤝 Contributing
1. **Fork** this repository  
2. **Create a new branch**:  
   ```bash
   git checkout -b feature-branch
   ```
3. **Commit your changes**:  
   ```bash
   git commit -m "Add new feature"
   ```
4. **Push the branch**:  
   ```bash
   git push origin feature-branch
   ```
5. **Submit a Pull Request** describing your changes.  
   
For issues, feature requests, or ideas, please [open an issue](https://github.com/YOUR_USERNAME/CRAVE/issues).

---

## 📄 License
This project is licensed under the [MIT License](LICENSE).

---

> **CRAVE**: Because understanding your cravings **shouldn’t** be complicated. 🍫  

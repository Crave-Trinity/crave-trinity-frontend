# CRAVE 🍒 MVP — Modern Cravings Management App

**CRAVE** is an iOS application built with **SwiftUI** and **SwiftData**, helping you track and manage your cravings through a clean, intuitive interface. Whether it’s late-night snacks or midday munchies, CRAVE ensures you stay in control.

📄 YC MVP Planning Document → https://docs.google.com/document/d/1kcK9C_-ynso44XMNej9MHrC_cZi7T8DXjF1hICOXOD4/edit?tab=t.0 

📄 Timeline of commits:
* 📌 Feb 12: Initial commit, setting up the repo.
* 📌 Feb 13: UI layout + basic craving logging.
* 📌 Feb 14: SwiftData persistence + analytics debugging.
* 📌 Feb 15: Major refactor, clean architecture improvements.
* 📌 Feb 16: First stable working build (still some runtime bugs).
* 📌 Feb 17: Refactored craving layer, dependency injection fixes.
* 📌 Feb 18: Apple Watch companion app added, craving syncing.
* 📌 Feb 19: Unified iOS + Watch into CRAVE Trinity.

* Leveraged AI to accelerate but made critical planning and logic decisions myself. 

💡 This was built in 7 days from scratch while learning Swift with AI assistance. The commit history proves my iteration speed—over 160 commits solving real programming problems. It wasn’t just AI-generated code; I debugged, refactored, and solved SwiftData persistence issues. I can execute fast, learn fast, and build something real. The marathon continues.

📂 Project Structure

```bash

CRAVE/
│   ├── CRAVE.xcodeproj
│   ├── CRAVE.xctestplan
│   └── README.md
CRAVEApp/
│   ├── CRAVEApp.swift
│   ├── ContentView.swift
│   ├── CRAVE.entitlements
│   └── README.md
├── Core/
│   ├── Configuration/
│   │   ├── AnalyticsConstants.swift
│   │   └── AnalyticsConfiguration.swift
│   ├── DependencyInjection/
│   │   └── EventTrackingService.swift
│   ├── DesignSystem/
│   │   ├── CRAVEDesignSystem.swift
│   │   └── Components/
│   │       ├── CraveButton.swift
│   │       └── CraveTextEditor.swift
│   ├── Extensions/
│   │   ├── Array+Analytics.swift
│   │   ├── Date+Analytics.swift
│   │   ├── Date+Extensions.swift
│   │   ├── Dictionary+Analytics.swift
│   │   └── View+Extensions.swift
│   └── Utils/
│       ├── AnalyticsTypes.swift
│       ├── AnalyticsError.swift
│       ├── AnalyticsFormatter.swift
│       └── AnalyticsTransformers.swift
├── Features/
│   ├── Analytics/
│   │   ├── Domain/
│   │   │   ├── Models/
│   │   │   │   ├── AnalyticsEvent.swift
│   │   │   │   ├── AnalyticsInsight.swift
│   │   │   │   ├── AnalyticsMetadata.swift
│   │   │   │   ├── AnalyticsPattern.swift
│   │   │   │   ├── AnalyticsPrediction.swift
│   │   │   │   ├── BasicAnalyticsResult.swift
│   │   │   │   └── ContextualData.swift
│   │   │   └── UseCases/
│   │   │       ├── AnalyticsProcessor.swift
│   │   │       ├── AnalyticsAggregator.swift
│   │   │       └── PatternDetectionService.swift
│   │   ├── Data/
│   │   │   ├── Repositories/
│   │   │   │   ├── AnalyticsStorage.swift
│   │   │   │   └── AnalyticsManager.swift
│   │   │   ├── Queries/
│   │   │   │   ├── CalendarViewQuery.swift
│   │   │   │   ├── FrequencyQuery.swift
│   │   │   │   ├── PatternQuery.swift
│   │   │   │   └── TimeOfDayQuery.swift
│   │   │   └── Coordinators/
│   │   │       ├── AnalyticsCoordinator.swift
│   │   │       └── AnalyticsReporter.swift
│   │   └── Presentation/
│   │       ├── Views/
│   │       │   ├── Dashboard/
│   │       │   │   └── AnalyticsDashboardView.swift
│   │       │   └── Components/
│   │       │       ├── AnalyticsInsightView.swift
│   │       │       ├── CalendarHeatmapView.swift
│   │       │       ├── CravingBarChart.swift
│   │       │       ├── PatternVisualizationView.swift
│   │       │       └── TimeOfDayPieChart.swift
│   │       └── ViewModels/
│   │           ├── AnalyticsDashboardViewModel.swift
│   │           └── AnalyticsViewModel.swift
│   └── Craving/
│       ├── Domain/
│       │   ├── Models/
│       │   │   ├── CravingModel.swift
│       │   │   └── InteractionData.swift
│       │   └── UseCases/
│       │       └── CravingAnalyzer.swift
│       ├── Data/
│       │   └── Repositories/
│       │       └── CravingManager.swift
│       └── Presentation/
│           ├── Views/
│           │   ├── List/
│           │   │   └── CravingListView.swift
│           │   ├── Logging/
│           │   │   └── LogCravingView.swift
│           │   └── DateView/
│           │       └── DateListView.swift
│           └── ViewModels/
│               ├── CravingListViewModel.swift
│               ├── LogCravingViewModel.swift
│               └── DateListViewModel.swift
├── Navigation/
│   └── CRAVETabView.swift
├── Resources/
│   ├── Assets.xcassets/
│   ├── Preview Content/
│   │   └── Preview Assets.xcassets
│   └── Docs/
│       ├── Images/
│       │   ├── crave-architecture.svg
│       │   ├── crave-logging-flow.svg
│       │   └── crave-navigation-states.svg
│       ├── AnalyticsAPIReference.md
│       ├── AnalyticsArchitecture.md
│       └── AnalyticsImplementationGuide.md
└── Tests/
    ├── AnalyticsTests/
    │   ├── Domain/
    │   │   ├── AnalyticsEventTests.swift
    │   │   ├── AnalyticsInsightTests.swift
    │   │   ├── AnalyticsPatternTests.swift
    │   │   └── AnalyticsPredictionTests.swift
    │   ├── Data/
    │   │   ├── AnalyticsAggregatorTests.swift
    │   │   ├── AnalyticsConfigurationTests.swift
    │   │   ├── AnalyticsCoordinatorTests.swift
    │   │   ├── AnalyticsManagerTests.swift
    │   │   ├── AnalyticsProcessorTests.swift
    │   │   └── AnalyticsStorageTests.swift
    │   └── Integration/
    │       ├── AnalyticsModelTests.swift
    │       └── CravingAnalyticsIntegrationTests.swift
    ├── CravingTests/
    │   ├── CravingManagerTests.swift
    │   ├── CravingModelTests.swift
    │   └── InteractionDataTests.swift
    └── UITests/
        └── CRAVEUITests.swift

```
---

## Architecture

<img src="https://github.com/The-Obstacle-Is-The-Way/CRAVE/blob/main/CRAVEApp/Resources/Docs/Images/crave-architecture.svg" alt="CRAVE Architecture" width="800"/>

---

## Logging Flow

<img src="https://github.com/The-Obstacle-Is-The-Way/CRAVE/blob/main/CRAVEApp/Resources/Docs/Images/crave-logging-flow.svg" alt="CRAVE Logging Flow" width="800"/>

---

## Navigation States

<img src="https://github.com/The-Obstacle-Is-The-Way/CRAVE/blob/main/CRAVEApp/Resources/Docs/Images/crave-navigation-states.svg" alt="CRAVE Navigation States" width="800"/>

---

## Code Execution Flow 

<img src="https://github.com/The-Obstacle-Is-The-Way/CRAVE/blob/main/CRAVEApp/Resources/Docs/Images/crave-execution-flow.svg" alt="CRAVE Execution Flow" width="800"/>

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

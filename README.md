# CRAVE-TRINITY 🍒 — Personalized Cravings Management App

**CRAVE-Trinity** is a watchOS/iOS/VisonOS stack built with **SwiftUI**/**SwiftData**, helping you track and manage your cravings through a clean, intuitive interface. Whether it’s late-night snacks or midday munchies, CRAVE ensures you stay in control.

![Cravey Watch Demo](https://github.com/The-Obstacle-Is-The-Way/crave-trinity/blob/main/CravePhone/Resources/Images/Final-Watch-Demo.gif)

🔗 [Full-size GIF]![Cravey Watch Demo](https://drive.google.com/file/d/1OluDCuwnkwV8Bofj7cBRgA2ltiRLjz7I/view?usp=share_link)

📄 YC MVP Planning Document → https://docs.google.com/document/d/1kcK9C_-ynso44XMNej9MHrC_cZi7T8DXjF1hICOXOD4/edit?tab=t.0 

📄 Timeline of commits:
* 📌 **Feb 12–13:** [**CRAVE** (iOS MVP)](https://github.com/The-Obstacle-Is-The-Way/CRAVECRAVE) – Zero to basic SwiftUI app, craving logging.  
* 📌 **Feb 14–15:** [**crave-refactor** (Clean Architecture)](https://github.com/The-Obstacle-Is-The-Way/crave-refactor) – SwiftData + analytics debugging, major refactor.  
* 📌 **Feb 16–18:** [**isolated-crave-watch** (Apple Watch MVP)](https://github.com/The-Obstacle-Is-The-Way/isolated-crave-watch) – On-wrist craving logging, watch-to-phone sync.  
* 📌 **Feb 19:** [**crave-trinity** (Unified iOS + Watch + Vision)](https://github.com/The-Obstacle-Is-The-Way/crave-trinity) – Single codebase with AR/VR hooks for future expansion.

💡 Built in 7 days from scratch while learning Swift with AI acceleration and basecode abstraction. 
* Commit history proves my iteration speed—over 200 solving real programming problems.
* It wasn’t just copy-pasta spaghetti; I debugged, refactored, and solved SwiftData issues. I can learn, execute fast, and build something real. The marathon continues.

---

## 🚀 CRAVE MVP – Finalized Architecture & Execution Plan  
### 📌 What We’re Shipping First 
CRAVE is an AI-powered craving analytics system, built to provide personalized behavioral analysis by combining user logs, RAG, and LoRA fine-tuning.  

* ✅ Apple Watch + iPhone App → Seamless craving logging.  
* ✅ Backend that processes & analyzes cravings, not just stores them.
* ✅ RAG (Retrieval-Augmented Generation) to personalize AI responses without costly fine-tuning.  
* ✅ LoRA (Low-Rank Adaptation) to fine-tune craving personas with minimal compute costs.
* ✅ A scalable backend with fast inference on AWS, using open-source models.

⚠️ Disclaimer: CRAVE intends to provide analytical **insights** based on user-logged cravings data. 
- It will not offer medical predictions, diagnoses, or treatment prior to FDA SaMD approval.
- Any behavioral insights should be viewed as informational only, and users should consult a healthcare professional for medical or therapeutic guidance.

---

## 🚀 CRAVE AI - Finalized Tech Stack  

### **1️⃣ Core Tech Stack**
| **Component**            | **Technology**                                      | **Rationale**  |
|-------------------------|--------------------------------------------------|---------------|
| **LLM Model**           | **Llama 2 (13B) on AWS**                         | Best open-source model that supports LoRA fine-tuning. Not restricted like GPT-4. |
| **Vector Database**      | **Pinecone**                                     | Production-grade, built for high-performance retrieval at scale. |
| **Embeddings**          | **OpenAI `text-embedding-ada-002`**               | Best semantic search embeddings for RAG. |
| **Fine-Tuning Framework** | **LoRA (Low-Rank Adaptation) via PyTorch + Hugging Face `peft`** | Allows persona-level fine-tuning without massive compute costs. |
| **RAG Pipeline**        | **LangChain**                                    | Provides high-level abstractions for orchestrating retrieval, prompt assembly, and response generation. |
| **Backend & Deployment** | **Python (FastAPI) on AWS EC2/ECS**              | Python for ML, FastAPI for async speed, AWS for scalability. |
| **Structured Database**  | **PostgreSQL (AWS RDS)**                        | Stores craving logs, user metadata, and structured behavioral data for analytics & AI modeling. |

---

## 🚀 How It Works – End-to-End
### 1️⃣ Craving Data Ingestion
- Apple Watch + iPhone send craving logs** (timestamp, HRV, location, user mood, notes).  
- Stored in two places:
  - **PostgreSQL** (structured metadata like timestamps).  
  - **Pinecone** (embedded craving logs for retrieval).  

---

### 2️⃣ RAG Personalization – How AI Feels Personal Without Full Fine-Tuning 
🔹 **Process:**  
1. **User Query:** (“Why do I crave sugar at night?”)  
2. **Backend Embeds Query:** Uses `text-embedding-ada-002`.  
3. **Retrieves Relevant Logs:** Pinecone finds **most relevant past craving logs**.  
4. **Compiles Personalized Context:** LangChain **assembles user history + question into a structured prompt.**  
5. **LLM Generates a Response:** Feeds the **retrieved logs + user’s question** to Llama 2.  

✅ Ensures that AI responses feel personalized, without training a separate model per user.  

---

### 3️⃣ LoRA Fine-Tuning – Craving Archetypes for Deeper Personalization
🔹 **Why We Need This:**  
- RAG personalizes via past data, but doesn’t change how the AI "thinks." 
- LoRA lets us create craving-specific personas for better contextualization. 

🔹 **How It Works:**  
1. Users are categorized into **craving personas** (e.g., “Nighttime Binger,” “Stress Craver,” “Alcohol Dopamine-Seeker”).  
2. Each persona has a **lightweight LoRA adapter** fine-tuned on past craving data.  
3. **During inference**, we dynamically load the relevant LoRA adapter onto Llama 2.  
4. Final Response = RAG Retrieved Context + LoRA Fine-Tuned Persona + User Query.
✅ **This provides "adaptive" AI insights without massive per-user fine-tuning costs.** 

---

### 🚀 How we make real-time LoRA swapping work efficiently:
✅ Step 1: Load the Base Model into GPU Memory
- Load LLaMA 2 (13B) onto an AWS A100 GPU instance (or H100 if needed).

✅ Step 2: Preload the 2-3 Most Common LoRA Adapters in VRAM
- Track most-used craving personas and keep them loaded in GPU memory.
- Store remaining adapters in CPU RAM for fast retrieval.
  
✅ Step 3: Implement a Fast Cache System for LoRA Adapters
- Store adapters in Redis (or in-memory storage) for quick access.
- If not in VRAM, fetch from CPU RAM before disk.

✅ Step 4: Optimize LoRA Swapping for Concurrency
- Batch requests when multiple users need the same adapter.
- Queue unique adapter loads instead of swapping instantly.
  
✅ Step 5: Monitor GPU Usage & Tune for Performance
Implement profiling to see if we need more VRAM per instance.
If GPU becomes a bottleneck, scale horizontally by adding more instances.

---

### 4️⃣ Data Retention & Time-Based Prioritization
🔹 **Problem:** As users log cravings for months or years, **RAG retrieval becomes bloated.**  
🔹 **Solution:** Implement **time-weighted retrieval:**  
✅ Last 30 Days = High Priority Logs  
✅ Older Logs = Summarized & Compressed
✅ Historical Insights = Only Retrieved When Highly Relevant 

🔹 **How It Works:**  
- Recent cravings are fully stored & retrieved. 
- Older cravings get "trend compressed" (e.g., "In the last 6 months, sugar cravings spiked in winter").  
- Retrieval automatically prioritizes recent, high-relevance logs. 
✅ Prevents AI responses from becoming inefficient over time. 

---

## 🚀 Step-by-Step Execution Plan
### ✅ Step 1: Build the Data Pipeline
- Set up FastAPI endpoints for craving logs.  
- Integrate Pinecone to store craving text data.  
- Set up PostgreSQL (or DynamoDB) for structured craving metadata.  

### ✅ Step 2: Implement RAG for Personalized Craving Responses
- Install **LangChain + Pinecone** for retrieval.  
- Create a **retrieval chain** that injects user craving logs into AI prompts.  
- Connect the **retrieval chain to Llama 2** for personalized AI responses.  

### ✅ Step 3: Build LoRA Fine-Tuned Craving Personas
- Fine-tune **Llama 2 LoRA adapters for different craving archetypes** using Hugging Face `peft`.  
- Store LoRA adapters separately and **dynamically load them** per user persona.  

### ✅ Step 4: Deploy on AWS & Optimize for Real-Time Inference
- Launch **Llama 2 (13B) on an AWS GPU instance (g5.xlarge or A100-based).**  
- Set up **API endpoints** for craving insights.  
- Implement **RAG caching & batching** for efficiency.  

---

## 🚀 Why This Stack Wins
✅ **RAG ensures personalization without training individual models.**  
✅ **LoRA makes craving personas possible at low cost.**  
✅ **AWS GPU hosting means real-time inference at scale.**  
✅ **Python + FastAPI = Fast iteration speed & flexibility.**  
✅ **The architecture is built to scale, adapt, and improve.**  

---

## 🚀 Next Steps  
💥 **1️⃣ Find a visionary technical co-founder**  
💥 **2️⃣ Start implementing this backend architecture**  
💥 **3️⃣ Ship, Talk to Users, Iterate**  

---

### From humble MVP to Unicorn 
📍 CRAVE will scale from simple B2C to aggregated, HIPPA-compliant, population level data analytics (DaaS) 

<p align="center">
    <img src="https://raw.githubusercontent.com/The-Obstacle-Is-The-Way/crave-trinity/main/CravePhone/Resources/Images/high-vision-one-png.png" alt="CRAVE Vision" width="100%"/>
</p>

💡 Everyone is chasing B2B SaaS and agentic AI.
⚡️ We’re building for humans first—scaling to enterprises when the data speaks.  

## 1️⃣ How to Ensure CRAVE DaaS Is Ethical & “Do No Harm”
✅ 1. Full Anonymization & Aggregation  
- **We never sell individual user data.**  
- **Only aggregate craving insights** (e.g., "20% of users log sugar cravings after 8 PM").  
- Use **differential privacy techniques** (adding statistical noise) to prevent reverse engineering.  

✅ 2. No Behavioral Manipulation or Addiction Optimization  
- Some companies use DaaS for **exploitative targeting** (e.g., increasing fast-food cravings).  
- CRAVE **only licenses data for wellness, behavioral health, and research applications.**  
- **We refuse partnerships that explicitly aim to exploit cravings for higher sales.**  

✅ 3. Transparency & User Control
- Users should always know how their data is used. 
- Implement an **opt-in/opt-out model** where users choose whether their anonymized data contributes to research.  
- **Give users insights back**—our analytics should benefit the individual as much as the companies using it.  

✅ 4. Align With Research & Public Health Interests
- Partner with **NIH, public health agencies, & research orgs** to ensure data benefits addiction science.  
- **Monetization should come from ethical health/wellness-focused applications**, not impulse-driven consumerism.  

✅ 5. No Credit or Risk-Based Consumer Profiling
- Avoid partnerships where craving data could be **used against individuals** (e.g., credit scoring based on impulsive purchases).  
- We **don’t sell data to insurers, financial rik assessors, or predatory lenders.**  

---

Investors may think there’s no money in cravings management--they’re wrong.
- 💡 In 1-2 years, privacy-first, ethically sourced DaaS will be valuable; the market is shifting to trustworthy data sets. 
- Impulse control isn’t niche—it’s the **core of performance, addiction, stress, dopamine loops, and digital overstimulation.**  
- We start where others don’t: grassroots traction → AI-driven insights → B2B, healthcare, and digital therapeutics.

---

### 🔑 How We Win
✅ **Organic growth → AI-backed personalized insights → B2B healthcare SaaS**  
✅ **Turn cravings data into a next-gen addiction & impulse control platform**  
✅ **Make CRAVE as viral as Duolingo streaks—dopamine resilience at scale**  

---

### Individualized care & Biopsychosocial framework
📍 CRAVE will launch as a wellness analytics platform, scaling to personalized care in a medical biopsychosocial framework only after product-market validation and ensuring FDA SaMD hurdles are surmountable.

<p align="center">
    <img src="https://raw.githubusercontent.com/The-Obstacle-Is-The-Way/crave-trinity/main/CravePhone/Resources/Images/high-vision-two-privacy.png" alt="CRAVE Impact" width="100%"/>
</p>

---

📂 Project Structure

```bash
jj@Johns-MacBook-Pro-3 crave-trinity % tree -I ".git"
.
//  CRAVE
//  Because No One Should Have to Fight Alone.
//
//  In Memoriam:
//  - Juice WRLD (Jarad Higgins) [21]
//  - Lil Peep (Gustav Åhr) [21]
//  - Mac Miller (Malcolm McCormick) [26]
//  - Amy Winehouse [27]
//  - Jimi Hendrix [27]
//  - Heath Ledger [28]
//  - Chris Farley [33]
//  - Pimp C (Chad Butler) [33]
//  - Whitney Houston [48]
//  - Chandler Bing (Matthew Perry) [54]
//
//  And to all those lost to addiction,  
//  whose names are remembered in silence.  
//
//  Rest in power.  
//  This is for you.  
//
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

### Phase 1: iOS Voice Recording Integration
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

### Phase 2: Apple Watch Connectivity & Voice Recording
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

### Phase 3: Whisper AI API Integration
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

### Phase 4: Rudimentary AI Analysis Module
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

### Phase 5: Advanced Internal AI Integration
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

### Phase 6: Advanced Analytics & Insight Integration
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

### 🔥 Best Steps Forward
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

---

# 🚀 **Setup & Installation**  

### **Clone the Repository**  
```bash
git clone https://github.com/The-Obstacle-Is-The-Way/crave-trinity.git
cd crave-trinity
```

### **Install Dependencies**  
If using CocoaPods for package management, run:  
```bash
pod install
```

### **Open the Project in Xcode**  
Use the `.xcodeproj` file (if applicable, e.g., using CocoaPods or SPM):  
```bash
open CraveTrinity.xcodeproj
```
Or manually open Xcode and select **File > Open...**  

### **Run the App**  
1. Select a **simulator** or **device** in Xcode.  
2. Press **Cmd + R** to build and run.  

---

### **Notes**  
- `CravePhone` is the iOS app.  
- `CraveWatch` is the Apple Watch extension.  
- `CraveVision` handles future AR/VR components.  
- Backend repo: [TBD or link if separate]  
- Supports **Swift Package Manager (SPM)** and **MVVM + SOLID** architecture.  

---

## 🤝 **Contributing**  

1. **Fork** this repository.  
2. **Create a new branch** *(e.g., `feature/new-ui`, `fix/crash-on-login`)*:  
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. **Make your changes** and commit:  
   ```bash
   git commit -m "feat: Add [brief description of feature]"
   ```
4. **Push your branch**:  
   ```bash
   git push origin feature/your-feature-name
   ```
5. **Open a Pull Request** with a clear description of your changes.  

For issues, feature requests, or ideas, please [open an issue](https://github.com/The-Obstacle-Is-The-Way/crave-trinity/issues).  

---

⚠️ Disclaimer: CRAVE intends to provide analytical **insights** based on user-logged cravings data. 
- It will not offer medical predictions, diagnoses, or treatment prior to FDA SaMD approval.
- Any behavioral insights should be viewed as informational only, and users should consult a healthcare professional for medical or therapeutic guidance.

---

## 📄 License
This project is licensed under the [MIT License](LICENSE).

---

> **CRAVE**: Because understanding your cravings **shouldn’t** be complicated. 🍫  

// Core/Data/Services/EventTrackingService.swift
import Foundation
import Combine

final class EventTrackingService {  // No need for public here

    private let analyticsStorage: AnalyticsStorage // Corrected type

    init(analyticsStorage: AnalyticsStorage) {
        self.analyticsStorage = analyticsStorage
    }
}


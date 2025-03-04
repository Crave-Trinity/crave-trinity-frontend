//
//  AnalyticsEvent.swift
//  CravePhone
//
//  Description:
//    Protocol for any event the aggregator can handle.
//
import Foundation

public protocol AnalyticsEvent {
    var id: UUID { get }
    var timestamp: Date { get }
    var eventType: String { get }
    var metadata: [String: Any] { get }
}

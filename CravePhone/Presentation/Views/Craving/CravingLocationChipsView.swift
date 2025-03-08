//
// CravingLocationChipsView.swift
// CravePhone/Presentation/Views/Craving/CravingLocationChipsView.swift
//
// A SwiftUI subview that renders selectable chips for location:
//  - A special '📍 Current Location' chip attempts to fetch the device's location
//  - Other chips (Home, Work, Social, Outdoors, etc.) each have an emoji
//  - Uses white text for both selected/unselected states for improved contrast on dark backgrounds.
//  - Minimal location fetching logic is embedded below for demo purposes.
//    In production, you'd typically place location logic in a dedicated service.
//
//  NOTE: You must add 'NSLocationWhenInUseUsageDescription' to Info.plist.
import SwiftUI
import CoreLocation
public struct CravingLocationChipsView: View {
    @Binding var selectedLocation: String?
    
    // MARK: - Location Options
    // One special 'Current Location' + other example options with emojis
    private let locationChip = "📍 Current Location"
    private let options: [String] = [
        "📍Current",
        "🏠Home",
        "🏢Work",
        "🎉Social",
        "🌲Outside"
    ]
    
    // MARK: - Minimal Location Manager (for demo)
    @StateObject private var locationManager = LocationFetcher()
    
    // MARK: - Init
    public init(selectedLocation: Binding<String?>) {
        self._selectedLocation = selectedLocation
    }
    
    // MARK: - Body
    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(options, id: \.self) { location in
                    // Determine if this chip is selected
                    let isSelected = (selectedLocation == location)
                    
                    // Break the chain into sub-expressions for the compiler
                    
                    // 1. Base Text View
                    let textView = Text(location)
                        .font(.system(size: 14, weight: isSelected ? .semibold : .regular))
                        .foregroundColor(.white) // White text for clarity
                    
                    // 2. Padded View
                    let paddedView = textView
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                    
                    // 3. Background View with Capsule
                    let backgroundView = paddedView
                        .background(
                            Capsule().fill(
                                isSelected ? Color.blue : Color.white.opacity(0.15)
                            )
                        )
                    
                    // 4. Overlay with Capsule Stroke
                    let chipView = backgroundView
                        .overlay(
                            Capsule().stroke(
                                isSelected ? Color.blue : Color.white.opacity(0.5),
                                lineWidth: 1
                            )
                        )
                    
                    // Final chip view with tap gesture
                    chipView
                        .onTapGesture {
                            // Special handling for the 'Current Location' chip
                            if location == locationChip {
                                locationManager.requestLocation { fetchedLocation in
                                    if let fetchedLocation = fetchedLocation {
                                        // Example: store lat/lon as a string;
                                        // for production, consider geocoding for a user-friendly address.
                                        let lat = fetchedLocation.coordinate.latitude
                                        let lon = fetchedLocation.coordinate.longitude
                                        selectedLocation = "Lat: \(lat), Lon: \(lon)"
                                    } else {
                                        selectedLocation = "Location unavailable"
                                    }
                                }
                            } else {
                                // Normal toggling logic for other chips
                                if selectedLocation == location {
                                    selectedLocation = nil
                                } else {
                                    selectedLocation = location
                                }
                            }
                            CraveHaptics.shared.selectionChanged()
                        }
                }
            }
        }
        .onAppear {
            // Request location permission when the view appears.
            locationManager.requestAuthorization()
        }
    }
}
// MARK: - LocationFetcher
// A minimal CoreLocation manager to fetch a single location on demand.
// In a production app, consider a dedicated location service.
private class LocationFetcher: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    private var completion: ((CLLocation?) -> Void)?
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func requestAuthorization() {
        // Request 'when in use' authorization
        manager.requestWhenInUseAuthorization()
    }
    
    func requestLocation(completion: @escaping (CLLocation?) -> Void) {
        self.completion = completion
        manager.requestLocation()
    }
    
    // MARK: - CLLocationManagerDelegate Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        completion?(locations.first)
        completion = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        completion?(nil)
        completion = nil
    }
}


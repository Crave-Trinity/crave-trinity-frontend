//
// CravingLocationChipsView.swift
// CravePhone/Presentation/Views/Craving/CravingLocationChipsView.swift
//
// A SwiftUI subview for selecting one location (Home, Work, Social, Outdoors, etc.).
// Binds to @Published var selectedLocation: String? in the ViewModel.
//
import SwiftUI

public struct CravingLocationChipsView: View {
    @Binding var selectedLocation: String?
    
    // Example fixed set of location options
    private let options: [String] = [
        "Home", "Work", "Outdoors", "Social", "Other"
    ]
    
    public init(selectedLocation: Binding<String?>) {
        self._selectedLocation = selectedLocation
    }
    
    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(options, id: \.self) { location in
                    let isSelected = (selectedLocation == location)
                    
                    Text(location)
                        .font(.system(size: 14, weight: isSelected ? .semibold : .regular))
                        // Use white text for both states; adjust to taste.
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule().fill(
                                isSelected
                                    ? Color.blue
                                    // A darker background for unselected chips
                                    : Color.white.opacity(0.15)
                            )
                        )
                        .overlay(
                            Capsule().stroke(
                                isSelected
                                    ? Color.blue
                                    // A subtle white stroke on unselected
                                    : Color.white.opacity(0.5),
                                lineWidth: 1
                            )
                        )
                        .onTapGesture {
                            // Toggle selection
                            if selectedLocation == location {
                                selectedLocation = nil
                            } else {
                                selectedLocation = location
                            }
                            CraveHaptics.shared.selectionChanged()
                        }
                }
            }
        }
    }
}

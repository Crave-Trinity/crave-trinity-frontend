//
// CravingPeopleChipsView.swift
// CravePhone/Presentation/Views/Craving/CravingPeopleChipsView.swift
//
// A SwiftUI subview for selecting multiple "who you are with" (Alone, Family, etc.).
// Binds to @Published var selectedPeople: [String] in the ViewModel.
//
import SwiftUI

public struct CravingPeopleChipsView: View {
    @Binding var selectedPeople: [String]
    
    // Example set
    private let peopleOptions = [
        "🧍Alone", "👪 Family", "👫 Friends", "💼 Coworkers", "👥 Strangers"
    ]
    
    public init(selectedPeople: Binding<[String]>) {
        self._selectedPeople = selectedPeople
    }
    
    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(peopleOptions, id: \.self) { personType in
                    let isSelected = selectedPeople.contains(personType)
                    
                    Text(personType)
                        .font(.system(size: 14, weight: isSelected ? .semibold : .regular))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule().fill(
                                isSelected
                                    ? Color.purple
                                    : Color.white.opacity(0.15)
                            )
                        )
                        .overlay(
                            Capsule().stroke(
                                isSelected
                                    ? Color.purple
                                    : Color.white.opacity(0.5),
                                lineWidth: 1
                            )
                        )
                        .onTapGesture {
                            togglePerson(personType)
                            CraveHaptics.shared.selectionChanged()
                        }
                }
            }
        }
    }
    
    private func togglePerson(_ personType: String) {
        if let index = selectedPeople.firstIndex(of: personType) {
            selectedPeople.remove(at: index)
        } else {
            selectedPeople.append(personType)
        }
    }
}

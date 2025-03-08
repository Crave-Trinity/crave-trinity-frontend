//
// 3) FILE: CraveTextEditor.swift
//    DIRECTORY: CravePhone/Presentation/Common/DesignSystem/Components
//    DESCRIPTION: A reusable text editor with optional placeholder support.
//                 You may already have something like this; if so, adapt as needed.
//

import SwiftUI

struct CraveTextEditor: View {
    @Binding var text: String
    var placeholder: String = ""
    var minHeight: CGFloat = 100
    
    // SwiftUI hack to show placeholder inside a TextEditor
    @State private var dynamicHeight: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 12)
            }
            TextEditor(text: $text)
                .frame(minHeight: minHeight)
                .padding(4)
                .background(
                    GeometryReader { geometry in
                        Color.clear.onAppear {
                            self.dynamicHeight = geometry.size.height
                        }
                    }
                )
        }
    }
}

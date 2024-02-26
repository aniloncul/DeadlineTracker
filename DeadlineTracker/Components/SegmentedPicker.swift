//
//  SegmentedPicker.swift
//  DeadlineTracker
//
//  Created by Anıl Öncül on 26.02.2024.
//

import SwiftUI

struct SegmentedPicker<SelectionValue, Content>: View
where SelectionValue: Hashable, Content: View {
    @Namespace private var pickerTransition
    /// init()...
    
    @Binding var selection: SelectionValue?
    
    // 2.
    @Binding var items: [SelectionValue]
    
    // 3.
    private var selectionColor: Color = .black
    
    // 4.
    private var content: (SelectionValue) -> Content
    
    init(
        selection: Binding<SelectionValue?>,
        items: Binding<[SelectionValue]>,
        selectionColor: Color = .blue,
        @ViewBuilder content: @escaping (SelectionValue) -> Content
    ) {
        _selection = selection
        _items = items
        self.selectionColor = selectionColor
        self.content = content
    }
    
    
    
    
    var body: some View {
        ScrollViewReader { proxy in
            // 2.
            ScrollView(.horizontal, showsIndicators: false) {
                // 3.
                LazyHGrid(rows: [GridItem(.flexible())], spacing: 12) {
                    ForEach(items, id:\.self) { item in
                        // 1.
                        let selected = selection == item
                        ZStack {
                            if selected {
                                Capsule()
                                    .foregroundStyle(selectionColor)
                                    .matchedGeometryEffect(id: "picker", in: pickerTransition)
                                
                                content(item).id(item)
                                    .foregroundStyle(.white)
                                    .padding(.horizontal)
                                    .padding(.vertical, 8)
                                    .lineLimit(1)
                                    .clipShape(Capsule())
                            }
                            else {
                                
                                content(item).id(item)
                                    .foregroundStyle(.black)
                                    .padding(.horizontal)
                                    .padding(.vertical, 8)
                                    .lineLimit(1)
                                    .background(
                                            Capsule()
                                                .strokeBorder(Color.black, lineWidth: 1)
                                        )
                                    
                            }
                        }.onTapGesture {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selection = item
                            }
                        }
                        .onChange(of: selection) {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                proxy.scrollTo(selection)
                            }
                        }
                    }
                    .onAppear {
                        // 2.
                        if selection == nil, let first = items.first {
                            selection = first
                        }
                    }
                    
                }
                .padding(.horizontal)
                .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

//#Preview {
//    SegmentedPicker()
//}

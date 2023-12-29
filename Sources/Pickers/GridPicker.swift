//
//  GridPicker.swift
//
//
//  Created by Joseph Antonetti on 12/28/23.
//

import SwiftUI

public struct GridPicker<Item: Identifiable, ItemView: View>: View where Item : Equatable{
    
    @Binding var selection : Item
    
    public let columnCount : Int
    private let items : [Item]
    
    @ViewBuilder let itemView : (Item) -> ItemView
    
    private var columns : [GridItem] {
        (0...columnCount).map({
            _ in GridItem(.flexible())
        })
    }
    
    public init(
        selection: Binding<Item>,
        columnCount: Int = 6,
        items: [Item],
        itemView: @escaping (Item) -> ItemView) {
            self._selection = selection
            self.columnCount = columnCount
            self.items = items
            self.itemView = itemView
        }
    
    public var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(items) {
                item in
                itemView(item)
                    .padding(.all, 4)
                    .background(content: {
                        if selection == item {
                            Circle()
                                .stroke(lineWidth: 2)
                                .foregroundStyle(Color.secondary)
                        }
                    })
                    .onTapGesture {
                        withAnimation {
                            selection = item
                        }
                    }
            }
        }
    }
}

struct MockItem : Identifiable, Equatable {
    var id : Int {
        color.hashValue
    }
    
    let color : Color = [Color.red, Color.blue, Color.green, Color.purple].randomElement()!
}

struct StateWrapper : View {
    
    @State var selection = MockItem()
    
    var body : some View {
        GridPicker(selection: $selection, items: (0...20).map({_ in MockItem()})) {
            item in Circle().foregroundStyle(item.color)
        }
    }
}

#Preview {
    StateWrapper()
}

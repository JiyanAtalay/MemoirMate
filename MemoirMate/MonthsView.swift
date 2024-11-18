//
//  ContentView.swift
//  MemoirMate
//
//  Created by Mehmet Jiyan Atalay on 5.11.2024.
//

import SwiftUI
import SwiftData

struct MonthsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    var sortedItems: [Item] {
        items.sorted {
            ($0.year, $0.month) > ($1.year, $1.month)
        }
    }

    var body: some View {
        NavigationStack {
            List(sortedItems) { item in
                NavigationLink {
                    DaysView(item: item)
                } label: {
                    GroupBox {
                        HStack {
                            Text("\(item.getMonthName() ?? item.month.description),")
                            Text(item.year.description)
                            Spacer()
                        }
                    }
                }
            }
            .listStyle(.grouped)
            .navigationTitle("Months")
            .toolbarTitleDisplayMode(.inlineLarge)
        }
        .onAppear {
            let year = Item.getCurrentYear()
            let month = Item.getCurrentMonth()
            
            if let first = sortedItems.first {
                if first.year != year || first.month != month {
                    addItem(item: Item(month: month, year: year))
                }
            } else {
                addItem(item: Item(month: month, year: year))
            }
        }
    }

    private func addItem(item: Item) {
        withAnimation {
            modelContext.insert(item)
            saveItems()
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
    
    private func saveItems() {
        do {
            try modelContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

#Preview {
    MonthsView()
        .modelContainer(for: Item.self)
}

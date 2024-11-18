//
//  DetailsView.swift
//  MemoirMate
//
//  Created by Mehmet Jiyan Atalay on 5.11.2024.
//

import SwiftUI

struct DaysView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    var item: Item
    
    var sortedDays: [Days] {
        item.days.sorted {
            $0.day > $1.day
        }
    }
    
    var body: some View {
        NavigationStack {
            List(sortedDays) { day in
                NavigationLink {
                    NotesView(day: day, month: item.month, year: item.year)
                        .onDisappear {
                            saveItems()
                        }
                } label: {
                    GroupBox {
                        HStack {
                            Text("\(day.day) \(item.getMonthName() ?? item.month.description),")
                            Text("\(item.getDayName(for: day.day) ?? "")")
                            Spacer()
                        }
                    }
                }
            }
            .listStyle(.grouped)
            .navigationTitle("Days")
            .toolbarTitleDisplayMode(.inlineLarge)
        }
        .onAppear {
            let day = Item.getCurrentDay()
            let month = Item.getCurrentMonth()
            
            if item.month == month {
                if let first = sortedDays.first {
                    if first.day != day {
                        item.days.append(Days(day: day))
                    }
                } else {
                    item.days.append(Days(day: day))
                }
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
    DaysView(item: Item(month: 11, year: 2024))
}

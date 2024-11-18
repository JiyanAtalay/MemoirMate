//
//  NotesView.swift
//  MemoirMate
//
//  Created by Mehmet Jiyan Atalay on 6.11.2024.
//

import SwiftUI
import SwiftData

struct NotesView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var day: Days
    var month: Int
    var year: Int
    
    @State private var notes: [Notes] = [Notes(hour: 0, note: "")]
    
    @FocusState private var isInputActive: Bool
    @FocusState private var isTextActive: Bool
    @State private var isDisabled: Bool = false
    
    @State private var isFirstTap = true
    @State var summary: String = "Summary of Day"
    
    @State private var showingAlert = false
    @State private var hasChanges = false
    @State private var originalNotes: [Notes] = []
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Text("\(day.day) \(day.getMonthName(month: month) ?? "") \(day.getDayName(day: day.day, month: month, year: year) ?? "")")
                        .font(.largeTitle)
                        .padding()
                    ForEach(0..<notes.count, id: \.self) { index in
                        GroupBox {
                            VStack {
                                HStack {
                                    Picker("Saat", selection: $notes[index].hour) {
                                        ForEach(0..<24) { hour in
                                            Text(String(format: "%02d:00", hour)).tag(hour)
                                        }.font(.footnote)
                                    }
                                    .frame(width: 90)
                                    .disabled(isDisabled)
                                    .padding(.leading, -10)
                                    
                                    TextField("Note", text: $notes[index].note)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .focused($isInputActive)
                                        .disabled(isDisabled)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        Button(action: {
                            withAnimation {
                                notes.append(Notes(hour: 0, note: ""))
                            }
                        }) {
                            Image(systemName: "plus")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                        }
                        .padding()
                        .opacity(isDisabled ? 0 : 1)
                        .disabled(isDisabled)
                    }
                    
                    GroupBox {
                        TextEditor(text: $summary)
                            .frame(height: 300)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                            .focused($isTextActive)
                            .disabled(isDisabled)
                            .padding(.leading, 5)
                            .onChange(of: isTextActive) {
                                if isFirstTap {
                                    isFirstTap = false
                                    summary = ""
                                }
                            }
                            
                    }.padding(.horizontal)
                    
                    HStack {
                        Button(action: {
                            
                            day.notes = self.notes
                            day.summary = self.summary
                            
                            do {
                                try modelContext.save()
                            } catch {
                                print("Kayıt hatası: \(error.localizedDescription)")
                            }
                            
                            dismiss()
                            
                        }, label: {
                            Text("Save")
                                .padding()
                                .foregroundColor(.blue)
                                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 2))
                        })
                        .disabled(isDisabled)
                        .opacity(isDisabled ? 0 : 1)
                    }.padding(.top)
                    
                    Spacer()
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        isInputActive = false
                        isTextActive = false
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        checkForChanges()
                    } label: {
                        Image(systemName: "chevron.left")
                        Text("Days")
                    }
                }
            }
        }
        .alert("Değişiklikleri Kaydet", isPresented: $showingAlert) {
            Button("Kaydet", role: .destructive) {
                saveChanges()
                dismiss()
            }
            Button("Kaydetme", role: .cancel) {
                dismiss()
            }
            Button("İptal", role: .cancel) { }
        } message: {
            Text("Yaptığınız değişiklikleri kaydetmek istiyor musunuz?")
        }
        .onAppear {
            self.notes = day.notes
            
            if !day.summary.isEmpty {
                self.summary = day.summary
                self.isFirstTap = false 
            }
            
            if self.month != Item.getCurrentMonth() {
                self.isDisabled = true
            } else {
                if day.day != Item.getCurrentDay() {
                    self.isDisabled = true
                }
            }

            originalNotes = day.notes
        }
        .onDisappear {
            
        }
    }
    
    private func checkForChanges() {
        let hasNoteChanges = notes != originalNotes
        let hasSummaryChanges = summary != day.summary
        
        if hasNoteChanges || hasSummaryChanges {
            showingAlert = true
        } else {
            dismiss()
        }
    }
    
    private func saveChanges() {
        day.notes = notes
        day.summary = summary
        
        do {
            try modelContext.save()
        } catch {
            print("Kayıt hatası: \(error.localizedDescription)")
        }
    }
}

#Preview {
    NotesView(day: Days(day: 18), month: 11, year: 2024)
        .modelContainer(for: Item.self)
}

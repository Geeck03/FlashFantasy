//
//  Quest.swift
//  FlashFantasy
//
//  Created by Ethan Jiang on 2/18/25.
//

import SwiftUI

// MARK: - Note Model
struct Note: Identifiable, Codable {
    let id: UUID
    var title: String
    var content: String
    var isCompleted: Bool
    
    init(id: UUID = UUID(), title: String, content: String, isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.content = content
        self.isCompleted = isCompleted
    }
}

// MARK: - Notes ViewModel
class NotesViewModel: ObservableObject {
    @Published var notes: [Note] = [] {
        didSet {
            saveNotes()
        }
    }
    
    private let notesKey = "saved_notes"
    
    init() {
        loadNotes()
    }
    
    func addNote(title: String, content: String) {
        let newNote = Note(title: title, content: content)
        notes.append(newNote)
    }
    
    func updateNote(id: UUID, title: String, content: String) {
        if let index = notes.firstIndex(where: { $0.id == id }) {
            notes[index].title = title
            notes[index].content = content
        }
    }
    
    func toggleCompletion(id: UUID) {
        if let index = notes.firstIndex(where: { $0.id == id }) {
            notes[index].isCompleted.toggle()
        }
    }
    
    func deleteNotes(at offsets: IndexSet) {
        notes.remove(atOffsets: offsets)
    }
    
    private func saveNotes() {
        if let encoded = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(encoded, forKey: notesKey)
        }
    }
    
    private func loadNotes() {
        if let savedData = UserDefaults.standard.data(forKey: notesKey),
           let decodedNotes = try? JSONDecoder().decode([Note].self, from: savedData) {
            notes = decodedNotes
        }
    }
}

// MARK: - Quest
struct Quest: View {
    @StateObject private var viewModel = NotesViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.notes) { note in
                    NavigationLink(destination: NoteDetailView(viewModel: viewModel, note: note)) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(note.title)
                                    .font(.headline)
                                    .strikethrough(note.isCompleted, color: .green)
                                Text(note.content)
                                    .font(.subheadline)
                                    .lineLimit(1)
                            }
                            Spacer()
                            if note.isCompleted {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            }
                        }
                    }
                }
                .onDelete(perform: viewModel.deleteNotes) // Fix for swipe-to-delete
            }
            .navigationTitle("Quests")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddEditNoteView(viewModel: viewModel)) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

// MARK: - NoteDetailView
struct NoteDetailView: View {
    @ObservedObject var viewModel: NotesViewModel
    let note: Note
    @State private var showEditView = false
    
    var body: some View {
        VStack {
            Text(note.title)
                .font(.largeTitle)
                .bold()
                .strikethrough(note.isCompleted, color: .black)
                .padding(.bottom, 10)
                .padding(.leading, 20)
                .frame(maxWidth: .infinity, alignment: .leading) // Aligns text left
                        
            Text(note.content)
                .font(.body)
                .multilineTextAlignment(.leading) // Ensures text aligns left
                .frame(maxWidth: .infinity, alignment: .leading) // Aligns frame left
                .padding(.bottom, 20)
                .padding(.leading, 20)

                        
        
            Spacer()
            
            Button(action: {
                viewModel.toggleCompletion(id: note.id)
            }) {
                Text(note.isCompleted ? "Quest Incompleted" : "Quest Completed")
                    .padding()
                    .background(note.isCompleted ? Color.orange : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
        }
        .navigationBarItems(trailing: Button("Edit") {
            showEditView = true
        })
        .sheet(isPresented: $showEditView) {
            AddEditNoteView(viewModel: viewModel, note: note)
        }
    }
}

// MARK: - AddEditNoteView
struct AddEditNoteView: View {
    @ObservedObject var viewModel: NotesViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title: String = ""
    @State private var content: String = ""
    
    var note: Note?
    
    var body: some View {
        Form {
            TextField("Title", text: $title)
            TextEditor(text: $content)
                .frame(minHeight: 200)
        }
        .navigationTitle(note == nil ? "Add Quest" : "Edit Quest")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    if let note = note {
                        viewModel.updateNote(id: note.id, title: title, content: content)
                    } else {
                        viewModel.addNote(title: title, content: content)
                    }
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .onAppear {
            if let note = note {
                title = note.title
                content = note.content
            }
        }
    }
}




#Preview {
    Quest()
}


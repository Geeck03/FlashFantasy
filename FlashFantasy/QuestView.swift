//
//  Quest.swift
//  FlashFantasy
//
//  Created by Ethan Jiang on 2/18/25.
//

import SwiftUI


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
                                    .font(.custom("Papyrus", size: 20))
                                    .strikethrough(note.isCompleted, color: .green)
                                Text(note.content)
                                    .font(.custom("Papyrus", size: 16))
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
                .onDelete(perform: viewModel.deleteNotes)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Quests")
                        .font(.custom("Papyrus", size: 40))
                        .padding(.top, 20)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddEditNoteView(viewModel: viewModel)) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}


struct NoteDetailView: View {
    @ObservedObject var viewModel: NotesViewModel
    let note: Note
    @State private var showEditView = false
    
    var body: some View {
        VStack {
            Text(note.title)
                .font(.custom("Papyrus", size: 28))
                .bold()
                .strikethrough(note.isCompleted, color: .black)
                .padding(.bottom, 10)
                .padding(.leading, 20)
                .frame(maxWidth: .infinity, alignment: .leading)
                        
            Text(note.content)
                .font(.custom("Papyrus", size: 20))
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
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
                    .font(.custom("Papyrus", size: 20))
            }
            .padding()
        }
        .navigationBarItems(trailing: Button("Edit") {
            showEditView = true
        }
        .font(.custom("Papyrus", size: 20)))
        .sheet(isPresented: $showEditView) {
            AddEditNoteView(viewModel: viewModel, note: note)
        }
    }
}


struct AddEditNoteView: View {
    @ObservedObject var viewModel: NotesViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title: String = ""
    @State private var content: String = ""
    
    var note: Note?
    
    var body: some View {
        Form {
            TextField("Title", text: $title)
                .font(.custom("Papyrus", size: 20))
            TextEditor(text: $content)
                .frame(minHeight: 200)
                .font(.custom("Papyrus", size: 20))
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(note == nil ? "Add Quest" : "Edit Quest")
                    .font(.custom("Papyrus", size: 30))
                    .padding(.top, 30)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    if let note = note {
                        viewModel.updateNote(id: note.id, title: title, content: content)
                    } else {
                        viewModel.addNote(title: title, content: content)
                    }
                    presentationMode.wrappedValue.dismiss()
                }
                .font(.custom("Papyrus", size: 20))
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

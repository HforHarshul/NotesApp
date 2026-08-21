//
//  ContentView.swift
//  MyNotesApp
//
//  Created by Harshul on 14/07/2026.
//

import SwiftUI
internal import UniformTypeIdentifiers

struct NoteActions {
    var save: () -> Void
    var saveAs: () -> Void
    var openNote: () -> Void
    var increaseFontSize: () -> Void
    var decreaseFontSize: () -> Void
    var addNote: () -> Void
}

struct NoteActionsKey: FocusedValueKey {
    typealias Value = NoteActions
}

extension FocusedValues {
    var noteActions: NoteActions? {
        get { self[NoteActionsKey.self] }
        set { self[NoteActionsKey.self] = newValue }
    }
}

struct ContentView: View {
    @State private var notes: [Note] = []
    @State private var selectedNoteID: Note.ID? = nil
    @State private var fontSize: CGFloat = 14
    @State private var showingFilePicker = false
    @State private var searchText = ""

    var filteredNotes: [Note] {
        if searchText.isEmpty { return notes }
        return notes.filter {
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.note.localizedCaseInsensitiveContains(searchText)
        }
    }

    let manager = FileManager.default

    var fileURL: URL {
        let docs = manager.urls(for: .documentDirectory, in: .userDomainMask).first!
        return docs.appendingPathComponent("notes.json")
    }

    var body: some View {
        NavigationSplitView {
            List(selection: $selectedNoteID) {
                ForEach(filteredNotes) { note in
                    Text(note.title.isEmpty ? "Untitled" : note.title)
                        .tag(note.id)
                }
                .onDelete { indexSet in
                    let idsToDelete = indexSet.map { filteredNotes[$0].id }
                    notes.removeAll { idsToDelete.contains($0.id) }
                }
            }
            .searchable(text: $searchText, placement: .sidebar, prompt: "Search notes")
            .navigationTitle("Notes")
            .safeAreaInset(edge: .bottom) {
                Divider()
                Button(action: addNote) {
                    Label("New Note", systemImage: "plus")
                }
                .buttonStyle(.borderless)
                .padding(8)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        } detail: {
            if let id = selectedNoteID,
               let index = notes.firstIndex(where: { $0.id == id }) {
                VStack(alignment: .leading, spacing: 8) {
                    TextField("Title", text: $notes[index].title)
                        .textFieldStyle(.plain)
                        .font(.title2.bold())

                    Divider()

                    TextEditor(text: $notes[index].note)
                        .font(.system(size: fontSize))
                }
                .padding()
            } else {
                Text("Select or create a note")
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .focusedSceneValue(\.noteActions, NoteActions(
            save: saveNotes,
            saveAs: saveCurrentNoteAs,
            openNote: openNote,
            increaseFontSize: increaseFontSize,
            decreaseFontSize: decreaseFontSize,
            addNote: addNote
        ))
        .fileImporter(
            isPresented: $showingFilePicker,
            allowedContentTypes: [.plainText]
        ) { result in
            switch result {
            case .success(let url):
                guard url.startAccessingSecurityScopedResource() else { return }
                defer { url.stopAccessingSecurityScopedResource() }
                do {
                    let content = try String(contentsOf: url, encoding: .utf8)
                    let title = url.deletingPathExtension().lastPathComponent
                    let note = Note(title: title, note: content)
                    notes.append(note)
                    selectedNoteID = note.id
                } catch {
                    print("Failed to open file: \(error.localizedDescription)")
                }
            case .failure(let error):
                print("Failed to open file: \(error.localizedDescription)")
            }
        }
        .onAppear {
            loadNotes()
        }
        .onChange(of: notes) {
            saveNotes()
        }
    }

    func addNote() {
        let note = Note(title: "", note: "")
        notes.append(note)
        selectedNoteID = note.id
    }

    func saveNotes() {
        do {
            let data = try JSONEncoder().encode(notes)
            try data.write(to: fileURL, options: .atomic)
        } catch {
            print("Failed to save notes: \(error.localizedDescription)")
        }
    }

    func loadNotes() {
        guard manager.fileExists(atPath: fileURL.path) else { return }
        do {
            let data = try Data(contentsOf: fileURL)
            notes = try JSONDecoder().decode([Note].self, from: data)
            if selectedNoteID == nil {
                selectedNoteID = notes.first?.id
            }
        } catch {
            print("Failed to load notes: \(error.localizedDescription)")
        }
    }

    // Exports the selected note as a plain text file via a save panel
    func saveCurrentNoteAs() {
        guard let id = selectedNoteID,
              let note = notes.first(where: { $0.id == id }) else { return }
        let panel = NSSavePanel()
        panel.title = "Export Note"
        panel.nameFieldStringValue = "\(note.title.isEmpty ? "Untitled" : note.title).txt"
        panel.allowedContentTypes = [.plainText]
        panel.canCreateDirectories = true
        panel.begin { response in
            guard response == .OK, let url = panel.url else { return }
            do {
                try note.note.write(to: url, atomically: true, encoding: .utf8)
            } catch {
                print("Failed to export note: \(error.localizedDescription)")
            }
        }
    }

    func openNote() {
        showingFilePicker = true
    }

    func increaseFontSize() {
        fontSize = min(fontSize + 2, 72)
    }

    func decreaseFontSize() {
        fontSize = max(fontSize - 2, 8)
    }
}

#Preview {
    ContentView()
}

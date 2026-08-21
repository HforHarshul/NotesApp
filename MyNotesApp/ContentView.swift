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
	@State private var selectedNote: Note? = nil
	@State private var fileMessage = ""
	@State private var noteText: String = ""
	@State private var saveMessage: String = ""
	@State private var fontSize: CGFloat = 14
	@State private var showingFilePicker = false

	let manager = FileManager.default

	var fileURL: URL{
		let docs = manager.urls(for: .documentDirectory, in: .userDomainMask).first!
		return docs.appendingPathComponent("notes.json", conformingTo: .plainText)
	}

    var body: some View {

        VStack {
			// NOTE: in Swift, String data-type holds unformatted string data only. Formatting info is saved as metadata (eg: index 0:5=>Bold, 6:8:Italic, etc) along with the text. To do that use AttributedString var instead of String var

			TextEditor(text: $noteText)
				.font(.system(size: fontSize))
				.border(Color.gray)
				.frame(minWidth: 600.0, minHeight: 400.0)
        }
        .focusedSceneValue(\.noteActions, NoteActions(
            save: saveNote,
            saveAs: saveNoteAs,
            openNote: openNote,
            increaseFontSize: increaseFontSize,
            decreaseFontSize: decreaseFontSize
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
                    noteText = try String(contentsOf: url, encoding: .utf8)
                    saveMessage = "Opened file at: \(url.path())"
                } catch {
                    saveMessage = "Failed to open file: \(error.localizedDescription)"
                }
            case .failure(let error):
                saveMessage = "Failed to open file: \(error.localizedDescription)"
            }
        }

		HStack{
			// system symbols: command + shift + L
			Button(action: saveNote){
				Label("Save", systemImage: "square.and.arrow.down.fill")
			}.buttonStyle(.borderedProminent)

			Button(action: saveNoteAs){
				Label("Save As", systemImage: "square.and.arrow.down.badge.checkmark.fill")
			}.buttonStyle(.borderedProminent)

			Button(action: loadNote){
				Label("Load", systemImage: "document.circle.fill")
			}.buttonStyle(.borderedProminent)

			Button(action: revealInFinder){
				Label("Reveal in Finder", systemImage: "folder.fill")
			}.buttonStyle(.borderedProminent)
		}
		Text(saveMessage)
			.font(.caption)
			.foregroundStyle(.green)

        .padding()
		.onAppear{} // this gets called whenever this view appears, i.e. whenever we navigate to this screen. It triggers every time we switch away from this view and come back to this view. It's not always one-time per app runtime (except for cases when a view is always shown only once in an app lifecycle)
    }
	
	func saveNote(){
		do{
			try noteText.write(to: fileURL, atomically: true, encoding: .utf8)
			// TODO: add a popup to let the user know the path where the note was saved
			let saveText = "Note saved at: \(fileURL.path())"
			saveMessage = saveText
			print(saveText)
		}catch{
			// TODO: add a popup to show the error to the user
			let saveText = "Failed to save note: \(error.localizedDescription)"
			saveMessage = saveText
			print(saveText)
		}
	}

	func loadNote(){
		if manager.fileExists(atPath: fileURL.path){
			do{
				noteText = try String(contentsOf: fileURL, encoding: .utf8)

				// TODO: add a popup to show the success msg to the user
				let loadText = "Successfully loaded from file at: \(fileURL.path())"
				saveMessage = loadText
				print(loadText)
			}catch{
				// TODO: add a popup to show the error to the user
				let loadText = "Load failed: \(error.localizedDescription)"
				saveMessage = loadText
				print(loadText)
			}
		} else {
			// TODO: add a popup to show the error to the user
			let loadText = "No save file found at: \(fileURL.path())"
			saveMessage = loadText
			print(loadText)
		}
	}

	func saveNoteAs(){
		let panel = NSSavePanel()
		panel.title = "Save Note As"
		panel.showsHiddenFiles = true
		panel.nameFieldStringValue = "Untitled.txt"
		panel.allowedContentTypes = [.plainText]
		panel.allowsOtherFileTypes = true
		panel.canCreateDirectories = true

		panel.begin(){ response in
			guard response == .OK, let url = panel.url else{
				return
			}
			do {
				try noteText.write(to: url, atomically: true, encoding: .utf8)
				let saveText = "Note saved at: \(url.path())"
				saveMessage = saveText
				print(saveText)
			} catch {
				let saveText = "Failed to save note: \(error.localizedDescription)"
				saveMessage = saveText
				print(saveText)
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

	func revealInFinder(){
		if manager.fileExists(atPath: fileURL.path){
			NSWorkspace.shared.activateFileViewerSelecting([fileURL])
		} else {
			let folderURL = fileURL.deletingLastPathComponent()
			NSWorkspace.shared.activateFileViewerSelecting([folderURL])
		}
	}
}

#Preview {
    ContentView()
}

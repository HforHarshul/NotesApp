//
//  ContentView.swift
//  MyNotesApp
//
//  Created by Harshul on 14/07/2026.
//

import SwiftUI
internal import UniformTypeIdentifiers

struct ContentView: View {
	@State private var noteText: String = ""
	@State private var saveMessage: String = ""
	
	let manager = FileManager.default

	var fileURL: URL{
		let docs = manager.urls(for: .documentDirectory, in: .userDomainMask).first!
		return docs.appendingPathComponent("notes.txt", conformingTo: .plainText)
	}
	
    var body: some View {
		
        VStack {
			// TODO: add options to change font style and size
			// TODO: add "File" dropdown button with optios: "Save", "SaveAs", "Open", "Close"
			// TODO: add "Edit" dropdown button with options: "Cut", "Copy", "Paste", "Delete", "Find", "Find and Replace"
			// TODO: add "Format" dropdown with options: "Font Style", "Font Size"
			// TODO: add "Window" dropdown with options: "Minimise", "Maximise", "Centre"
			// NOTE: in Swift, String data-type holds unformatted string data only. Formatting info is saved as metadata (eg: index 0:5=>Bold, 6:8:Italic, etc) along with the text. To do that use AttributedString var instead of String var
			
			TextEditor(text: $noteText)
				.border(Color.gray)
				.frame(minWidth: 600.0, minHeight: 400.0)
        }
		
		
		HStack{
			Button("Save"){ saveNote() }
			Button("Save As") { saveNoteAs() }
			Button("Load"){ loadNote() }
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
}

#Preview {
    ContentView()
}

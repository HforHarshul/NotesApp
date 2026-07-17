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
	var fileURL: URL{
		let manager = FileManager.default
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
			Button("Load"){ loadNote() }
		}
		
        .padding()
    }
	
	func saveNote(){
		do{
			try noteText.write(to: fileURL, atomically: true, encoding: .utf8)
			print("Note saved at: ", fileURL.path())
		}catch{
			print("Failed to save note: ", error.localizedDescription)
		}
	}
	
	func loadNote(){
		
	}
}

#Preview {
    ContentView()
}

//
//  ContentView.swift
//  MyNotesApp
//
//  Created by Harshul on 14/07/2026.
//

import SwiftUI

struct ContentView: View {
	@State private var noteText: String = ""
    var body: some View {
        VStack {
			// TODO: add options to change font style and size
			TextEditor(text: $noteText)
				.border(Color.gray)
				.frame(minWidth: 600.0, minHeight: 400.0)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

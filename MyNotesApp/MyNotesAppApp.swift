//
//  MyNotesAppApp.swift
//  MyNotesApp
//
//  Created by Harshul on 14/07/2026.
//

import SwiftUI

@main
struct MyNotesAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
		.commands{
			// File -> New Note Window, New Note Tab, Open Note, Save Note, Save Note As, Share Note, Print Note
			CommandGroup(replacing: .newItem) {
				// New Note Window
				Button("New Note Window"){
					// action to create a new note window
				}.keyboardShortcut("n", modifiers: .command)
				
				// New Note Tab
				Button("New Note Tab"){
					// action to create a new note tab
				}.keyboardShortcut("t", modifiers: .command)
				
				Divider()
				
				// Open Note
				Button("Open Note"){
					// action to open/load an existing notes file
				}.keyboardShortcut("o", modifiers: .command)
				
				Divider()
				
				// Save Note
				Button("Save Note"){
					// action to save a new or existing note
				}.keyboardShortcut("s", modifiers: .command)
				
				// Save Note As
				Button("Save Note As"){
					// action to save a new or existing note
				}.keyboardShortcut("s", modifiers: [.command, .shift])
				
				Divider()
				
				// Share Note
				Button("Share Note"){
					// action to trigger the Share popup
				}.keyboardShortcut("s", modifiers: .control)
				
				// Print Note
				Button("Print Note"){
					// action to trigger the Print popup
				}.keyboardShortcut("p", modifiers: .command)

                Divider()
			}


			// Edit -> add Find, Find and Replace options
			CommandGroup(after: .textEditing) {
				Divider()
				
				// Find
				Button("Find"){
					// action to find a text in the note text
				}.keyboardShortcut("f", modifiers: .command)
				
				// Find and Replace
				Button("Find and Replace"){
					// action to find and replace a text in the note text
				}.keyboardShortcut("r", modifiers: [.command])
				
				Divider()
			}

            // Format -> Font, Font Size, Font Style (bold/italic/etc)
		}
    }
}

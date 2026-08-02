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
			// File -> New Note Window, New Note Tab, Open, Save Note, Save Note As, Share, Print
			
			// Edit -> Find, Find and Replace

            // Format -> Font, Font Size, Font Style (bold/italic/etc)
		}
    }
}

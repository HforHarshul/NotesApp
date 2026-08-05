//
//  Note.swift
//  MyNotesApp
//
//  Created by Harshul on 03/08/2026.
//

import Foundation
// Foundation is a "framework" that provides "Data Types", "Json", "URLSession for HTTP requests", "UserDefaults", etc
// A "framework" is a functionality that Apple ships with every macOS
// So a user runs the app on their machine, frameworks are loaded from their OS
// Framework imports are not a part of the app that gets shipped

struct Note: Identifiable, Codable, Hashable {
	// Identifiable: Every note will need to have an ID
	// "Codable": Every Note can be "encoded" or "decoded" to/from JSON (type of data)
	// "Hashable": Every note can be stored as key:value pair of set
	var id = UUID()
	var title: String
	var note: String
}

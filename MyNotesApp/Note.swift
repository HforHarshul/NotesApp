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
	var createdAt: Date = Date()
	var modifiedAt: Date = Date()

	enum CodingKeys: String, CodingKey {
		case id, title, note, createdAt, modifiedAt
	}
}

extension Note {
	// Custom decoder so notes saved before timestamps were added still load correctly
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		id = try container.decode(UUID.self, forKey: .id)
		title = try container.decode(String.self, forKey: .title)
		note = try container.decode(String.self, forKey: .note)
		createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt) ?? Date()
		modifiedAt = try container.decodeIfPresent(Date.self, forKey: .modifiedAt) ?? Date()
	}
}

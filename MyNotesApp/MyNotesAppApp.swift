//
//  MyNotesAppApp.swift
//  MyNotesApp
//
//  Created by Harshul on 14/07/2026.
//

import SwiftUI

@main
struct MyNotesAppApp: App {
    @FocusedValue(\.noteActions) var noteActions
    @Environment(\.openWindow) var openWindow

    var body: some Scene {
        WindowGroup(id: "note") {
            ContentView()
        }
        .commands {
            CommandGroup(replacing: .newItem) {
                Button("New Note") {
                    noteActions?.addNote()
                }.keyboardShortcut("n", modifiers: .command)

                Button("New Note Window") {
                    openWindow(id: "note")
                }.keyboardShortcut("n", modifiers: [.command, .shift])

                Divider()

                Button("Open Note") {
                    noteActions?.openNote()
                }.keyboardShortcut("o", modifiers: .command)

                Divider()

                Button("Save Note") {
                    noteActions?.save()
                }.keyboardShortcut("s", modifiers: .command)

                Button("Save Note As") {
                    noteActions?.saveAs()
                }.keyboardShortcut("s", modifiers: [.command, .shift])

                Divider()

                Button("Share Note") {
                    noteActions?.shareNote()
                }

                Divider()
            }

            CommandMenu("Format") {
                Menu("Font Size") {
                    Button("Increase") {
                        noteActions?.increaseFontSize()
                    }.keyboardShortcut("+", modifiers: .command)

                    Button("Decrease") {
                        noteActions?.decreaseFontSize()
                    }.keyboardShortcut("-", modifiers: .command)
                }
            }
        }
    }
}

//
//  Technical_DictionaryApp.swift
//  Technical Dictionary
//
//  Created by 71m3 on 2025-02-26.
//

import SwiftUI
import SwiftData

@main
struct Technical_DictionaryApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
                .modelContainer(for: WordModel.self)
        }
    }
}

//
//  MainViewModel.swift
//  Technical Dictionary
//
//  Created by 71m3 on 2025-04-11.
//

import SwiftData

@Observable
class MainViewModel {
    var dataSource:StorageService
    private var words:[WordModel] = []
    var searchText:String = ""
    
    init(dataSource: StorageService) {
        self.dataSource = dataSource
        self.words = dataSource.fetchWords()
    }
    
    func reloadData(){
        words = dataSource.fetchWords()
    }
    
    var filteredWords: [WordModel] {
        guard !searchText.isEmpty else { return words }
        return words.filter {
            $0.word.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var groupedWords: [String: [WordModel]] {
        Dictionary(grouping: filteredWords) { word in
            String(word.word.prefix(1).uppercased())
        }
    }
    var sortedSectionTitles: [String] {
        groupedWords.keys.sorted()
    }
}

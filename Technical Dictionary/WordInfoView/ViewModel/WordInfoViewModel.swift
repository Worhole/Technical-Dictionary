//
//  DetailViewModel.swift
//  Technical Dictionary
//
//  Created by 71m3 on 2025-04-11.
//


import SwiftData

@Observable
class WordInfoViewModel {
    var wordInfo:WordModel
    var dataSource:StorageService
    var onDisappear:(()->Void)?
  
    init(wordInfo: WordModel, dataSource: StorageService, onDisappear: (() -> Void)? = nil) {
        self.wordInfo = wordInfo
        self.dataSource = dataSource
        self.onDisappear = onDisappear
    }
}

//
//  AddWordViewModel.swift
//  Technical Dictionary
//
//  Created by 71m3 on 2025-04-11.
//

import SwiftData
import Foundation

@Observable
class AddWordViewModel {
    var dataSource:StorageService
    var newWord:String = ""
    var newDescription:String = ""
    var imageData = [Data]()
    var videoStrUrl = [String]()
    
    init(dataSource: StorageService) {
        self.dataSource = dataSource
    }
    
    func addWord(){
        let word = WordModel(word: newWord, wordDescription: newDescription,imageData: imageData,videoUrlStr: videoStrUrl)
        dataSource.addWord(word)
    }
    
}

//
//  EditViewModel.swift
//  Technical Dictionary
//
//  Created by 71m3 on 2025-04-11.
//

import SwiftData

@Observable
class EditViewModel {
    
    var draftWordInfo:WordModel
    var wordInfo:WordModel
    var dataSource:StorageService
    
    init(wordInfo: WordModel, dataSource: StorageService) {
        self.wordInfo = wordInfo
        self.draftWordInfo = wordInfo.copy()
        self.dataSource = dataSource
    }
    
    func saveChanges(){
        wordInfo.word = draftWordInfo.word
        wordInfo.wordDescription = draftWordInfo.wordDescription
        wordInfo.imageData = draftWordInfo.imageData
        wordInfo.videoUrlStr = draftWordInfo.videoUrlStr
        dataSource.saveChangeData()
    }
    func rollback(){
        dataSource.rollback()
    }
}

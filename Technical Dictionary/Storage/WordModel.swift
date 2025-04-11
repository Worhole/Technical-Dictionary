//
//  Model.swift
//  Deep Space
//
//  Created by 71m3 on 2025-03-07.
//

import UIKit
import SwiftData

@Model
final class WordModel {
    
    var word:String
    var wordDescription:String
    var imageData:[Data]?
    var videoUrlStr:[String]?
    
    init(word: String, wordDescription: String, imageData: [Data]? = nil, videoUrlStr: [String]? = nil) {
        self.word = word
        self.wordDescription = wordDescription
        self.imageData = imageData
        self.videoUrlStr = videoUrlStr
    }
}

extension WordModel {
    @MainActor
    static var preview: ModelContainer {
        let container = try! ModelContainer(for: WordModel.self, configurations: ModelConfiguration())
        return container
    }
    
    func copy()->WordModel{
        let new = WordModel(word: self.word,
                            wordDescription: self.wordDescription,
                            imageData: self.imageData,
                            videoUrlStr: self.videoUrlStr)
        return new
    }
}

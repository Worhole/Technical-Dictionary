//
//  SwiftDataService.swift
//  Technical Dictionary
//
//  Created by 71m3 on 2025-04-11.
//

import SwiftData

class StorageService {
    
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
    @MainActor
    static let shared = StorageService()
    
    @MainActor
    private init() {
        self.modelContainer = WordModel.preview
        self.modelContext = modelContainer.mainContext
    }
    
    func fetchWords() -> [WordModel] {
        do {
            return try modelContext.fetch(FetchDescriptor<WordModel>())
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func addWord(_ word: WordModel) {
        modelContext.insert(word)
        do {
            try modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func deleteWord(_ word:WordModel){
        modelContext.delete(word)
        do {
            try modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func saveChangeData(){
        do {
            try modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func rollback(){
        modelContext.rollback()
    }
}

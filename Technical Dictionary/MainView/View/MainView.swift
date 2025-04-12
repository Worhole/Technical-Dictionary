//
//  ContentView.swift
//  Technical Dictionary
//
//  Created by 71m3 on 2025-02-26.
//

import SwiftUI

struct MainView: View {
    @State var viewModel = MainViewModel(dataSource: .shared)
    @State private var isShowAdd = false
    var body: some View {
        NavigationStack {
            HStack(){
                SearchBar(searchText: $viewModel.searchText)
                Button {
                    isShowAdd.toggle()
                } label: {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 20,height: 20)
                        .bold()
                        .foregroundStyle(Color.black)
                }.fullScreenCover(isPresented: $isShowAdd,onDismiss: {
                    viewModel.reloadData()
                }, content: {
                    AddWordView(viewModel: AddWordViewModel(dataSource: .shared))
                })
                .padding(.trailing, 25)
            }
            if viewModel.filteredWords.isEmpty {
                ContentUnavailableView("Dictionaty is Empty", systemImage: "book.and.wrench")
            }else {
                List{
                    ForEach(viewModel.sortedSectionTitles, id: \.self) { section in
                        Section(header: Text(section)) {
                            ForEach(viewModel.groupedWords[section] ?? []) { word in
                                NavigationLink(destination: WordInfoView(viewModel: WordInfoViewModel(wordInfo: word,dataSource:.shared, onDisappear: {
                                    viewModel.reloadData()
                                }))){
                                    if let data = word.imageData?.first, let image = UIImage(data: data) {
                                        Image(uiImage: image)
                                            .resizable()
                                            .frame(width: 50, height: 50)
                                    }else {
                                        Image(systemName: "photo.on.rectangle.angled.fill")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 50, height: 50)
                                    }
                                    Text(word.word)
                                }
                            }
                        }
                    }
                
                }
                
            }
        }
                .listStyle(.insetGrouped)
        .scrollDismissesKeyboard(.immediately)
    }
}

extension MainView{
    
}

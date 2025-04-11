//
//  SearchBar.swift
//  Technical Dictionary
//
//  Created by 71m3 on 2025-03-08.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchText:String
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("Search Word", text: $searchText)
            
            Spacer(minLength: 0)
            if searchText.isEmpty != true{
                Button {
                    self.searchText = ""
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 8,height: 8)
                        .foregroundStyle(.black)
                        .background(Circle().foregroundStyle(Color.init(uiColor: .systemGray4)).frame(width: 16,height: 16))
                }
            }
        }.padding()
            .background(Color.init(uiColor: .systemGray6))
            .clipShape(.capsule)
            .padding()
            .frame(width: 350)
    }
}

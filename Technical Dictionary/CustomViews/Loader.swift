//
//  Loader.swift
//  Technical Dictionary
//
//  Created by 71m3 on 2025-03-11.
//

import SwiftUI

struct Loader:View{
    var body: some View {
        ZStack{
            Color.gray
                .frame(width: 100,height: 100)
                .cornerRadius(8)
                .shadow(radius: 3)
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .frame(width: 30, height: 30)
        }.padding()
    }
}

#Preview {
    Loader()
}

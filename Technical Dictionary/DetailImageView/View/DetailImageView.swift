//
//  DetailImageView.swift
//  Technical Dictionary
//
//  Created by 71m3 on 2025-03-13.
//

import SwiftUI

struct DetailImageView: View {
    
    let imageData:[Data]
    @State  var scale = 1.0
    @State var isZoomed = false
    @Binding var isPresented:Bool
    @Binding var index:Int
    
    var doubleTap: some Gesture {
        TapGesture(count: 2).onEnded {
            isZoomed.toggle()
            scale = isZoomed ? 4.0 : 1.0
        }
    }
    
    var zoom: some Gesture {
        MagnificationGesture().onChanged { value in
            if value != 0.0 {
                scale = value.magnitude
            }
        }.onEnded { value in
            isZoomed = true
        }
    }
    var body: some View {
        NavigationStack(){
            HStack {
                Button {
                    isPresented = false
                } label: {
                    Image(systemName: "chevron.backward")
                        .resizable()
                        .frame(width: 12,height: 20)
                        .foregroundStyle(.white)
                }
                Spacer()
            }.padding()
            TabView(selection:$index){
                ForEach(imageData.indices, id: \.self){ index in
                    let data = imageData[index]
                    if let image = UIImage(data: data){
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .tag(index)
                            .cornerRadius(8)
                            .scaleEffect(scale,anchor: .center )
                            .gesture(zoom)
                            .gesture(doubleTap)
                            .shadow(radius: 3)
                    }
                }
            }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        }
    }
}


//
//  DetailView.swift
//  Technical Dictionary
//
//  Created by 71m3 on 2025-02-26.
//

import SwiftUI
import AVKit

struct WordInfoView: View {
    
    @Environment(\.dismiss) var dissmiss
    @State private var isShowImageDetail = false
    @State private var isShowEditView = false
    @State private var currentIndex = 0
    @State private var refreshID = UUID()

    @Bindable var viewModel:WordInfoViewModel
    
    var body: some View {
        ZStack{
            ScrollView(showsIndicators: false){
                TabView(selection:$currentIndex){
                    if let imageData = viewModel.wordInfo.imageData{
                        ForEach(imageData.indices,id: \.self){ index in
                            let data = imageData[index]
                            Button {
                                isShowImageDetail.toggle()
                            }label: {
                                if let image = UIImage(data: data){
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .tag(index)
                                        .frame(width: 370, height: 300)
                                        .cornerRadius(8)
                                        .shadow(radius: 3)
                                        .padding()
                                }
                            }
                        }
                    }
                    if let videoUrl = viewModel.wordInfo.videoUrlStr{
                        ForEach(videoUrl,id: \.self){ urlStr in
                            if let url = URL(string: urlStr ){
                                Button {
                                    AVManager.shared.showPlayer(AVPlayer(url: url))
                                } label: {
                                    VideoPlayer(player:AVPlayer(url: url))
                                        .frame(width: 370,height: 300)
                                        .cornerRadius(8)
                                        .shadow(radius: 3)
                                        .padding()
                                }
                            }
                        }
                    }
                    if (viewModel.wordInfo.imageData?.isEmpty ?? true) && (viewModel.wordInfo.videoUrlStr?.isEmpty ?? true){
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(Color.init(uiColor: .systemGray6))
                            .frame(width: 370,height: 300)
                            .cornerRadius(8)
                            .shadow(radius: 3)
                            .padding()
                        
                    }
                }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                    .frame(height: 300)
                
                VStack(alignment:.leading,spacing: 10){
                    Text(viewModel.wordInfo.word)
                        .font(.system(size: 27))
                        .bold()
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .padding(.leading,25)
                        .padding(.trailing,15)
                    
                    Text(viewModel.wordInfo.wordDescription)
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .padding(.leading,15)
                        .padding(.trailing,15)
                }
            }.id(refreshID)
            
            if isShowImageDetail {
                Color.black//.opacity(0.5)
                    .ignoresSafeArea()
                    .transition(.opacity)
    
                DetailImageView(imageData: viewModel.wordInfo.imageData ?? [], isPresented: $isShowImageDetail, index: $currentIndex)
                .transition(.move(edge: .bottom))
                .zIndex(1)
                .animation(.easeInOut, value: isShowImageDetail)
            }
            
        }
        .navigationBarBackButtonHidden(true)
        
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dissmiss.callAsFunction()
                } label: {
                    Image(systemName: "chevron.backward")
                        .foregroundStyle(.black)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Menu{
                    Button {
                        isShowEditView.toggle()
                    } label: {
                        Text("Edit")
                    }
                    Button {
                        withAnimation {
                            viewModel.dataSource.deleteWord(viewModel.wordInfo)
                            viewModel.onDisappear?()
                            dissmiss.callAsFunction()
                        }
                    } label: {
                        Text("Delete")
                    }
                }label: {
                    Image(systemName: "square.and.pencil")
                        .foregroundStyle(.black)
                }
            }
        }
        .toolbar(isShowImageDetail ? .hidden : .visible, for: .navigationBar)
        .fullScreenCover(isPresented: $isShowEditView,onDismiss: {
            refreshID = UUID()
        }) {
            EditView(viewModel: EditViewModel(wordInfo: viewModel.wordInfo, dataSource: .shared))
        }
    
    }
}



//
//  AddWordView.swift
//  Technical Dictionary
//
//  Created by 71m3 on 2025-03-08.
//

import SwiftUI
import AVKit
import PhotosUI

struct AddWordView: View {
    
    @State private var isNewWordOverlayColor = true
   
    @State private var isDesctiptionOverlayColor = true
    
    @State private var isDisabled = true
    
    @State private var isShowConfiguarationDialog = false
    
    @State private var selectedVideo:PhotosPickerItem?
    @State private var selectedImage:PhotosPickerItem?
    
    
    @State var videos:[(id:UUID,url:URL?)] = []
    @State var images:[(id:UUID,image:UIImage,data:Data)] = []
    
    @State var loadingItem = [UUID]()
    
    
    @State private var isPresentPhotoPicker = false
    @State private var isPresentVideoPicker = false
    
    @Environment(\.dismiss) var dissmiss

    @Bindable var viewModel:AddWordViewModel
    
    var body: some View {
        NavigationStack(){
            ScrollView{
                VStack(alignment: .leading,spacing:5){
                    Text("New Word")
                        .padding(.leading,10)
                    TextField("", text: $viewModel.newWord)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke( isNewWordOverlayColor ? Color.init(uiColor: .systemGray3) : Color.black, lineWidth: 1)
                        )
                        .frame(width: 370)
                        .onChange(of: viewModel.newWord) { oldValue, newValue in
                            isNewWordOverlayColor = newValue.isEmpty
                            if isNewWordOverlayColor == false && isDesctiptionOverlayColor == false {
                                isDisabled = false
                            }else {
                                isDisabled = true
                            }
                        }
                }
                VStack(alignment: .leading,spacing: 5){
                    
                    Text("Description")
                        .padding(.leading,10)
                    TextEditor(text: $viewModel.newDescription)
                        .frame(height: 300)
                        .padding(8)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke( isDesctiptionOverlayColor ? Color.init(uiColor: .systemGray3)  : Color.black, lineWidth: 1)
                        )
                        .frame(width: 370)
                        .onChange(of: viewModel.newDescription) { oldValue, newValue in
                            isDesctiptionOverlayColor = newValue.isEmpty
                            if isNewWordOverlayColor == false && isDesctiptionOverlayColor == false {
                                isDisabled = false
                            }else {
                                isDisabled = true
                            }
                        }
                }.padding()
                
                ScrollView(.horizontal,showsIndicators: false) {
                    HStack{
                        ForEach(images, id:\.id){ imageItem in
                            ZStack(alignment:.topTrailing){
                                if loadingItem.contains(imageItem.id){
                                    Loader()
                                }else{
                                    Image(uiImage:imageItem.image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 100,height: 100)
                                        .cornerRadius(8)
                                        .shadow(radius: 3)
                                        .padding()
                                }
                                Button {
                                    removeImage(imageItem.id)
                                } label: {
                                    Image(systemName: "xmark")
                                        .resizable()
                                        .frame(width: 10,height: 10)
                                        .foregroundStyle(.white)
                                        .background(Circle().foregroundStyle(Color.init(uiColor: .systemGray2)).frame(width: 20,height: 20))
                                }.offset(x: -5, y: 5)
                            }
                        }
        
                        ForEach(videos, id:\.id){ videos in
                            ZStack(alignment:.topTrailing){
                                if let videoUrl = videos.url{
                                    VideoPlayer(player:AVPlayer(url: videoUrl))
                                        .frame(width: 100,height: 100)
                                        .cornerRadius(8)
                                        .shadow(radius: 3)
                                        .padding()
                                }else {
                                    Loader()
                                }
                                Button {
                                    removeVideo(videos.id)
                                } label: {
                                    Image(systemName: "xmark")
                                        .resizable()
                                        .frame(width: 10,height: 10)
                                        .foregroundStyle(.white)
                                        .background(Circle().foregroundStyle(Color.init(uiColor: .systemGray2)).frame(width: 20,height: 20))
                                }.offset(x: -5, y: 5)
                            }
                        }
                    }
                }.padding()
                HStack{
                    Button {
                        isShowConfiguarationDialog.toggle()
                    } label: {
                        Image(systemName: "photo.badge.plus")
                            .resizable()
                            .frame(width: 65,height: 50)
                            .foregroundStyle(.black)
                        Text("Add multimedia file")
                            .foregroundStyle(.black)
                            .bold()
                    }
                    .confirmationDialog("", isPresented: $isShowConfiguarationDialog) {
                        Button {
                            isPresentPhotoPicker.toggle()
                        } label: {
                            Text("Photo")
                        }
                        Button {
                            isPresentVideoPicker.toggle()
                        } label: {
                            Text("Video")
                        }
                    }
                    .photosPicker(isPresented: $isPresentPhotoPicker, selection:$selectedImage,matching: .images)
                    .onChange(of: selectedImage) { oldValue, newValue in
                        Task{
                            if let data = try? await newValue?.loadTransferable(type: Data.self){
                                let id = UUID()
                                loadingItem.append(id)
                                viewModel.imageData.append(data)
                                AVManager.shared.loadImage(data) { result in
                                    switch result {
                                    case .success(let image):
                                        images.append((id:id,image:image,data:data))
                                        removeLoadingItem(id)
                                    case .failure(let error):
                                        print(error)
                                    }
                                }
                            }
                        }
                    }
                    .photosPicker(isPresented: $isPresentVideoPicker, selection:$selectedVideo,matching: .videos)
                    .onChange(of: selectedVideo) { oldValue, newValue in
                        if let newValue = newValue {
                            let id = UUID()
                            DispatchQueue.main.async {
                                loadingItem.append(id)
                                videos.append((id:id,url:nil))
                            }
                            Task{
                                if let data = try? await newValue.loadTransferable(type: Data.self){
                                    AVManager.shared.loadVideo(data, id: id) { result in
                                        switch result {
                                        case .success(let url):
                                            DispatchQueue.main.async {
                                                if let index = videos.firstIndex(where: { $0.id == id }) {
                                                    withAnimation {
                                                        videos[index] = (id: id, url: url)
                                                        removeLoadingItem(id)
                                                        viewModel.videoStrUrl.append(url.absoluteString)
                                                    }
                                                }
                                            }
                                        case .failure(let error):
                                            print(error)
                                        }
                                    }
                                    
                                }else{
                                    removeLoadingItem(id)
                                }
                            }
                        }
                    }
                }
            }
            .onTapGesture {
                HideKeyBoard.shared.hideKeyboard()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dissmiss.callAsFunction()
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 20,height: 20)
                            .bold()
                            .foregroundStyle(.black)
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("Add Word")
                        .bold()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.addWord()
                        dissmiss.callAsFunction()
                    } label: {
                        Text("Add")
                            .padding()
                            .frame(width:70,height: 35)
                            .background(isDisabled ? Color.init(uiColor: .systemGray6) : Color.red)
                            .cornerRadius(15)
                            .foregroundStyle(isDisabled ? .gray : .white)
                            .bold()
                    }.disabled(isDisabled)
                }
            }
        }
        
    }
}

#Preview {
    AddWordView( viewModel: AddWordViewModel(dataSource: .shared))
        .modelContainer(WordModel.preview)
}

extension AddWordView{
    
    private func removeVideo(_ id:UUID){
        withAnimation {
            if let index = videos.firstIndex(where: {$0.id == id}){
                let removeUrl = videos[index].url
                videos.remove(at: index)
    
                if let urlIndex = viewModel.videoStrUrl.firstIndex(of: removeUrl!.absoluteString){
                    viewModel.videoStrUrl.remove(at: urlIndex)
                }
            }
        }
    }
    
    private func removeImage(_ id:UUID){
        withAnimation {
            if let index = images.firstIndex(where: {$0.id == id}){
                let removeData = images[index].data
                images.remove(at: index)
                
                if let dataIndex = viewModel.imageData.firstIndex(of: removeData){
                    viewModel.imageData.remove(at: dataIndex)
                }
            }
        }
    }
    private func removeLoadingItem(_ id: UUID) {
        DispatchQueue.main.async {
            withAnimation {
                loadingItem.removeAll { $0 == id }
            }
        }
    }

}



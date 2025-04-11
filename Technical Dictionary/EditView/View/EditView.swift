//
//  EditView.swift
//  Technical Dictionary
//
//  Created by 71m3 on 2025-03-14.
//
import SwiftUI
import PhotosUI
import AVKit

struct EditView: View {
    
    @State private var isShowConfiguarationDialog = false
    @State private var isPresentPhotoPicker = false
    @State private var isPresentVideoPicker = false
    
    @State private var selectedVideo:PhotosPickerItem?
    @State private var selectedImage:PhotosPickerItem?
    
    @State private var loadingImages: [UUID: Task<Void, Never>] = [:]
    @State private var loadingVideos: [UUID: Task<Void, Never>] = [:]
    
    @Environment(\.dismiss) var dismiss
    
    @Bindable var viewModel:EditViewModel
    
    var body: some View {
        NavigationStack{
            ScrollView(showsIndicators: false){
                    ScrollView(.horizontal,showsIndicators: false) {
                        HStack{
                            ForEach(Array(loadingImages.keys), id: \.self) { id in
                                ZStack(alignment: .topTrailing) {
                                    Loader()
                                    Button {
                                        loadingImages[id]?.cancel()
                                        loadingImages.removeValue(forKey: id)
                                    } label: {
                                        Image(systemName: "xmark")
                                            .resizable()
                                            .frame(width: 10, height: 10)
                                            .foregroundStyle(.white)
                                            .background(Circle().foregroundStyle(Color(uiColor: .systemGray2)).frame(width: 20, height: 20))
                                    }.offset(x: -5, y: 5)
                                }
                            }

                            ForEach(Array(loadingVideos.keys), id: \.self) { id in
                                ZStack(alignment: .topTrailing) {
                                    Loader()
                                    Button {
                                        loadingVideos[id]?.cancel()
                                        loadingVideos.removeValue(forKey: id)
                                    } label: {
                                        Image(systemName: "xmark")
                                            .resizable()
                                            .frame(width: 10, height: 10)
                                            .foregroundStyle(.white)
                                            .background(Circle().foregroundStyle(Color(uiColor: .systemGray2)).frame(width: 20, height: 20))
                                    }.offset(x: -5, y: 5)
                                }
                            }
                            if let imageData = viewModel.draftWordInfo.imageData{
                                ForEach(imageData,id: \.self){ data in
                                    if let image = UIImage(data: data){
                                        ZStack(alignment: .topTrailing) {
                                            Image(uiImage: image)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 150)
                                                .cornerRadius(8)
                                                .shadow(radius: 3)
                                                .padding()
                                            Button {
                                                if let index = imageData.firstIndex(of: data){
                                                    viewModel.draftWordInfo.imageData?.remove(at: index)
                                                }
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
                            }
                            
                            if let videoUrl = viewModel.draftWordInfo.videoUrlStr {
                            ForEach(videoUrl,id: \.self){ urlStr in
                                if let url = URL(string: urlStr ){
                                    ZStack(alignment: .topTrailing) {
                                        VideoPlayer(player:AVPlayer(url: url))
                                            .scaledToFit()
                                            .frame(width: 150)
                                            .cornerRadius(8)
                                            .shadow(radius: 3)
                                            .padding()
                                        Button {
                                            if let index = videoUrl.firstIndex(of: urlStr) {
                                                viewModel.draftWordInfo.videoUrlStr?.remove(at: index)
                                            }
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
                        }
                            
                            Button {
                                isShowConfiguarationDialog.toggle()
                            } label: {
                                Image(systemName: "photo.badge.plus")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(.black)
                                    .frame(width: 150)
                                    .cornerRadius(8)
                                    .shadow(radius: 3)
                                    .padding()
                                    .scaledToFill()
                            }  .confirmationDialog("", isPresented: $isShowConfiguarationDialog) {
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
                            }    .photosPicker(isPresented: $isPresentPhotoPicker, selection:$selectedImage,matching: .images)
                                .onChange(of: selectedImage) { oldValue, newValue in
                                    let id = UUID()
                                    if let newValue = newValue {
                                       let task = Task{
                                            if let data = try? await newValue.loadTransferable(type: Data.self){
                                                viewModel.draftWordInfo.imageData?.append(data)
                                                DispatchQueue.main.async {
                                                    loadingImages.removeValue(forKey: id)
                                                }
                                            } else {
                                                DispatchQueue.main.async {
                                                    loadingImages.removeValue(forKey: id)
                                                }
                                            }
                                        }
                                        DispatchQueue.main.async {
                                            loadingImages[id] = task
                                        }
                                      
                                    }
                                }
                         
                                .photosPicker(isPresented: $isPresentVideoPicker, selection:$selectedVideo,matching: .videos)
                                .onChange(of: selectedVideo) { oldValue, newValue in
                                    let id = UUID()
                                    if let newValue = newValue {
                                      let task = Task{
                                            if let data = try? await newValue.loadTransferable(type: Data.self){
                                                AVManager.shared.loadVideo(data, id: id) { result in
                                                    switch result {
                                                    case .success(let url):
                                                        DispatchQueue.main.async {
                                                            viewModel.draftWordInfo.videoUrlStr?.append(url.absoluteString)
                                                        }
                                                    case .failure(let failure):
                                                        print(failure)
                                                    }
                                                    loadingVideos.removeValue(forKey: id)
                                                }
                                            }else {
                                                DispatchQueue.main.async{
                                                    loadingVideos.removeValue(forKey: id)
                                                }
                                            }
                                        }
                                        loadingVideos[id] = task
                                    }
                                }
                            }
                    }
                VStack(alignment: .leading,spacing:5){
                    Text("New Word")
                        .padding(.leading,10)
                    TextField("", text: $viewModel.draftWordInfo.word)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke( Color.black, lineWidth: 1)
                        )
                        .frame(width: 370)
                }
                VStack(alignment: .leading,spacing: 5){
                    Text("Description")
                        .padding(.leading,10)
                    TextEditor(text: $viewModel.draftWordInfo.wordDescription)
                        .frame(height: 300)
                        .padding(8)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.black, lineWidth: 1)
                        )
                        .frame(width: 370)
                }.padding()
            }
            .onTapGesture {
                HideKeyBoard.shared.hideKeyboard()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        viewModel.rollback()
                        dismiss.callAsFunction()
                        
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 20,height: 20)
                            .bold()
                            .foregroundStyle(.black)
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("Edit")
                        .bold()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.saveChanges()
                        dismiss.callAsFunction()
                    } label: {
                        Text("Done")
                            .padding()
                            .frame(width:75,height: 35)
                            .background (Color.red)
                            .cornerRadius(15)
                            .foregroundStyle(.white)
                            .bold()
                    }
                }
            }
        }
        
    }
}



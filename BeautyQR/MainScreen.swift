//
//  ContentView.swift
//  BeautyQR
//
//  Created by Ilya Cherkasov on 09.12.2021.
//

import SwiftUI

struct MainScreen: View {
    
    @State private var isShowingPhotoPicker = false
    @State private var isPhotoReady = false
    @State private var sourceImage = UIImage()
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Text("QR-код всегда под рукой!")
                        .bold()
                    Text("Просто добавьте картинку с кодом из галереи или отсканируйте камерой")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
                HStack {
                    Button("Выбрать из галереи") {
                        isShowingPhotoPicker = true
                    }
                    .frame(maxWidth: .infinity, minHeight: 56)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    Button {
                        
                    } label: {
                        Image("QRCode")
                    }
                    .frame(width: 56, height: 56)
                    .background(Color(red: 230 / 255, green: 242 / 255, blue: 1))
                    .cornerRadius(20)
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
                .padding()
                NavigationLink(isActive: $isPhotoReady) {
                    StyleChoosing(sourceImage: $sourceImage)
                } label: {}
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("BeatyQR") // ломает лэйаут
            .sheet(isPresented: $isShowingPhotoPicker) {
                PhotoPicker(sourceImage: $sourceImage) { success in
                    isPhotoReady = success
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle()) // чинит лэйаут
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}

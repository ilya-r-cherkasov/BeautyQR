//
//  StyleChoosing.swift
//  BeautyQR
//
//  Created by Ilya Cherkasov on 09.12.2021.
//

import SwiftUI
import EFQRCode
import WidgetKit

struct StyleChoosing: View {
    
    var spacing: CGFloat = 15.0
    var trailingSpace: CGFloat = 150
    @Binding var sourceImage: UIImage
    @GestureState var offset: CGFloat = 0
    @State var currentIndex: Int = 0
    @State var imageList = [UIImage]()
    
    var body: some View {
        NavigationView {
            VStack {
                GeometryReader { proxy in
                    let width = proxy.size.width - (trailingSpace - spacing)
                    let adjustMentWidth = (trailingSpace / 2) - spacing
                    HStack(spacing: spacing){
                        ForEach(imageList, id: \.self) { image in
                            GeometryReader { proxy in
                                let scale = getScale(proxy: proxy)
                                Image(uiImage: image)
                                    .resizable()
                                    .scaleEffect(scale)
                            }
                            .padding()
                            .frame(
                                width: max(proxy.size.width - trailingSpace, 0),
                                height: max(proxy.size.width - trailingSpace, 0)
                            )
                        }
                    }
                    .frame(maxHeight: .infinity, alignment: .center)
                    .padding(.horizontal, spacing)
                    .offset(x: (CGFloat(currentIndex) * -width) + adjustMentWidth + offset)
                    .gesture(
                        DragGesture()
                            .updating($offset, body: { value, out, _ in
                                out = value.translation.width
                            })
                            .onEnded({ value in
                                let offsetX = value.translation.width
                                let progress = -offsetX / width
                                let roundIndex = progress.rounded()
                                currentIndex = max(min(currentIndex + Int(roundIndex), 5), 0)
                            })
                    )
                }
                .animation(.easeInOut, value: offset == 0)
                Button("Готово") {
                    saveImageAndRefreshWidget(imageList[currentIndex])
                }
                .frame(maxWidth: .infinity, minHeight: 56)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(20)
                .padding()
            }
        }
        .navigationBarTitle(Text("Выбор стиля"), displayMode: .inline)
        .onAppear {
            for num in 1...6 {
                let image = generate(for: recognize().first ?? "", placeholer: "placeholder\(num)")
                imageList.append(image)
            }
        }
    }
    
    private func getScale(proxy: GeometryProxy) -> CGFloat {
                
        let mid = UIScreen.main.bounds.width / 2
        let left = mid * 0.2
        let right = mid * 1.8
                
        var scale: CGFloat = 1
        
        let x = proxy.frame(in: .global).midX
        
        if (left...mid).contains(x) {
            scale =  1 + abs(x - left) * 0.002
        }
        
        if (mid...right).contains(x) {
            scale =  1 + abs(x - right) * 0.002
        }
        
        return scale
    }
    
    func recognize() -> [String] {
        if let testImage = sourceImage.cgImage {
            let codes = EFQRCode.recognize(testImage)
            if !codes.isEmpty {
                print("There are \(codes.count) codes")
                for (index, code) in codes.enumerated() {
                    print("The content of QR Code \(index) is \(code).")
                }
            } else {
                print("There is no QR Codes in testImage.")
            }
            return codes
        }
        return []
    }

    func generate(for url: String, placeholer: String) -> UIImage {
        if let image = EFQRCode.generate(
            for: url,
            watermark: UIImage(named: placeholer)?.cgImage
        ) {
            print("Create QRCode image success \(image)")
            return UIImage(cgImage: image)
        } else {
            print("Create QRCode image failed!")
            return UIImage()
        }
    }
    
    func saveImageAndRefreshWidget(_ image: UIImage) {
        if let pngRepresentation = image.pngData(),
           let userDefaults = UserDefaults(suiteName: "group.qrCodeSuite") {
            userDefaults.set(pngRepresentation, forKey: "qrcode")
            userDefaults.synchronize()
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
}

struct StyleChoosing_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}

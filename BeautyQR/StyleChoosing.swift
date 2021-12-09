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
    
    @Binding var sourceImage: UIImage
    
    var body: some View {
        Image(uiImage: generate(for: recognize().first ?? ""))
            .resizable()
            .frame(width: 300, height: 300, alignment: .center)
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
    
    func generate(for url: String) -> UIImage {
        if let image = EFQRCode.generate(
            for: url,
            watermark: UIImage(named: "Cat")?.cgImage
        ) {
            print("Create QRCode image success \(image)")
            if let pngRepresentation = UIImage(cgImage: image).pngData(),
               let userDefaults = UserDefaults(suiteName: "group.qrCodeSuite") {
                userDefaults.set(pngRepresentation, forKey: "qrcode")
                userDefaults.synchronize()
                WidgetCenter.shared.reloadAllTimelines()
            }
            return UIImage(cgImage: image)
        } else {
            print("Create QRCode image failed!")
            return UIImage()
        }
    }
    
}

//
//  StyleChoosing.swift
//  BeautyQR
//
//  Created by Ilya Cherkasov on 09.12.2021.
//

import SwiftUI

struct StyleChoosing: View {
    
    @Binding var sourceImage: UIImage
    
    var body: some View {
        Image(uiImage: sourceImage)
            .resizable()
    }
    
}

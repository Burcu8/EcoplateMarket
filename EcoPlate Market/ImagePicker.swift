//
//  ImagePicker.swift
//  EcoPlate Market
//
//  Created by Burcu Kamilçelebi on 19.03.2025.
//

import SwiftUI
import PhotosUI

struct ImagePicker: View {
    @Binding var selectedImage: UIImage?
    @State private var selectedItem: PhotosPickerItem? = nil

    var body: some View {
        VStack {
            PhotosPicker(
                selection: $selectedItem,
                matching: .images,
                photoLibrary: .shared()
            ) {
                Text("Fotoğraf Seç")
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
            }

            if let selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 200, maxHeight: 200)
                    .padding()
            }
        }
        .onChange(of: selectedItem) { newItem in
            Task {
                if let selectedItem = selectedItem {
                    do {
                        let data = try await selectedItem.loadTransferable(type: Data.self)
                        if let data, let uiImage = UIImage(data: data) {
                            selectedImage = uiImage
                        }
                    } catch {
                        print("Görsel seçilirken hata oluştu: \(error)")
                    }
                }
            }
        }
    }
}





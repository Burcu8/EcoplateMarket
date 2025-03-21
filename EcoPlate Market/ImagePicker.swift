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
        PhotosPicker(
            selection: $selectedItem,
            matching: .images,
            photoLibrary: .shared()) {
                Text("Fotoğraf Seç")
            }
            .onChange(of: selectedItem) { newItem in
                Task {
                    // Fetch selected asset in the form of Data
                    if let selectedItem = selectedItem {
                        // Retrieve selected asset
                        do {
                            let data = try await selectedItem.loadTransferable(type: Data.self)
                            if let data, let uiImage = UIImage(data: data) {
                                selectedImage = uiImage
                            }
                        } catch {
                            print("Yükleme sırasında bir hata oluştu: \(error)")
                        }
                    }
                }
            }
    }
}






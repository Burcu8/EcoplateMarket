//
//  LoadingView.swift
//  EcoPlate Market
//
//  Created by Burcu Kamilçelebi on 18.05.2025.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
            Text("Yükleniyor...")
        }
    }
}

#Preview {
    LoadingView()
}

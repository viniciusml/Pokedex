//
//  PokeWidgetEntryView.swift
//  PokeWidgetExtension
//
//  Created by Vinicius Moreira Leal on 06/02/2021.
//  Copyright © 2021 Vinicius Moreira Leal. All rights reserved.
//

import SwiftUI

struct PokeWidgetEntryView : View {
    var entry: PokemonProvider.Entry
    
    var body: some View {
        ZStack {
            Color(.defaultRed)
            VStack {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
                Text(entry.pokemon.name)
                    .font(.medium)
                    .multilineTextAlignment(.center)
                    .frame(height: 40)
                    .padding(.bottom, 15)
            }
        }
        .widgetURL(URL(string: "https://pokeapi.co/api/v2/pokemon/\(entry.pokemon.id)/"))
    }
    
    private var image: UIImage {
        entry.emptyImageData ? .placeholder : .imageWith(entry.imageData)
    }
    
    private var contentMode: ContentMode {
        entry.pokemon.imageData.isEmpty ? .fill : .fit
    }
}

private extension PokemonEntry {
    var emptyImageData: Bool {
        pokemon.imageData.isEmpty
    }
    
    var imageData: Data {
        pokemon.imageData
    }
}

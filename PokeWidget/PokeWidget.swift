//
//  PokeWidget.swift
//  PokeWidget
//
//  Created by Vinicius Moreira Leal on 24/01/2021.
//  Copyright © 2021 Vinicius Moreira Leal. All rights reserved.
//

import WidgetKit
import SwiftUI

extension ChosenPokemon {
    static var placeholder: ChosenPokemon {
        ChosenPokemon(id: 1, name: "What's that Pokémon?", imageData: .init())
    }
    
    static var failed: ChosenPokemon {
        ChosenPokemon(id: 1, name: "No Pokémon found", imageData: .init())
    }
}

struct PokemonProvider: TimelineProvider {
    let loader: RemoteChosenPokemonLoader
    
    func placeholder(in context: Context) -> PokemonEntry {
        PokemonEntry(date: Date(), pokemon: .placeholder)
    }

    func getSnapshot(in context: Context, completion: @escaping (PokemonEntry) -> ()) {
        let entry = PokemonEntry(date: Date(), pokemon: .placeholder)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<PokemonEntry>) -> ()) {
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 5, to: currentDate)!
        
        loadChosenPokemon { pokemon in
            let entry = PokemonEntry(date: currentDate, pokemon: pokemon ?? .failed)
            
            let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
            completion(timeline)
        }
    }
    
    func loadChosenPokemon(completion: @escaping ((ChosenPokemon?) -> Void)) {
        loader.load { result in
            completion(try? result.get())
        }
    }
}

struct PokemonEntry: TimelineEntry {
    let date: Date
    let pokemon: ChosenPokemon
}

struct PokeWidgetEntryView : View {
    var entry: PokemonProvider.Entry
    
    var body: some View {
        VStack {
            Image(uiImage: UIImage(named: "placeholder")!)
                .resizable()
                .scaledToFill()
            Text(entry.pokemon.name)
                .font(.medium)
                .multilineTextAlignment(.center)
                .padding(.bottom, 15)
        }.background(Color(.defaultRed))
    }
}

@main
struct PokeWidget: Widget {
    let kind: String = "PokeWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: PokemonProvider(loader: .makeLoader())) { entry in
            PokeWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("What's that Pokémon")
        .description("This is a random Pokémon.")
    }
}

import PokemonDomain

extension RemoteChosenPokemonLoader {
    
    static func makeLoader() -> RemoteChosenPokemonLoader {
        let client = AFHTTPClient()
        let listLoader = RemoteListLoader(client: client)
        let pokemonLoader = RemotePokemonLoader(client: client)
        let imageDataLoader = RemoteImageDataLoader(client: client)
        let randomIDProvider = RandomIDProvider()
        
        return RemoteChosenPokemonLoader(
            listLoader: listLoader,
            pokemonLoader: pokemonLoader,
            imageDataLoader: imageDataLoader,
            idProvider: randomIDProvider)
    }
}

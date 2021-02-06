//
//  PokeWidget.swift
//  PokeWidget
//
//  Created by Vinicius Moreira Leal on 24/01/2021.
//  Copyright © 2021 Vinicius Moreira Leal. All rights reserved.
//

import PokemonDomain
import WidgetKit
import SwiftUI

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
        let refreshDate = Calendar.current.date(byAdding: .hour, value: 5, to: currentDate)!
        
        loadChosenPokemon { pokemon in
            let entry = PokemonEntry(date: currentDate, pokemon: pokemon ?? .failed)
            
            let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
            completion(timeline)
        }
    }
    
    func loadChosenPokemon(completion: @escaping ((ChosenPokemon?) -> Void)) {
        loader.load { completion(try? $0.get()) }
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

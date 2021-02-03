//
//  PokeWidget.swift
//  PokeWidget
//
//  Created by Vinicius Moreira Leal on 24/01/2021.
//  Copyright © 2021 Vinicius Moreira Leal. All rights reserved.
//

import WidgetKit
import SwiftUI
import PokeWidgetEngine

extension ChosenPokemon {
    static var placeholder: ChosenPokemon {
        ChosenPokemon(id: 1, name: "A Pokémon", imageData: .init())
    }
}

struct PokemonProvider: TimelineProvider {
    func placeholder(in context: Context) -> PokemonEntry {
        PokemonEntry(date: Date(), pokemon: .placeholder)
    }

    func getSnapshot(in context: Context, completion: @escaping (PokemonEntry) -> ()) {
        let entry = PokemonEntry(date: Date(), pokemon: .placeholder)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<PokemonEntry>) -> ()) {
        var entries: [PokemonEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = PokemonEntry(date: entryDate, pokemon: .placeholder)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
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
            Text(entry.date, style: .time)
            Text(entry.pokemon.name)
        }
    }
}

@main
struct PokeWidget: Widget {
    let kind: String = "PokeWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: PokemonProvider()) { entry in
            PokeWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("What's that Pokémon")
        .description("This is a random Pokémon.")
    }
}

struct PokeWidget_Previews: PreviewProvider {
    static var previews: some View {
        PokeWidgetEntryView(entry: PokemonEntry(date: Date(), pokemon: .placeholder))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

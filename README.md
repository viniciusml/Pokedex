# PokédexApp

> An application that displays a list of Pokémon from '[PokéAPI](https://pokeapi.co)'. When the user selects a Pokémon, the app shows image/s representing it and its type, stats and abilities.

![CI](https://github.com/viniciusml/Pokedex/workflows/CI/badge.svg)
[![codecov](https://codecov.io/gh/viniciusml/Pokedex/branch/master/graph/badge.svg?token=0MEJ7ZMR7X)](undefined)

> Entire app was written following a  TDD methodology.

> MVVM was used as design pattern.

> WidgetKit was used to display widget with a randomly fetched Pokémon.

- Target: iOS 14+

## App
![Pokémon List](https://github.com/viniciusml/Pokedex/blob/master/Resources/list.jpg?raw=true)

![Pokémon](https://github.com/viniciusml/Pokedex/blob/master/Resources/pokemon.jpg?raw=true)

## List Loading

### Data (Input):

-  URL
-  Page (offset)

### Primary course (happy path):

1.  Execute "Load Resource List" command with above data.
2.  System downloads data from the URL.
3.  System decodes downloaded data.
4.  System creates list item from valid data.
5.  System delivers list item.
6.  As user scrolls, data is prefetched with next page request, and list gets updated on fetch success.

### Invalid data – error course (sad path):

1.  System delivers error.

### No connectivity – error course (sad path):

1.  System delivers error.

## Pokémon Loading

### Data (Input):

-  URL
-  Id

### Primary course (happy path):

1.  Execute "Load Pokemon" command with above data.
2.  System downloads data from the URL.
3.  System decodes downloaded data.
4.  System creates pokémon item from valid data.
5.  System delivers pokémon item.

### Invalid data – error course (sad path):

1.  System delivers error.

### No connectivity – error course (sad path):

1.  System delivers error.

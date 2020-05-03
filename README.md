# PokédexApp

> An application that displays a list of Pokémon from '[PokéAPI](https://pokeapi.co)'. When the user selects a Pokémon, the app shows image/s representing it and its type, stats and abilities.

[![Build Status](https://travis-ci.com/viniciusml/Pokedex.svg?branch=master)](https://travis-ci.com/viniciusml/Pokedex)

> Unit tests were written in TDD methodology for the Networking implementation.

> MVVM was used as design pattern.

> Other patterns utilised: Delegate and Observer.

- Target: iOS 10+

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

# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'Pokedex' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  target 'PokemonDomain' do
    inherit! :search_paths
  end
  
  target 'PokemonDomainTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'PokedexTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'ViewControllerPresentationSpy', '~> 5.0'
  end

  target 'PokedexEndToEndTests' do
    inherit! :search_paths
    # Pods for testing
  end
  
  target 'PokedexSnapshotTests' do
    inherit! :search_paths
    # Pods for testing
    
    pod 'SnapshotTesting', '~> 1.8.1'
    pod 'AccessibilitySnapshot'
  end

end

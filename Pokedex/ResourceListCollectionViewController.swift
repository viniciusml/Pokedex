//
//  ViewController.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 25/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import UIKit

public class ResourceListCollectionViewController: UICollectionViewController {
    
    let client = HTTPClient()
    
    var loader: RemoteLoader {
        RemoteLoader(client: client)
    }
    
    public var list = [ResultItem]()
    
    public init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchResourceList()
    }
    
    private func fetchResourceList() {
        
        loader.loadResourceList(page: "0") { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success(item):
                self.list = item.results
            case .failure:
                break
            }
        }
    }
}

extension ResourceListCollectionViewController {
    
    public override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}

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
    
    public var list = [ResultItem]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    public init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Pokédex"
        collectionView.register(ListCell.self, forCellWithReuseIdentifier: ListCell.identifier)
        collectionView.backgroundColor = .white
        
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

extension ResourceListCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    public override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = list[indexPath.item]
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCell.identifier, for: indexPath) as? ListCell {
            cell.item = item
            return cell
        }
        return UICollectionViewCell()
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 32, left: 8, bottom: 8, right: 8)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width - 36) / 3
        let height = width * 0.8
        return CGSize(width: width, height: height)
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct ResourceListViewRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let vc = ResourceListCollectionViewController()
        vc.list = makeFakeList()
        return vc.view
    }
    
    func makeFakeList() -> [ResultItem] {
        var list = [ResultItem]()
        for i in 0...20 {
            list.append(ResultItem(name: "Name \(i)", url: ""))
        }
        return list
    }
    
    func updateUIView(_ view: UIView, context: Context) {
        
    }
}

@available(iOS 13.0, *)
struct MyViewController_Preview: PreviewProvider {
    static var previews: some View {
        ResourceListViewRepresentable()
    }
}
#endif

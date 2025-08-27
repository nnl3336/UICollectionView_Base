//
//  ContentView.swift
//  UICollectionView_Base
//
//  Created by Yuki Sasaki on 2025/08/27.
//

import SwiftUI
import UIKit

// MARK: - UICollectionView
class MyCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var collectionView: UICollectionView!
    private let items = Array(1...30).map { "Item \($0)" }
    
    // 選択状態保持
    var selectedItems = Set<IndexPath>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.allowsMultipleSelection = true // 複数選択可能
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        // 長押しジェスチャー追加
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        collectionView.addGestureRecognizer(longPress)
    }
    
    // MARK: - 長押しハンドラー
    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        let point = gesture.location(in: collectionView)
        if let indexPath = collectionView.indexPathForItem(at: point),
           let cell = collectionView.cellForItem(at: indexPath) {
            cell.isSelected.toggle()
            cell.backgroundColor = cell.isSelected ? .systemRed : .systemBlue
        }
    }

    
    // MARK: - DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = selectedItems.contains(indexPath) ? .systemRed : .systemBlue
        
        // ラベル
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        let label = UILabel(frame: cell.contentView.bounds)
        label.text = items[indexPath.item]
        label.textColor = .white
        label.textAlignment = .center
        cell.contentView.addSubview(label)
        
        return cell
    }
}

// MARK: - SwiftUI 側ラッパー
struct CollectionViewWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> MyCollectionViewController {
        return MyCollectionViewController()
    }
    
    func updateUIViewController(_ uiViewController: MyCollectionViewController, context: Context) {
        // 状態が変わったときに更新処理を書く（今回は空でOK）
    }
}

// MARK: - Preview
struct ContentView: View {
    var body: some View {
        CollectionViewWrapper()
            .edgesIgnoringSafeArea(.all)
    }
}

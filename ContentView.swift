//
//  ContentView.swift
//  UICollectionView_Base
//
//  Created by Yuki Sasaki on 2025/08/27.
//

import SwiftUI
import UIKit

struct Item: Hashable {
    let id = UUID()
    let title: String
}

class MyCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var collectionView: UICollectionView!
    private let items = (1...30).map { Item(title: "Item \($0)") }
    private var selectedItems = Set<Item>()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.text = "選択中: 0 個"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // 上部ラベル
        view.addSubview(countLabel)
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            countLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            countLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // UICollectionView 設定
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = true
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: countLabel.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // 長押しジェスチャー
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        collectionView.addGestureRecognizer(longPress)
    }
    
    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        let point = gesture.location(in: collectionView)
        if let indexPath = collectionView.indexPathForItem(at: point) {
            let item = items[indexPath.item]
            if selectedItems.contains(item) {
                selectedItems.remove(item)
                collectionView.deselectItem(at: indexPath, animated: true)
            } else {
                selectedItems.insert(item)
                collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
            }
            
            if let cell = collectionView.cellForItem(at: indexPath) {
                cell.backgroundColor = selectedItems.contains(item) ? .systemRed : .systemBlue
            }
            
            // UILabel 更新
            countLabel.text = "選択中: \(selectedItems.count) 個"
        }
    }
    
    // MARK: - DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let item = items[indexPath.item]
        
        cell.backgroundColor = selectedItems.contains(item) ? .systemRed : .systemBlue
        
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        let label = UILabel(frame: cell.contentView.bounds)
        label.text = item.title
        label.textColor = .white
        label.textAlignment = .center
        cell.contentView.addSubview(label)
        
        return cell
    }
}


// MARK: - SwiftUI ラッパー
struct CollectionViewWrapper: UIViewControllerRepresentable {
    
    @Binding var selectedCount: Int
    
    func makeUIViewController(context: Context) -> MyCollectionViewController {
        let vc = MyCollectionViewController()
        return vc
    }
    
    func updateUIViewController(_ uiViewController: MyCollectionViewController, context: Context) {}
}

// MARK: - SwiftUI 表示
struct ContentView: View {
    @State private var selectedCount = 0
    
    var body: some View {
        VStack {
            Text("選択中: \(selectedCount) 個")
                .font(.title)
                .padding()
            CollectionViewWrapper(selectedCount: $selectedCount)
                .edgesIgnoringSafeArea(.all)
        }
    }
}

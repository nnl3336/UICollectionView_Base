//
//  UICollectionView_BaseApp.swift
//  UICollectionView_Base
//
//  Created by Yuki Sasaki on 2025/08/27.
//

import SwiftUI

@main
struct UICollectionView_BaseApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

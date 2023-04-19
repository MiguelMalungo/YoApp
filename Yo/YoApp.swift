//
//  YoApp.swift
//  Yo
//
//  Created by JOSE MIGUEL FERRAZ GUEDES on 19/04/2023.
//

import SwiftUI

@main
struct YoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

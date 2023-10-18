//
//  App.swift
//  starter_ios
//
//  Created by Vu on 10/16/23.
//

import SwiftUI
import Flutter
import FlutterPluginRegistrant

@main
struct MyApp: App {
    @StateObject var ensembleApp = EnsembleApp()
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView().environmentObject(ensembleApp)
            }
        }
    }
}

class EnsembleApp: ObservableObject {
    let flutterEngine = FlutterEngine(name: "Ensemble")
    init() {
        flutterEngine.run()
        GeneratedPluginRegistrant.register(with: self.flutterEngine);
    }
}

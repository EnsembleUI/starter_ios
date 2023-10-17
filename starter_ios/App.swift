//
//  App.swift
//  starter_ios
//
//  Created by Vu on 10/16/23.
//

import SwiftUI
import Flutter
import FlutterPluginRegistrant

class FlutterDependencies: ObservableObject {
 let flutterEngine = FlutterEngine(name: "Ensemble")
 init() {
   flutterEngine.run()
   GeneratedPluginRegistrant.register(with: self.flutterEngine);
 }
}

@main
struct MyApp: App {
 @StateObject var flutterDependencies = FlutterDependencies()
   var body: some Scene {
     WindowGroup {
       NavigationStack {
         ContentView().environmentObject(flutterDependencies)
       }
     }
   }
}

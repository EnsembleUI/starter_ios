//
//  ContentView.swift
//  starter_ios
//
//  Created by Vu on 10/16/23.
//

import SwiftUI
import UIKit
import Flutter
import FlutterPluginRegistrant


struct ContentView: View {
    @EnvironmentObject var ensembleApp: EnsembleApp
    @EnvironmentObject var navigationModel: NavigationModel
    
    @State private var showAlert: Bool = false
    @State private var message: String = ""
    
    static private let channelName = "com.ensembleui.host.platform"
    
    // MARK: Platform Methods
    static private let navigateExternalScreen = "navigateExternalScreen"
    static private let fromEnsembleToHost = "fromEnsembleToHost"
    
    var body: some View {
        NavigationStack(path: $navigationModel.presentedViews) {
            VStack(spacing: 30) {
                Text("This is a SwiftUI screen")
                
                Button(action: {
                    showEnsemble()
                }) {
                    Text("Open Ensemble App")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .alert(message, isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            }
            .navigationDestination(for: NativeScreen.self) { screen in
                switch screen {
                case .ensembleHome1:
                    EnsembleRootView()
                        .environmentObject(navigationModel)
                case .ensembleHome2:
                    Text("Ensemble Home 2")
                case .profile:
                    ProfileView()
                        .environmentObject(navigationModel)
                case .settings:
                    SettingsView()
                }
            }
        }
    }

    func showEnsemble() {
        let ensembleController = FlutterViewController(
          engine: ensembleApp.flutterEngine,
          nibName: nil,
          bundle: nil)
        ensembleController.modalPresentationStyle = .fullScreen
        ensembleController.modalTransitionStyle = .coverVertical
        
        // listen for data from Ensemble
        registerEnsembleListeners(ensembleController: ensembleController)
        
        // send environment variables
        sendEnvVariables(ensembleController: ensembleController);
        
        // Adding Ensemble View to NavigationStack
        navigationModel.presentedViews.append(.ensembleHome1)
  }
    
    func registerEnsembleListeners(ensembleController: FlutterViewController) {
        let ensembleMethodChannel = FlutterMethodChannel(name: ContentView.channelName, binaryMessenger: ensembleController.binaryMessenger)
        // Receive data from Ensemble
        ensembleMethodChannel.setMethodCallHandler({ (call: FlutterMethodCall, result: FlutterResult) -> Void in

            if (call.method == ContentView.navigateExternalScreen) {
                let arguments = call.arguments as? [String: Any]
                if let screenName = arguments?["name"] as? String {
                    DispatchQueue.main.async {
                        self.navigationModel.inputs = arguments?["inputs"] as? [String: Any]
                        self.navigationModel.options = arguments?["options"] as? [String: Any]
                        self.navigationModel.screenName = NativeScreen(rawValue: screenName)
                        if let viewToPresent = NativeScreen(rawValue: screenName) {
                            // Adding View to NavigationStack
                            self.navigationModel.presentedViews.append(viewToPresent)
                        }
                    }
                }
                result(nil)
            } else if (call.method == ContentView.fromEnsembleToHost) {
                ensembleController.dismiss(animated: true, completion: nil)
                if let dictonary = call.arguments as? NSDictionary {
                    print("Data From Ensemble: \(String(describing: dictonary))")
                    self.message = dictonary.description
                    showAlert = true
                } else {
                    print("Failed to get data from ensemble")
                }
            } else {
                result(FlutterMethodNotImplemented)
            }

        })
    }
    
    func sendEnvVariables(ensembleController: FlutterViewController) {
        let ensembleMethodChannel = FlutterMethodChannel(name: ContentView.channelName, binaryMessenger: ensembleController.binaryMessenger)
        
        let dict = [
            "token": "abcdef",
            "name": "Peter Parker"
        ]
        ensembleMethodChannel.invokeMethod("updateEnvOverrides", arguments: dict)
    }
}

struct EnsembleRootView: UIViewControllerRepresentable {
    @EnvironmentObject var ensembleApp: EnsembleApp

     func makeUIViewController(context: Context) -> FlutterViewController {
         return FlutterViewController(engine: ensembleApp.flutterEngine, nibName: nil, bundle: nil)
     }

     func updateUIViewController(_ flutterViewController: FlutterViewController, context: Context) {
         // Can update the FlutterViewController here if needed.
         flutterViewController.navigationItem.title = "Ensemble View"
     }
 }

#Preview {
    ContentView()
}

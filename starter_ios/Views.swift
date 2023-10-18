//
//  Views.swift
//  starter_ios
//
//  Created by Vu on 10/17/23.
//

import SwiftUI
import UIKit
import Flutter
import FlutterPluginRegistrant

enum NativeScreen: String {
    case ensembleHome1 = "EnsembleHome1Screen"
    case ensembleHome2 = "EnsembleHome2Screen"
    case profile = "ProfileScreen"
    case settings = "SettingsScreen"
}

class NavigationModel: ObservableObject {
    @Published var presentedViews: [NativeScreen] = []
    @Published var screenName: NativeScreen? = nil
    @Published var inputs: [String: Any]?
    @Published var options: [String: Any]?
}

struct ProfileView: View {
    @EnvironmentObject var ensembleApp: EnsembleApp
    @EnvironmentObject var navigationModel: NavigationModel
    
    static private let channelName = "com.ensembleui.host.platform"
    
    // MARK: Platform Methods
    static private let navigateExternalScreen = "navigateExternalScreen"
    static private let fromEnsembleToHost = "fromEnsembleToHost"
    
    var body: some View {
        VStack {
            Text("Profile View in Swift")
            Text("Inputs: \(navigationModel.inputs?.description ?? "")")
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
        .navigationTitle("SwiftUI - Profile")
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
        let ensembleMethodChannel = FlutterMethodChannel(name: ProfileView.channelName, binaryMessenger: ensembleController.binaryMessenger)
        // Receive data from Ensemble
        ensembleMethodChannel.setMethodCallHandler({ (call: FlutterMethodCall, result: FlutterResult) -> Void in

            if (call.method == ProfileView.navigateExternalScreen) {
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
                
            } else if (call.method == ProfileView.fromEnsembleToHost) {
                ensembleController.dismiss(animated: true, completion: nil)
                if let dictonary = call.arguments as? NSDictionary {
                    print("Data From Ensemble: \(String(describing: dictonary))")
//                    self.message = dictonary.description
//                    showAlert = true
                } else {
                    print("Failed to get data from ensemble")
                }
            } else {
                result(FlutterMethodNotImplemented)
            }

        })
    }
    
    func sendEnvVariables(ensembleController: FlutterViewController) {
        let ensembleMethodChannel = FlutterMethodChannel(name: ProfileView.channelName, binaryMessenger: ensembleController.binaryMessenger)
        
        let dict = [
            "token": "abcdef",
            "name": "Peter Parker"
        ]
        ensembleMethodChannel.invokeMethod("updateEnvOverrides", arguments: dict)
    }
}

struct SettingsView: View {
    @EnvironmentObject var navigationModel: NavigationModel

    var body: some View {
        VStack {
            Text("Settings View in Swift")
            Text("Inputs: \(navigationModel.inputs?.description ?? "")")
        }
    }
}



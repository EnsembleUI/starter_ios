//
//  ContentView.swift
//  starter_ios
//
//  Created by Vu on 10/16/23.
//

import SwiftUI
import UIKit
import Flutter


struct ContentView: View {
    @EnvironmentObject var ensembleApp: EnsembleApp
    @ObservedObject var navigationModel = NavigationModel()
    
    @State private var showAlert: Bool = false
    @State private var message: String = ""

    var body: some View {
        if let screen = navigationModel.screenName {
            switch screen {
            case .profile:
                ProfileView(navigationModel: navigationModel)
            case .settings:
                SettingsView(navigationModel: navigationModel)
            }
        } else {
            
            VStack(spacing: 30) {
                
                Text("This is a SwiftUI screen")
                Button(action: {
                    showEnsemble()
                }) {
                    Text("Go To Ensemble")
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
        }
    }

    func showEnsemble() {
        guard
          let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive && $0 is UIWindowScene }) as? UIWindowScene,
          let window = windowScene.windows.first(where: \.isKeyWindow),
          let rootViewController = window.rootViewController
        else { return }
        
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
        
        // show Ensemble UI
        rootViewController.present(ensembleController, animated: true)
            
    //    if let navigationController = rootViewController as? UINavigationController {
    //        navigationController.pushViewController(flutterViewController, animated: true)
    //    }
            
  }
    
    func registerEnsembleListeners(ensembleController: FlutterViewController) {
        let ensembleMethodChannel = FlutterMethodChannel(name: "com.ensembleui.host.platform", binaryMessenger: ensembleController.binaryMessenger)
        // Receive data from Ensemble
        ensembleMethodChannel.setMethodCallHandler({ (call: FlutterMethodCall, result: FlutterResult) -> Void in

            if (call.method == "navigateExternalScreen") {
                let arguments = call.arguments as? [String: Any]
                let screenName = arguments?["name"] as? String
                if (screenName != nil) {
                    DispatchQueue.main.async {
                        self.navigationModel.inputs = arguments?["inputs"] as? [String: Any]
                        self.navigationModel.options = arguments?["options"] as? [String: Any]
                        self.navigationModel.screenName = NativeScreen(rawValue: screenName!)
                        ensembleController.dismiss(animated: true)
                    }
                }
                result(nil)
                
            } else if (call.method == "fromEnsembleToHost") {
                
                ensembleController.dismiss(animated: true, completion: nil)
                
                let dictonary: NSDictionary? = call.arguments as? NSDictionary
                
                if (dictonary != nil){
                    print("Data From Ensemble: \(String(describing: dictonary))")
                    self.message = dictonary!.description
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
        let ensembleMethodChannel = FlutterMethodChannel(name: "com.ensembleui.host.platform", binaryMessenger: ensembleController.binaryMessenger)
        
        let dict = [
            "token": "abcdef",
            "name": "Peter Parker"
        ]
        ensembleMethodChannel.invokeMethod("updateEnvOverrides", arguments: dict)
    }
}

#Preview {
    ContentView()
}

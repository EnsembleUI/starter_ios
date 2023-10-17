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
  // Flutter dependencies are passed in an EnvironmentObject.
  @EnvironmentObject var flutterDependencies: FlutterDependencies
    @State private var showAlert: Bool = false
    @State private var message: String = ""

  // Button is created to call the showFlutter function when pressed.
  var body: some View {
      VStack(spacing: 30) {
        
        Text("This is a SwiftUI screen")
          NavigationLink(destination: FlutterView().environmentObject(flutterDependencies)) {
            Text("Go to Ensemble")
        }
        
        Button(action: {
            showFlutter()
        }) {
            Text("Open and \nSend Data To Ensemble App")
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

    func showFlutter() {
    // Get the RootViewController.
    guard
      let windowScene = UIApplication.shared.connectedScenes
        .first(where: { $0.activationState == .foregroundActive && $0 is UIWindowScene }) as? UIWindowScene,
      let window = windowScene.windows.first(where: \.isKeyWindow),
      let rootViewController = window.rootViewController
    else { return }

    // Create the FlutterViewController.
    let flutterViewController = FlutterViewController(
      engine: flutterDependencies.flutterEngine,
      nibName: nil,
      bundle: nil)
//    flutterViewController.modalPresentationStyle = .overCurrentContext
    flutterViewController.isViewOpaque = false
//    rootViewController.present(flutterViewController, animated: true)
        if let navigationController = rootViewController as? UINavigationController {
            navigationController.pushViewController(flutterViewController, animated: true)
                }
        
//        rootViewController.navigationController?.pushViewController(flutterViewController, animated: true)
        
    receiveDataFromEnsemble(flutterViewController: flutterViewController)
    sendDataToEnsemble(flutterViewController: flutterViewController)
  }
    
    func receiveDataFromEnsemble(flutterViewController: FlutterViewController) {
        let ensembleMethodChannel = FlutterMethodChannel(name: "com.ensemble.host.platform", binaryMessenger: flutterViewController.binaryMessenger)
        // Receive data from Ensemble
        ensembleMethodChannel.setMethodCallHandler({ (call: FlutterMethodCall, result: FlutterResult) -> Void in
            guard call.method == "fromEnsembleToHost" else {
                result(FlutterMethodNotImplemented)
                return
            }
            
            flutterViewController.dismiss(animated: true, completion: nil)
            
            let dictonary: NSDictionary? = call.arguments as? NSDictionary
            
            if (dictonary != nil){
                print("Data From Ensemble: \(String(describing: dictonary))")
                self.message = dictonary!.description
                showAlert = true
            } else {
                print("Failed to get data from ensemble")
            }

        })
    }
    
    func sendDataToEnsemble(flutterViewController: FlutterViewController) {
        let ensembleMethodChannel = FlutterMethodChannel(name: "com.ensemble.host.platform", binaryMessenger: flutterViewController.binaryMessenger)
        
        let dict = ["name": "Message sent to ENSEMBLE from HOST"]
        if let json = try? JSONEncoder().encode(dict) {
            if let jsonString = String(data: json, encoding: .utf8) {
                print(jsonString)
                ensembleMethodChannel.invokeMethod("fromHostToEnsemble", arguments: jsonString)
            }
        }
    }
}

struct FlutterView: UIViewControllerRepresentable {
    @EnvironmentObject var flutterDependencies: FlutterDependencies

    func makeUIViewController(context: Context) -> FlutterViewController {
        return FlutterViewController(engine: flutterDependencies.flutterEngine, nibName: nil, bundle: nil)
    }

    func updateUIViewController(_ flutterViewController: FlutterViewController, context: Context) {
        // Can update the FlutterViewController here if needed.
    }
}


#Preview {
    ContentView()
}

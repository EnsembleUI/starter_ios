//
//  ContentView.swift
//  starter_ios
//
//  Created by Vu on 10/16/23.
//

import SwiftUI
import Flutter

struct ContentView: View {
  // Flutter dependencies are passed in an EnvironmentObject.
  @EnvironmentObject var flutterDependencies: FlutterDependencies

  // Button is created to call the showFlutter function when pressed.
  var body: some View {
    NavigationView {
      VStack {
        Text("This is a SwiftUI screen")
        NavigationLink(destination: FlutterView().environmentObject(flutterDependencies)) {
          Text("Go to Ensemble")
        }
      }
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
    flutterViewController.modalPresentationStyle = .overCurrentContext
    flutterViewController.isViewOpaque = false

    rootViewController.present(flutterViewController, animated: true)
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

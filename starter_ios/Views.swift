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
    case ensembleRoot = "EnsembleRootScreen"
    case profile = "ProfileScreen"
    case settings = "SettingsScreen"
    case device = "DeviceDetail"
}

class NavigationModel: ObservableObject {
    @Published var presentedViews: [NativeScreen] = []
    @Published var screenName: NativeScreen? = nil
    @Published var inputs: [String: Any]?
    @Published var options: [String: Any]?
}

struct DeviceDetail: View {
    @EnvironmentObject var navigationModel: NavigationModel
    
    var parsedData: [String: Any] {
        if let dataDict = navigationModel.inputs?["data"] as? [String: Any] {
            return dataDict
        }
        return [:]
    }
    
    var body: some View {
        VStack {
            Text("This is SwiftUI").padding(20)
            Text(parsedData["name"] as? String ?? "").bold()
            Text("$\(parsedData["price"] as? String ?? "")")
            BackButton()
        }
    }
}

struct ProfileView: View {
    @EnvironmentObject var navigationModel: NavigationModel
    
    var body: some View {
        VStack {
            Text("Profile View in Swift")
            Text("Inputs: \(navigationModel.inputs?.description ?? "")")
            BackButton()
        }
        .navigationTitle("SwiftUI - Profile")
    }
}

struct SettingsView: View {
    @EnvironmentObject var navigationModel: NavigationModel

    var body: some View {
        VStack {
            Text("Settings View in Swift")
            Text("Inputs: \(navigationModel.inputs?.description ?? "")")
            BackButton()
        }
        .navigationTitle("SwiftUI - Setting")
    }
}

struct BackButton: View {
    @EnvironmentObject var navigationModel: NavigationModel
    
    var body: some View {
        Button(action: {
            // Adding Ensemble View to NavigationStack
            navigationModel.presentedViews.removeLast()
        }) {
            Text("Go Back to Ensemble")
                .font(.headline)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
}

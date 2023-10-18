//
//  Views.swift
//  starter_ios
//
//  Created by Vu on 10/17/23.
//
import Foundation
import SwiftUI

enum NativeScreen: String {
    case profile = "ProfileScreen"
    case settings = "SettingsScreen"
}

class NavigationModel: ObservableObject {
    @Published var screenName: NativeScreen? = nil
    @Published var inputs: [String: Any]?
    @Published var options: [String: Any]?
}

struct ProfileView: View {
    @ObservedObject var navigationModel: NavigationModel
    var body: some View {
        VStack {
            Text("Profile View in Swift")
            Text("Inputs: \(navigationModel.inputs?.description ?? "")")
        }
    }
}

struct SettingsView: View {
    @ObservedObject var navigationModel: NavigationModel
    var body: some View {
        VStack {
            Text("Settings View in Swift")
            Text("Inputs: \(navigationModel.inputs?.description ?? "")")
        }
    }
}



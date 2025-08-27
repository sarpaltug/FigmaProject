//
//  FigmaProjectApp.swift
//  FigmaProject
//
//  Created by Sarp Ugrasiz on 5.08.2025.
//

import SwiftUI

@main
struct FigmaProjectApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            if #available(iOS 16.0, *) {
                NavigationStack {
                    OnboardingView()
                        .navigationBarHidden(true)
                }
            } else {
                NavigationView {
                    OnboardingView()
                        .navigationBarHidden(true)
                }
            }
        }
    }
}

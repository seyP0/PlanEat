//
//  PlanEatApp.swift
//  PlanEat
//
//  Created by Se Yeon Bark on 2025-06-01.
//

import SwiftUI
import Firebase

@main
struct PlanEatApp: App {
    @StateObject var session = SessionManager()

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            LoadingPG()
                .environmentObject(session)
        }
    }
}

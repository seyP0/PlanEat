//
//  ContentView.swift
//  PlanEat
//
//

import SwiftUI

struct LoadingPG: View {
    @State private var isActive = false
    
    var body: some View {
        if isActive {
            Home() // <- This is the actual home screen you'll build next
        } else {
            VStack {
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                
            
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

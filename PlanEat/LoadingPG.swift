//
//  ContentView.swift
//  PlanEat
//
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame(width:100, height:500 )
                .imageScale(.large)
                .position(x: 180, y: 335)
          
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

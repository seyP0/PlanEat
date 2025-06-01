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
                .frame(width:350, height:500 )
                .imageScale(.large)
                .position(x: 190, y: 335)
          
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

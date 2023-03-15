//
//  ContentView.swift
//  Example
//
//  Created by yaochenfeng on 2023/3/10.
//

import SwiftUI
import UIKit
struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()

    }
}

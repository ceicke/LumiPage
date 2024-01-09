//
//  ContentView.swift
//  LumiPage
//
//  Created by Christoph Eicke on 08.01.24.
//

import SwiftUI

struct ContentView: View {
    
    // This let's you turn on debugging
    private let debug: Bool = false
    
    // Define the list of colors
    private let colors: [Color] = [.yellow, .red, .green, .blue]
    
    @AppStorage("currentColorIndex") private var currentColorIndex: Int = 0
    
    @State private var brightness: CGFloat = UserDefaults.standard.value(forKey: "brightness") as? CGFloat ?? 0.5
    @State private var brightnessWhenEntering: CGFloat = 0.5
    
    var body: some View {
        VStack {
            // Set the background color based on the current index
            colors[currentColorIndex]
                .edgesIgnoringSafeArea(.all)
            Image(systemName: "book")
                .imageScale(.large)
                .foregroundStyle(Color.white)
            Text("Enjoy.")
                .foregroundStyle(Color.white)
            if(debug) {
                Text("\(String(format: "%.2f", brightness))")
                    .foregroundStyle(Color.white)
            }
        }
        .padding()
        .background(colors[currentColorIndex])
        .onTapGesture {
            // Update the color index on tap
            currentColorIndex = (currentColorIndex + 1) % colors.count
        }
        .gesture(
           DragGesture()
           .onChanged { value in
               // Adjust brightness based on swipe direction
               let delta = value.translation.height / 10000.0
               brightness = max(0.0, min(1.0, brightness - delta))
               UIScreen.main.brightness = brightness
           }
        )
        .onAppear {
            // Set the initial currentColorIndex value when the app appears
            currentColorIndex = currentColorIndex
            // Disable the idle timer when the view appears
            UIApplication.shared.isIdleTimerDisabled = true
            // Save initial brightness
            brightnessWhenEntering = UIScreen.main.brightness
        }
        .onDisappear {
            // Save the currentColorIndex value when the app disappears
            UserDefaults.standard.set(currentColorIndex, forKey: "currentColorIndex")
            // Re-enable the idle timer when the view disappears
            UIApplication.shared.isIdleTimerDisabled = false
            // Restore initial brightness
            UIScreen.main.brightness = brightnessWhenEntering
        }
        
    }
}

#Preview {
    ContentView()
}

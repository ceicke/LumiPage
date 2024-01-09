//
//  ContentView.swift
//  LumiPage
//
//  Created by Christoph Eicke on 08.01.24.
//

import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Prevent the device from sleeping
        UIApplication.shared.isIdleTimerDisabled = true
        return true
    }
}

struct ContentView: View {
    // Define the list of colors
    private let colors: [Color] = [.yellow, .red, .green, .blue]
    
    private let debug: Bool = false
    
    @AppStorage("currentColorIndex") private var currentColorIndex: Int = 0
    @AppStorage("brightness") private var brightness: Double = 0.5
    
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
            // Set the initial brightness and currentColorIndex value when the app appears
            UIScreen.main.brightness = brightness
            currentColorIndex = currentColorIndex
        }
        .onDisappear {
            // Save the brightness and currentColorIndex values when the app disappears
            UserDefaults.standard.set(brightness, forKey: "brightness")
            UserDefaults.standard.set(currentColorIndex, forKey: "currentColorIndex")
        }
        
    }
}

#Preview {
    ContentView()
}

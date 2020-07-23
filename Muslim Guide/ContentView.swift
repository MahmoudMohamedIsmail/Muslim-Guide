//
//  ContentView.swift
//  Muslim Guide
//
//  Created by macboock pro on 7/22/20.
//  Copyright © 2020 macboock pro. All rights reserved.
//

import SwiftUI

struct ContentView: View {    @State private var selection = 0
        init() {
          
        }
        var body: some View {
            TabView(selection: $selection){
                PrayerTimesView()
                    .tabItem {
                        VStack {
                            Image(systemName: "clock").font(.title)
                            Text("Prayer Time")
                        }
                    }
                .tag(0)
                            
    //            Text("Second View")
    //                .font(.title)
    //                .tabItem {
    //                    VStack {
    //                        Image("second")
    //                        Text("Second")
    //                    }
    //                }
    //                .tag(1)
            }
        }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

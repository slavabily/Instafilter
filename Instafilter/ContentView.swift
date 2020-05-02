//
//  ContentView.swift
//  Instafilter
//
//  Created by slava bily on 29/4/20.
//  Copyright © 2020 slava bily. All rights reserved.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    
    @State private var image: Image?
    @State private var filterIntensity = 0.5
     
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color.secondary)
                    if image != nil {
                        image?
                            .resizable()
                            .scaledToFit()
                    } else {
                        Text("Tap to select a picture")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                 }
                .onTapGesture {
                    // select the image
                }
                
                HStack {
                    Text("Intensity")
                    
                    Slider(value: $filterIntensity)
                }
                .padding(.vertical)
                
                HStack {
                    Button("Change filter") {
                        // change filter
                    }
                    
                    Spacer()
                    
                    Button("Save") {
                        // save picture
                    }
                }
            }
            .padding([.horizontal, .bottom])
            
            .navigationBarTitle("Instafilter")
        }
        
    }
    
 
}

 
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

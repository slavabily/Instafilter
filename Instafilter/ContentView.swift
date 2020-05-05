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
    
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var processedImage: UIImage?
    
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    let context = CIContext()
    
    @State private var showingFilterSheet = false
    @State private var showingSavingAlert = false
    
    @State private var filterName = "Change filter"
 
    var body: some View {
        
        let intensity = Binding<Double>(
            get: {
                self.filterIntensity
            },
            set: {
                self.filterIntensity = $0
                self.applyProccessing()
            }
        )
        
        return NavigationView {
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
                    self.showingImagePicker = true
                }
                
                HStack {
                    Text("Intensity")
                    
                    Slider(value: intensity)
                }
                .padding(.vertical)
                
                HStack {
                    Button(filterName) {
                        self.showingFilterSheet = true
                    }
                    
                    Spacer()
                    
                    Button("Save") {
                        guard let processedImage = self.processedImage else {
                            
                            self.showingSavingAlert = true
                           
                            return
                        }
                        
                        let imageSaver = ImageSaver()
                        
                        imageSaver.successHandler = {
                            print("Success!")
                        }
                        imageSaver.errorHandler = { error in
                            print("Oops: \(error.localizedDescription)")
                        }
                        imageSaver.writeToPhotoAlbum(image: processedImage)
                    }
                    .alert(isPresented: $showingSavingAlert) {
                         Alert(title: Text("Error"), message: Text("There is no image to save!"), dismissButton: .default(Text("OK")))
                    }
                }
            }
            .padding([.horizontal, .bottom])
            .navigationBarTitle("Instafilter")
                
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: self.$inputImage)
            }
            
            .actionSheet(isPresented: $showingFilterSheet) {
                ActionSheet(title: Text("Select a filter"), buttons: [
                    .default(Text("Christalize"), action: {
                        self.setFilter(CIFilter.crystallize())
                        self.filterName = "Christalize"
                    }),
                    .default(Text("Edges"), action: {
                        self.setFilter(CIFilter.edges())
                        self.filterName = "Edges"
                    }),
                    .default(Text("Gaussian Blur"), action: {
                        self.setFilter(CIFilter.gaussianBlur())
                        self.filterName = "Gaussian Blur"
                    }),
                    .default(Text("Pixellate"), action: {
                        self.setFilter(CIFilter.pixellate())
                        self.filterName = "Pixellate"
                    }),
                    .default(Text("Sepia Tone"), action: {
                        self.setFilter(CIFilter.sepiaTone())
                        self.filterName = "Sepia Tone"
                    }),
                    .default(Text("Unsharp Mask"), action: {
                        self.setFilter(CIFilter.unsharpMask())
                        self.filterName = "Unsharp Mask"
                    }),
                    .default(Text("Vignette"), action: {
                        self.setFilter(CIFilter.vignette())
                        self.filterName = "Vignette"
                    }),
                    .cancel()
                ])
            }
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        
        let beginImage = CIImage(image: inputImage)
        
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        applyProccessing()
    }
    
    func applyProccessing() {
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
        }
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(filterIntensity * 200, forKey: kCIInputRadiusKey)
        }
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(filterIntensity * 10, forKey: kCIInputScaleKey)
        }
        
        guard let outputImage = currentFilter.outputImage else { return }
        
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg)
            
            image = Image(uiImage: uiImage)
            
            processedImage = uiImage
        }
    }
    
    func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        
        loadImage()
    }
    
 
}

 
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = AudioViewModel()
    
    var body: some View {
            
            VStack {
                // File Pickers
                AudioPickerView(viewModel: viewModel, isOriginal: true)
                AudioPickerView(viewModel: viewModel, isOriginal: false)
                
                // Compare Button
                if viewModel.originalAudio != nil && viewModel.secondAudio != nil {
                    Button("Compare") {
                        viewModel.extractWaveform(from: viewModel.originalAudio!.url, isOriginal: true)
                        viewModel.extractWaveform(from: viewModel.secondAudio!.url, isOriginal: false)
                    }
                    .padding()
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                
                // Display Comparison Graph
                if !viewModel.originalWaveform.isEmpty && !viewModel.secondWaveform.isEmpty {
                    WaveformComparisonView(viewModel: viewModel)
                }
            }
            .padding()
        }
    }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

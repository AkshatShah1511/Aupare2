import SwiftUI
import UniformTypeIdentifiers

struct AudioPickerView: View {
    @ObservedObject var viewModel: AudioViewModel
    var isOriginal: Bool
    @State private var showFilePicker = false

    var body: some View {
        VStack {
            Button(isOriginal ? "Pick Original Audio" : "Pick Second Audio") {
                showFilePicker = true
            }
            .padding()
            .background(isOriginal ? Color.green : Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .fileImporter(
            isPresented: $showFilePicker,
            allowedContentTypes: [.mp3, .wav, .mpeg4Audio],
            allowsMultipleSelection: false
        ) { result in
            do {
                if let selectedFile = try result.get().first {
                    viewModel.selectAudioFile(url: selectedFile, isOriginal: isOriginal)
                }
            } catch {
                print("❌ Error selecting file: \(error.localizedDescription)")
            }
        }
    }
}

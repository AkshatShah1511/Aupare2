import SwiftUI
import AVFoundation

class AudioViewModel: ObservableObject {
    @Published var originalAudio: AudioFile?
    @Published var secondAudio: AudioFile?
    @Published var originalWaveform: [Float] = []
    @Published var secondWaveform: [Float] = []

    func selectAudioFile(url: URL, isOriginal: Bool) {
        DispatchQueue.main.async {
            if isOriginal {
                self.originalAudio = AudioFile(url: url)
            } else {
                self.secondAudio = AudioFile(url: url)
            }
        }
    }

    func extractWaveform(from url: URL, isOriginal: Bool) {
        let localURL = copyToDocumentsDirectory(url)

        do {
            let audioFile = try AVAudioFile(forReading: localURL)
            let fileFormat = audioFile.processingFormat
            let frameCount = AVAudioFrameCount(audioFile.length)
            let buffer = AVAudioPCMBuffer(pcmFormat: fileFormat, frameCapacity: frameCount)!
            try audioFile.read(into: buffer)

            guard let floatChannelData = buffer.floatChannelData else {
                print("❌ No waveform data extracted")
                return
            }

            let samples = Array(UnsafeBufferPointer(start: floatChannelData[0], count: Int(frameCount)))
            let downsampled = samples.enumerated().filter { $0.offset % 100 == 0 }.map { abs($0.element) }
            DispatchQueue.main.async {
                if isOriginal {
                    self.originalWaveform = downsampled
                    print("✅ Extracted \(downsampled.count) samples for ORIGINAL audio")
                } else {
                    self.secondWaveform = downsampled
                    print("✅ Extracted \(downsampled.count) samples for SECOND audio")
                }
            }
        } catch {
            print("❌ Error extracting waveform: \(error.localizedDescription)")
        }
    }
    private func copyToDocumentsDirectory(_ originalURL: URL) -> URL {
        let fileManager = FileManager.default
        let documentsDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationURL = documentsDir.appendingPathComponent(originalURL.lastPathComponent)

        do {
            if !originalURL.startAccessingSecurityScopedResource() {
                print("❌ Could not access file: \(originalURL.path)")
                return destinationURL
            }

            if fileManager.fileExists(atPath: destinationURL.path) {
                try fileManager.removeItem(at: destinationURL)
            }

            try fileManager.copyItem(at: originalURL, to: destinationURL)
            print("✅ Moved file to: \(destinationURL.path)")

            originalURL.stopAccessingSecurityScopedResource()
        } catch {
            print("❌ Error copying file: \(error.localizedDescription)")
        }

        return destinationURL
    }
}

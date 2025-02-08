import SwiftUI
import Charts

struct WaveformComparisonView: View {
    @ObservedObject var viewModel: AudioViewModel
    @State private var zoomScale: CGFloat = 1.0  // ✅ Controls zoom

    var body: some View {
        TabView {
            // Original Audio Tab
            VStack {
                Text("Original Audio Waveform")
                    .font(.headline)
                    .foregroundColor(.green)
                
                // ✅ Show uploaded file name
                if let originalFile = viewModel.originalAudio {
                    Text("Uploaded File: \(originalFile.name)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                if viewModel.originalWaveform.isEmpty {
                    Text("No waveform data")
                        .foregroundColor(.gray)
                } else {
                    ScrollView(.horizontal) {
                        Chart {
                            ForEach(viewModel.originalWaveform.indices, id: \.self) { index in
                                if index % 200 == 0 {  // ✅ Reduce x-axis data points
                                    LineMark(
                                        x: .value("Time (ms)", index * 10),  // ✅ Convert samples to milliseconds
                                        y: .value("Amplitude (dB)", viewModel.originalWaveform[index])
                                    )
                                    .foregroundStyle(.green)
                                    .interpolationMethod(.catmullRom)
                                    .lineStyle(StrokeStyle(lineWidth: 0.7))
                                }
                            }
                        }
                        .chartXAxisLabel() {
                            Text("Time (ms)")
                        }
                        .chartYAxisLabel() {
                            Text("Amplitude(A)")
                        }
                        .chartXAxis {
                            
                            AxisMarks(position: .bottom, values: .automatic) {
                                AxisValueLabel()
                            }
                        }
                        .chartYAxis {
                            AxisMarks(position: .leading, values: .automatic) {
                                AxisValueLabel()
                            }
                        }
                        .frame(height: 300)
                        .frame(width: max(UIScreen.main.bounds.width, CGFloat(viewModel.originalWaveform.count / 30)))  // ✅ Auto-resize width
                        .padding()
                    }
                }
            }
            .tabItem {
                Label("Original", systemImage: "waveform.path.ecg")
            }

            // Second Audio Tab
            VStack {
                Text("Second Audio Waveform")
                    .font(.headline)
                    .foregroundColor(.blue)
                
                // ✅ Show uploaded file name
                if let secondFile = viewModel.secondAudio {
                    Text("Uploaded File: \(secondFile.name)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                if viewModel.secondWaveform.isEmpty {
                    Text("No waveform data")
                        .foregroundColor(.gray)
                } else {
                    ScrollView(.horizontal) {
                        Chart {
                            ForEach(viewModel.secondWaveform.indices, id: \.self) { index in
                                if index % 200 == 0 {
                                    LineMark(
                                        x: .value("Time (ms)", index * 10),
                                        y: .value("Amplitude (dB)", viewModel.secondWaveform[index])
                                    )
                                    .foregroundStyle(.blue)
                                    .interpolationMethod(.catmullRom)
                                    .lineStyle(StrokeStyle(lineWidth: 0.7))
                                }
                            }
                        }
                        .chartXAxisLabel() {
                            Text("Time (ms)")
                        }
                        .chartYAxisLabel() {
                            Text("Amplitude(A)")
                        }
                        .chartXAxis {
                            AxisMarks(position: .bottom, values: .automatic) {
                                AxisValueLabel()
                            }
                        }
                        .chartYAxis {
                            AxisMarks(position: .leading, values: .automatic) {
                                AxisValueLabel()
                            }
                        }
                        .frame(height: 300)
                        .frame(width: max(UIScreen.main.bounds.width, CGFloat(viewModel.secondWaveform.count / 30)))  // ✅ Auto-resize width
                        .padding()
                    }
                }
            }
            .tabItem {
                Label("Second", systemImage: "waveform")
            }
        }
        .tabViewStyle(.automatic)
    }
}

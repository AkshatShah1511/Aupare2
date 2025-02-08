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

                if viewModel.originalWaveform.isEmpty {
                    Text("No waveform data")
                        .foregroundColor(.gray)
                } else {
                    ScrollView(.horizontal) {  // ✅ Expand graph horizontally
                        Chart {
                            ForEach(viewModel.originalWaveform.indices, id: \.self) { index in
                                if index % 100 == 0 {  // ✅ Show x-axis in hundreds
                                    LineMark(
                                        x: .value("Time (samples)", index),
                                        y: .value("Amplitude", viewModel.originalWaveform[index])
                                    )
                                    .foregroundStyle(.green)
                                    .interpolationMethod(.catmullRom)
                                    .lineStyle(StrokeStyle(lineWidth: 0.5))  // ✅ Reduce line thickness
                                }
                            }
                        }
                        .chartXAxis {
                            AxisMarks()
                        }
                        .chartYAxis {
                            AxisMarks()
                        }
                        .frame(height: 300)
                        .frame(width: 800)
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

                if viewModel.secondWaveform.isEmpty {
                    Text("No waveform data")
                        .foregroundColor(.gray)
                } else {
                    ScrollView(.horizontal) {
                        Chart {
                            ForEach(viewModel.secondWaveform.indices, id: \.self) { index in
                                if index % 100 == 0 {  // ✅ Show x-axis in hundreds
                                    LineMark(
                                        x: .value("Time (samples)", index),
                                        y: .value("Amplitude", viewModel.secondWaveform[index])
                                    )
                                    .foregroundStyle(.blue)
                                    .interpolationMethod(.catmullRom)
                                    .lineStyle(StrokeStyle(lineWidth: 0.5))
                                }
                            }
                        }
                        .chartXAxis {
                            AxisMarks()
                        }
                        .chartYAxis {
                            AxisMarks()
                        }
                        .frame(height: 300)
                        .frame(width:800)
                        .padding()
                    }
                }
            }
            .tabItem {
                Label("Second", systemImage: "waveform")
            }
        }
        .tabViewStyle(.automatic)  // ✅ Make the TabView vertical
    }
}

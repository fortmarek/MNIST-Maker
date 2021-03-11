import SwiftUI
import Vision
import PencilKit
import ComposableArchitecture

struct MNISTMakerView: View {
    @State var canvasView: PKCanvasView = .init()
    
    var body: some View {
        VStack {
            ZStack {
                CanvasView(
                    canvasView: $canvasView
                )
                .border(Color.white)
                .padding()
            }
            HStack(alignment: .top) {
                Button("Export") {
                    export()
                    canvasView.drawing = .init()
                }
            }
        }
    }
    
    // MARK: - Helpers
    
    private func export() {
        canvasView.drawing.image(
            from: canvasView.drawing.bounds,
            scale: 1.0
        )
        .modelImage()
        .map(savePNG)
    }
    
    private func savePNG(_ image: UIImage) {
        guard
            let pngData = image.pngData(),
            let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                .first?
                .appendingPathComponent("\(UUID().uuidString).png")
        else { return }
        try? pngData.write(to: path)
    }
}

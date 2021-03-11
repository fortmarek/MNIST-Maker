import SwiftUI
import PencilKit

struct MNISTMakerView: View {
    @State var canvasView: PKCanvasView = .init()
    @State var size: Int? = 28
    
    var body: some View {
        VStack {
            ZStack {
                CanvasView(
                    canvasView: $canvasView
                )
                .border(Color.white)
                .padding()
            }
            HStack(alignment: .center) {
                Button("Export") {
                    export()
                    canvasView.drawing = .init()
                }
                Text("Size " + (size.map(String.init) ?? "") + " x")
                TextEditor(
                    text: Binding(
                        get: { size.map(String.init) ?? "" },
                        set: { size = Int($0) }
                    )
                )
                .multilineTextAlignment(.center)
                .lineLimit(1)
                .border(Color.white)
                .frame(width: 50, height: 30)
            }
        }
    }
    
    // MARK: - Helpers
    
    private func export() {
        canvasView.drawing.image(
            from: canvasView.drawing.bounds,
            scale: 1.0
        )
        .modelImage(
            with: size.map { CGSize(width: $0, height: $0) } ?? CGSize(width: 28, height: 28)
        )
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

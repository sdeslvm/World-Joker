import SwiftUI
import Foundation

struct WorldJokerEntryScreen: View {
    @StateObject private var loader: WorldJokerWebLoader

    init(loader: WorldJokerWebLoader) {
        _loader = StateObject(wrappedValue: loader)
    }

    var body: some View {
        ZStack {
            WorldJokerWebViewBox(loader: loader)
                .opacity(loader.state == .finished ? 1 : 0.5)
            switch loader.state {
            case .progressing(let percent):
                WorldJokerProgressIndicator(value: percent)
            case .failure(let err):
                WorldJokerErrorIndicator(err: err) // err теперь String
            case .noConnection:
                WorldJokerOfflineIndicator()
            default:
                EmptyView()
            }
        }
    }
}

private struct WorldJokerProgressIndicator: View {
    let value: Double
    var body: some View {
        GeometryReader { geo in
            WorldJokerLoadingOverlay(progress: value)
                .frame(width: geo.size.width, height: geo.size.height)
                .background(Color.black)
        }
    }
}

private struct WorldJokerErrorIndicator: View {
    let err: String // было Error, стало String
    var body: some View {
        Text("Ошибка: \(err)").foregroundColor(.red)
    }
}

private struct WorldJokerOfflineIndicator: View {
    var body: some View {
        Text("Нет соединения").foregroundColor(.gray)
    }
}

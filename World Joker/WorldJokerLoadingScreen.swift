import SwiftUI

// MARK: - Protocols for extensibility

protocol WorldJokerProgressDisplayable {
    var progressPercentage: Int { get }
}

protocol WorldJokerBackgroundProviding {
    associatedtype BackgroundContent: View
    func makeBackground() -> BackgroundContent
}

// MARK: - Enhanced loading structure

struct WorldJokerLoadingOverlay<Background: View>: View, WorldJokerProgressDisplayable {
    let progress: Double
    let backgroundView: Background
    
    var progressPercentage: Int { Int(progress * 100) }
    
    init(progress: Double, @ViewBuilder background: () -> Background) {
        self.progress = progress
        self.backgroundView = background()
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                backgroundView
                content(in: geo)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }
    
    private func content(in geometry: GeometryProxy) -> some View {
        let isLandscape = geometry.size.width > geometry.size.height
        
        return Group {
            if isLandscape {
                horizontalLayout(in: geometry)
            } else {
                verticalLayout(in: geometry)
            }
        }
    }
    
    private func verticalLayout(in geometry: GeometryProxy) -> some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Main title
            VStack(spacing: 8) {
                Text("WORLD JOKER")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: Color(hex: "#00FF88").opacity(0.8), radius: 10, x: 0, y: 0)
                
//                Text("GAMING EXPERIENCE")
//                    .font(.system(size: 16, weight: .medium, design: .rounded))
//                    .foregroundColor(Color(hex: "#00FF88"))
//                    .tracking(2)
            }
            
            // Loading section
            VStack(spacing: 20) {
                Text("Loading... \(progressPercentage)%")
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(radius: 2)
                
                WorldJokerProgressBar(value: progress)
                    .frame(width: geometry.size.width * 0.7, height: 12)
                
                // Animated dots
                HStack(spacing: 8) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(Color(hex: "#00FF88"))
                            .frame(width: 8, height: 8)
                            .scaleEffect(progress > Double(index) * 0.3 ? 1.2 : 0.8)
                            .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true).delay(Double(index) * 0.2), value: progress)
                    }
                }
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.black.opacity(0.3))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color(hex: "#00FF88").opacity(0.5), lineWidth: 1)
                    )
            )
            
            Spacer()
            
            // Footer text
            Text("Preparing your adventure...")
                .font(.system(size: 14, weight: .regular, design: .rounded))
                .foregroundColor(Color(hex: "#00FF88").opacity(0.7))
                .padding(.bottom, 40)
        }
        .padding(.horizontal, 20)
    }
    
    private func horizontalLayout(in geometry: GeometryProxy) -> some View {
        HStack {
            Spacer()
            
            VStack(spacing: 30) {
                // Main title
                VStack(spacing: 8) {
                    Text("WORLD JOKER")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: Color(hex: "#00FF88").opacity(0.8), radius: 10, x: 0, y: 0)
                    
//                    Text("GAMING EXPERIENCE")
//                        .font(.system(size: 14, weight: .medium, design: .rounded))
//                        .foregroundColor(Color(hex: "#00FF88"))
//                        .tracking(2)
                }
                
                // Loading section
                VStack(spacing: 16) {
                    Text("Loading... \(progressPercentage)%")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(radius: 2)
                    
                    WorldJokerProgressBar(value: progress)
                        .frame(width: geometry.size.width * 0.3, height: 10)
                    
                    // Animated dots
                    HStack(spacing: 6) {
                        ForEach(0..<3) { index in
                            Circle()
                                .fill(Color(hex: "#00FF88"))
                                .frame(width: 6, height: 6)
                                .scaleEffect(progress > Double(index) * 0.3 ? 1.2 : 0.8)
                                .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true).delay(Double(index) * 0.2), value: progress)
                        }
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.black.opacity(0.3))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color(hex: "#00FF88").opacity(0.5), lineWidth: 1)
                        )
                )
                
                // Footer text
                Text("Preparing your adventure...")
                    .font(.system(size: 12, weight: .regular, design: .rounded))
                    .foregroundColor(Color(hex: "#00FF88").opacity(0.7))
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Background views

extension WorldJokerLoadingOverlay where Background == WorldJokerBackground {
    init(progress: Double) {
        self.init(progress: progress) { WorldJokerBackground() }
    }
}

struct WorldJokerBackground: View, WorldJokerBackgroundProviding {
    func makeBackground() -> some View {
        ZStack {
            // Gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "#0A0A0A"),
                    Color(hex: "#1A1A1A"),
                    Color(hex: "#0A0A0A")
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Animated background elements
            GeometryReader { geometry in
                ZStack {
                    // Floating circles
                    ForEach(0..<6) { index in
                        Circle()
                            .fill(Color(hex: "#00FF88").opacity(0.1))
                            .frame(width: CGFloat.random(in: 50...150))
                            .position(
                                x: CGFloat.random(in: 0...geometry.size.width),
                                y: CGFloat.random(in: 0...geometry.size.height)
                            )
                            .animation(
                                .easeInOut(duration: Double.random(in: 3...6))
                                .repeatForever(autoreverses: true),
                                value: UUID()
                            )
                    }
                }
            }
        }
    }
    
    var body: some View {
        makeBackground()
    }
}

// MARK: - Animated progress bar

struct WorldJokerProgressBar: View {
    let value: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background track
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.white.opacity(0.1))
                    .frame(height: geometry.size.height)
                
                // Progress track
                RoundedRectangle(cornerRadius: 6)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(hex: "#00FF88"),
                                Color(hex: "#00CC66"),
                                Color(hex: "#00FF88")
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: CGFloat(value) * geometry.size.width, height: geometry.size.height)
                    .animation(.easeInOut(duration: 0.3), value: value)
                    .overlay(
                        // Shimmer effect
                        RoundedRectangle(cornerRadius: 6)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.clear,
                                        Color.white.opacity(0.3),
                                        Color.clear
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: CGFloat(value) * geometry.size.width, height: geometry.size.height)
                            .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: false), value: value)
                    )
            }
        }
    }
}

// MARK: - Preview

#Preview("Vertical") {
    WorldJokerLoadingOverlay(progress: 0.65)
}

#Preview("Horizontal") {
    WorldJokerLoadingOverlay(progress: 0.65)
        .previewInterfaceOrientation(.landscapeRight)
}


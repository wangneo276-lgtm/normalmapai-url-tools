// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "NormalMapAiUrlTools",
    products: [
        .library(name: "NormalMapAiUrlTools", targets: ["NormalMapAiUrlTools"]),
    ],
    targets: [
        .target(name: "NormalMapAiUrlTools", path: "swift/Sources/NormalMapAiUrlTools"),
        .executableTarget(name: "normalmapai-url-check", dependencies: ["NormalMapAiUrlTools"], path: "swift/Check"),
    ]
)

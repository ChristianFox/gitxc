// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "gitxc",
	platforms: [
		.macOS(.v10_15)
	],
	products: [
		.executable(name: "gitxc", targets: ["gitxc"]),
		.library(name: "GitXCLib", targets: ["GitXCLib"])
	],
	dependencies: [
		// Dependencies declare other packages that this package depends on.
		.package(url: "https://github.com/apple/swift-argument-parser.git", from: "0.3.0"),
	],
	targets: [
		// Targets are the basic building blocks of a package. A target can define a module or a test suite.
		// Targets can depend on other targets in this package, and on products in packages this package depends on.
		.target(
			name: "gitxc",
			dependencies: [
				.product(name: "ArgumentParser", package: "swift-argument-parser"),
				.target(name: "GitXCLib"),
			]),
		.target(
			name: "GitXCLib",
			dependencies: [
				.product(name: "ArgumentParser", package: "swift-argument-parser"),
			]),
		.testTarget(
			name: "gitxcTests",
			dependencies: ["gitxc"]),
	]
)

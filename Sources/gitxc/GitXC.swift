import Foundation
import ArgumentParser
import GitXCLib

/// A tool for performing Git tasks with additional actions
struct GitXC: ParsableCommand {

	static let configuration = CommandConfiguration(
		abstract: "A tool that performs git merge or pull but additionally checks for and resolves conflicts in an Xcode project's info.plist files, specifically conflicts with the CFBundleVersion value.",
		subcommands: [Merge.self, Pull.self]
	)
}


import Foundation

public enum PlistConflictResult {
	case noConflict
	case manualResolutionNeeded
	case resolved(dictionary: [String: Any], url: URL)
}

public enum PlistConflictError: Error {
	case markersNotFound
	case invalidPlist
}

public protocol InfoPlistResolverInterface {
	
	func resolveBundleVersionConflict(_ text: String) throws -> PlistConflictResult
}

/// Resolves CFBundleVersion conflicts in Info.plist files
public struct InfoPlistResolver: InfoPlistResolverInterface {
	
	// # Markers
	let headMarker: String = "<<<<<<< HEAD\n"
	let dividerMarker: String = "=======\n"
	let otherMarker: String = ">>>>>>> "

	public init() {}
	
	public func resolveBundleVersionConflict(_ text: String) throws -> PlistConflictResult {
		
		guard text.contains(headMarker) else {
			return .noConflict
		}
		guard text.occurances(of: headMarker) == 1 else {
			print("text.occurances(of: headMarker) != 1")
			return .manualResolutionNeeded
		}
		
		// # Ranges
		guard let headMarkerRange = text.range(of: headMarker),
			  let dividerMarkerRange = text.range(of: dividerMarker),
			  let otherMarkerRange = text.range(of: otherMarker),
			  let afterConflictStartRange = text.range(of: "<", options: .literal, range: otherMarkerRange.upperBound..<text.endIndex, locale: nil) else {
			throw PlistConflictError.markersNotFound
		}
		
		let fullOtherMarkerRange = otherMarkerRange.lowerBound..<afterConflictStartRange.lowerBound
		let sourceBuildRange: Range = headMarkerRange.upperBound..<dividerMarkerRange.lowerBound
		let destBuildRange: Range = dividerMarkerRange.upperBound..<fullOtherMarkerRange.lowerBound
		
		// # Text Components
		let beforeMarkersText: Substring = text.prefix(upTo: headMarkerRange.lowerBound)
		let afterMarkersText: Substring = text.suffix(from: fullOtherMarkerRange.upperBound)
		let sourceBuildNumText: Substring = text[sourceBuildRange]
		let destBuildNumText: Substring = text[destBuildRange]
		
		// Check conflict is with CFBundleVersion
		guard beforeMarkersText.hasSuffix("<key>CFBundleVersion</key>\n") else {
			print("beforeMarkersText does not have correct suffix: \(beforeMarkersText)")
			return .manualResolutionNeeded
		}
		
		// Check conflict does not contain more than one string value (not just CFBundleVersion change)
		guard String(sourceBuildNumText).occurances(of: "string>") == 2
				&& !String(sourceBuildNumText).contains("key") else {
			print("sourceBuildNumText does not have correct text: \(sourceBuildNumText)")
			return .manualResolutionNeeded
		}
		
		// # Full Text
		let sourceText: String = "\(beforeMarkersText)\(sourceBuildNumText)\t\(afterMarkersText)"
		let destText: String = "\(beforeMarkersText)\(destBuildNumText)\t\(afterMarkersText)"
		
		// # Write Temp Files
		let dirPath: String = NSTemporaryDirectory()
		let sourceURL: URL = URL(fileURLWithPath:"\(dirPath)/tmp_source.plist")
		let destURL: URL = URL(fileURLWithPath:"\(dirPath)/tmp_dest.plist")
		try sourceText.write(to: sourceURL, atomically: false, encoding: .utf8)
		try destText.write(to: destURL, atomically: false, encoding: .utf8)
				
		// # Read Temp Files
		guard let sourceDict = try? PlistHelper.plistDictionaryFromURL(sourceURL),
			  let destDict = try? PlistHelper.plistDictionaryFromURL(destURL),
			  let sourceBuildNumString: String = sourceDict["CFBundleVersion"] as? String,
			  let destBuildNumString: String = destDict["CFBundleVersion"] as? String,
			  let sourceBuildNum: Int = Int(sourceBuildNumString),
			  let destBuildNum: Int = Int(destBuildNumString) else {
			throw PlistConflictError.invalidPlist
		}
		
		// # Return dictionary containing highest build number
		if sourceBuildNum >= destBuildNum {
			return .resolved(dictionary: sourceDict, url: sourceURL)
		} else {
			return .resolved(dictionary: destDict, url: destURL)
		}
	}

}

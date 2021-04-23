
import Foundation
@testable import GitXCLib

struct MockInfoPlistResolver: InfoPlistResolverInterface {
	
	//------------------------------------
	// MARK: Control & Response
	//------------------------------------
	var resultReturnValue: PlistConflictResult?
	
	//------------------------------------
	// MARK: InfoPlistResolverInterface
	//------------------------------------
	public func resolveBundleVersionConflict(_ text: String) throws -> PlistConflictResult {
		resultReturnValue!
	}
}

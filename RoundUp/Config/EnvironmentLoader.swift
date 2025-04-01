import Foundation

class EnvironmentLoader {
    static let shared = EnvironmentLoader()
    private var environment: [String: String] = [:]
    
    private init() {
        loadEnvironment()
    }
    
    private func loadEnvironment() {
        guard let path = Bundle.main.path(forResource: ".env", ofType: nil) else {
            print("Warning: .env file not found")
            return
        }
        
        do {
            let content = try String(contentsOfFile: path, encoding: .utf8)
            let lines = content.components(separatedBy: .newlines)
            
            for line in lines {
                let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
                if trimmedLine.isEmpty || trimmedLine.hasPrefix("#") {
                    continue
                }
                
                let parts = trimmedLine.split(separator: "=", maxSplits: 1)
                if parts.count == 2 {
                    let key = String(parts[0]).trimmingCharacters(in: .whitespaces)
                    let value = String(parts[1]).trimmingCharacters(in: .whitespaces)
                    environment[key] = value
                }
            }
        } catch {
            print("Error loading .env file: \(error)")
        }
    }
    
    func get(_ key: String) -> String? {
        return environment[key]
    }
} 
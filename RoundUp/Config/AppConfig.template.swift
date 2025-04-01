import Foundation

struct AppConfig {
    // Firebase Configuration
    static let firebaseConfig: [String: Any] = [
        "apiKey": "FIREBASE_API_KEY_HERE",
        "authDomain": "FIREBASE_AUTH_DOMAIN_HERE",
        "projectId": "FIREBASE_PROJECT_ID_HERE",
        "storageBucket": "FIREBASE_STORAGE_BUCKET_HERE",
        "messagingSenderId": "FIREBASE_MESSAGING_SENDER_ID_HERE",
        "appId": "FIREBASE_APP_ID_HERE"
    ]
    
    // Supabase Configuration
    static let supabaseURL = "SUPABASE_URL_HERE"
    static let supabaseAnonKey = "SUPABASE_ANON_KEY_HERE"
    
    // Other API Keys
    static let stripePublishableKey = "STRIPE_PUBLISHABLE_KEY_HERE"
    static let stripeSecretKey = "STRIPE_SECRET_KEY_HERE"
    
    // Feature Flags
    static let enableAnalytics = true
    static let enableCrashlytics = true
    static let enablePerformanceMonitoring = true
    
    // App Settings
    static let maxGroupSize = 50
    static let maxMessageLength = 1000
    static let maxProfileImageSize = 5 * 1024 * 1024 // 5MB
} 
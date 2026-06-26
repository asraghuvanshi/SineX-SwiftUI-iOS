//
//  SineX_SwiftUI_iOSApp.swift
//  SineX-SwiftUI-iOS
//
//  Created by iOS Developer on 21/06/26.
//

import SwiftUI

@main
struct SineX_SwiftUI_iOSApp: App {
    
    @State private var router = AppRouter()
    
    var body: some Scene {
        WindowGroup {
            RootContainerView()
                .environment(router)
        }
    }
}

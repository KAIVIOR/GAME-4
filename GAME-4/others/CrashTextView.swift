


import SwiftUI
struct CrashTextView: View {
    func buttonTap() {
        fatalError()
    }
    var body: some View {
        Button(action: buttonTap, label: {
            Text("Crash 吧，App")
                .font(.system(size: 50))
        })
    }
}

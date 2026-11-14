import SwiftUI
import WebKit

@main
struct KeepoApp: App {
    var body: some Scene {
        WindowGroup {
            WebView(url: URL(string: "https://rzk-labs.github.io/baca-bahasa/?ref=ios")!)
                .ignoresSafeArea(.container, edges: .bottom)
                .background(Color(red: 0.95, green: 0.93, blue: 0.90))
        }
    }
}

struct WebView: UIViewRepresentable {
    let url: URL

    func makeCoordinator() -> Coordinator { Coordinator() }

    func makeUIView(context: Context) -> WKWebView {
        let cfg = WKWebViewConfiguration()
        cfg.limitsNavigationsToAppBoundDomains = true   // service worker (offline) butuh app-bound domain
        cfg.allowsInlineMediaPlayback = true
        cfg.mediaTypesRequiringUserActionForPlayback = []
        cfg.websiteDataStore = .default()
        let wv = WKWebView(frame: .zero, configuration: cfg)
        wv.navigationDelegate = context.coordinator
        wv.uiDelegate = context.coordinator
        wv.allowsBackForwardNavigationGestures = false
        wv.scrollView.contentInsetAdjustmentBehavior = .never
        wv.isOpaque = false
        wv.backgroundColor = .clear
        context.coordinator.home = url
        wv.load(URLRequest(url: url, cachePolicy: .useProtocolCachePolicy))
        return wv
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}

    final class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
        var home: URL?

        // Link ke situs lain dibuka di Safari, bukan di dalam app
        func webView(_ webView: WKWebView, decidePolicyFor action: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let u = action.request.url, let h = u.host, h != "rzk-labs.github.io", action.targetFrame?.isMainFrame ?? true,
               u.scheme == "http" || u.scheme == "https" {
                UIApplication.shared.open(u); decisionHandler(.cancel); return
            }
            decisionHandler(.allow)
        }

        func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for action: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
            if let u = action.request.url { UIApplication.shared.open(u) }
            return nil
        }

        // Tanpa internet & belum ada cache: tampilkan pesan + tombol coba lagi
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            let html = """
            <meta name=viewport content='width=device-width,initial-scale=1'>
            <body style='font-family:-apple-system;background:#F2EEE5;color:#351E28;display:flex;flex-direction:column;align-items:center;justify-content:center;height:90vh;text-align:center;padding:24px'>
            <h2>Belum tersambung</h2><p>Buka Keepo sekali saat online. Setelah itu bisa dibaca tanpa internet.</p>
            <button onclick="location.href='\(home?.absoluteString ?? "")'" style='font-size:17px;padding:12px 24px;border-radius:99px;border:0;background:#351E28;color:#fff'>Coba lagi</button></body>
            """
            webView.loadHTMLString(html, baseURL: URL(string: "https://rzk-labs.github.io/"))
        }

        func webView(_ webView: WKWebView, requestMediaCapturePermissionFor origin: WKSecurityOrigin, initiatedByFrame frame: WKFrameInfo, type: WKMediaCaptureType, decisionHandler: @escaping (WKPermissionDecision) -> Void) {
            decisionHandler(origin.host == "rzk-labs.github.io" ? .grant : .prompt)
        }
    }
}

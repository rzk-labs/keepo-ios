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
        if #available(iOS 16.4, *) { wv.isInspectable = true }
        let errJS = WKUserScript(source: "window.__kerr=[];addEventListener('error',e=>__kerr.push(String(e.message)+' @'+e.filename+':'+e.lineno));addEventListener('unhandledrejection',e=>__kerr.push('rej '+String(e.reason)))", injectionTime: .atDocumentStart, forMainFrameOnly: true)
        wv.configuration.userContentController.addUserScript(errJS)
        wv.isOpaque = false
        wv.backgroundColor = .clear
        context.coordinator.home = url
        wv.load(URLRequest(url: url, cachePolicy: .useProtocolCachePolicy))
        return wv
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}

    final class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
        var home: URL?
        var shotsStarted = false

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            NSLog("KEEPO didFinish %@", webView.url?.absoluteString ?? "-")
            DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
                webView.evaluateJavaScript("JSON.stringify({t:document.title,len:document.body.innerText.length,txt:document.body.innerText.slice(0,200),err:window.__kerr||null})") { r, e in
                    NSLog("KEEPO probe %@ %@", String(describing: r), String(describing: e))
                }
            }
            // Mode screenshot App Store (hanya bila diluncurkan dengan argumen -shots)
            guard ProcessInfo.processInfo.arguments.contains("-shots"), !shotsStarted else { return }
            shotsStarted = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
                webView.evaluateJavaScript("document.querySelector('[data-try=en]')?.click(); 'sample'") { r, _ in NSLog("KEEPO shot %@", String(describing: r)) }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 35) {
                let js = "(()=>{const w=[...document.querySelectorAll('.w')].filter(x=>{const b=x.getBoundingClientRect();return b.top>200&&b.top<innerHeight*0.45&&x.textContent.length>5});if(w[0]){w[0].click();return w[0].textContent}return 'none'})()"
                webView.evaluateJavaScript(js) { r, _ in NSLog("KEEPO shot word %@", String(describing: r)) }
            }
        }
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) { NSLog("KEEPO didFail %@", error.localizedDescription) }

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
            NSLog("KEEPO provFail %@", error.localizedDescription)
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

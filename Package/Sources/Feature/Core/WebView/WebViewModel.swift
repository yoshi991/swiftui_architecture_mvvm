//
//  WebViewModel.swift
//
//
//  Created by Yoshiki Hemmi on 2022/10/01.
//

import Combine
import Foundation
import WebKit

@MainActor
public final class WebViewModel: NSObject, ObservableObject {

    @Published var isLoading = false
    @Published var canGoBack = false
    @Published var canGoForward = false

    @Published var shouldGoBack = false
    @Published var shouldGoForward = false
    @Published var shouldLoad = false

    @Published var estimatedProgress: Double = 0
    @Published var error: WebViewError?

    private var cancellables = Set<AnyCancellable>()
    private(set) var url: URL?

    public init(url: String) {
        self.url = URL(string: url)
    }

    func current(url: URL?) {
        guard let url = url else {
            return
        }
        self.url = url
    }

    func load(url: String) {
        load(url: URL(string: url))
    }

    func load(url: URL?) {
        if url == nil {
            error = WebViewError(code: URLError.badURL, message: "Bad URL.")
            return
        }

        self.url = url
        shouldLoad = true
    }

    func handleError(_ error: Error) {
        if let error = error as? URLError {
            self.error = WebViewError(code: error.code, message: error.localizedDescription)
        }
    }

    func subscribe(wkWebView: WKWebView) {
        wkWebView.publisher(for: \.isLoading)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.isLoading = value
            }
            .store(in: &cancellables)

        wkWebView.publisher(for: \.canGoBack)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.canGoBack = value
            }
            .store(in: &cancellables)

        wkWebView.publisher(for: \.canGoForward)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.canGoForward = value
            }
            .store(in: &cancellables)

        wkWebView.publisher(for: \.estimatedProgress)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.estimatedProgress = value
            }
            .store(in: &cancellables)
    }
}

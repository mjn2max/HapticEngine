//
// File.swift
// HapticEngine
//
// Created by Huy D. on 4/8/25
// mjn2max.github.io 😜
// 
// Copyright © 2025. All rights reserved.
// CodePassion.dev
//

protocol HapticEngineProtocol {
    // MARK: - Properties
    var isHapticsSupported: Bool { get }
    
    // MARK: - Methods
    func startSimpleHaptic()
    func startComplexHaptic()
}

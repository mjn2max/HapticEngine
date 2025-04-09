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
    var isHapticsSupported: Bool { get }

    func startSimpleHaptic()
    func startComplexHaptic()
}

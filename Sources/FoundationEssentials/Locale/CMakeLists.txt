##===----------------------------------------------------------------------===##
##
## This source file is part of the Swift open source project
##
## Copyright (c) 2024 Apple Inc. and the Swift project authors
## Licensed under Apache License v2.0
##
## See LICENSE.txt for license information
## See CONTRIBUTORS.md for the list of Swift project authors
##
## SPDX-License-Identifier: Apache-2.0
##
##===----------------------------------------------------------------------===##

target_sources(FoundationEssentials PRIVATE
    Locale+Components.swift
    Locale+Language.swift
    Locale.swift
    Locale_Autoupdating.swift
    Locale_Cache.swift
    Locale_Notifications.swift
    Locale_Preferences.swift
    Locale_Protocol.swift
    Locale_Unlocalized.swift)

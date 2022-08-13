project=ArchitectureResearch.xcodeproj

.PHONY: help
help: ## Show this usage
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.PHONY: xcode
xcode: ## Select latest version of Xcode
	sudo xcode-select --switch /Applications/Xcode.app/

.PHONY: bootstrap
bootstrap: ## Install tools
	make clean
	make build-cli-tools

.PHONY: project
project: ## Generate project
	make swiftgen

.PHONY: mock
mock: ## Generate mock
	./Tools/MockoloTool/.build/arm64-apple-macosx/release/mockolo --enable-args-history -s Packages/Infrastructure/Sources -d Packages/Infrastructure/Tests/InfrastructureTests/TestHelper/Mock/Generated/Mock.swift -i Infrastructure

.PHONY: swiftgen
swiftgen: ## Generate resources swift files.
	swift run -c release --package-path ./Tools/Common swiftgen

.PHONY: open
open: ## Open Xcode workspace
	open $(project)

.PHONY: clean
clean: ## Clean generated files
	rm -rf ./**/Generated/*
	rm -rf ~/Library/Developer/Xcode/DerivedData/*
	rm -rf Pods
	rm -rf Carthage
	rm -rf ./Tools/**/.build/*

.PHONY: build-cli-tools
build-cli-tools: ## Build CLI tools managed by SwiftPM
	swift build -c release --package-path ./Tools/Common --product license-plist
	swift build -c release --package-path ./Tools/Common --product swiftgen
	swift build -c release --package-path ./Tools/SwiftLintTool --product swiftlint
	swift build -c release --package-path ./Tools/MockoloTool --product mockolo

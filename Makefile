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

.PHONY: mock
mock: ## Generate mock
	swift run -c release --package-path ./Tools/MockoloTool mockolo --enable-args-history -s Packages/Infrastructure/Sources -d Packages/Infrastructure/Tests/InfrastructureTests/TestHelper/Mock/Generated/InfrastructureMock.swift -i Infrastructure
	swift run -c release --package-path ./Tools/MockoloTool mockolo --enable-args-history -s Packages/Domain/Sources -d Packages/Domain/Tests/DomainTests/TestHelper/Mock/Generated/DomainMock.swift -i Domain
	swift run -c release --package-path ./Tools/MockoloTool mockolo --enable-args-history -s Packages/Domain/Sources -d Packages/Presentation/Tests/PresentationTests/TestHelper/Mock/Generated/DomainMock.swift -i Domain
	swift run -c release --package-path ./Tools/MockoloTool mockolo --enable-args-history -s Packages/Presentation/Sources -d Packages/Presentation/Tests/PresentationTests/TestHelper/Mock/Generated/PresentationMock.swift -i Presentation

.PHONY: open
open: ## Open Xcode workspace
	open $(project)

.PHONY: test
test: ## Run tests on the command line.
	cd Packages/Domain; swift test
	xcodebuild -scheme 'Infrastructure' -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 13,OS=15.4' test
	xcodebuild -scheme 'Presentation' -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 13,OS=15.4' test

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
	swift build -c release --package-path ./Tools/Common --product swiftformat
	swift build -c release --package-path ./Tools/SwiftLintTool --product swiftlint
	swift build -c release --package-path ./Tools/MockoloTool --product mockolo

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

# Unreleased

### Added

### Changed

- Changed tests so no warnings are output to the console during test runs
- Updated the README for clarity

### Removed

### Fixed
- Updated inflex dependency

### Security

## [2.0.7]

### Added

### Changed

- Changed tests so no warnings are output to the console during test runs
- Updated the README for clarity

### Removed

### Fixed

### Security

## [2.0.6]

### Added

- schema generator
- migration generator

## [2.0.5]

### Fixed

- references contain a type annotation when binary_id is true

## [2.0.4]

### Added

- Documentation on configuration values

## [2.0.3]

### Changed

- Refactor how config is pulled from parent app

## [2.0.2]

### Changed

- Pull binary_id config for generators from parent app as a last resort, if config :app_slug is set

## [2.0.1]

### Added

- Added documentation on generators

---

[2.0.0]

### Added

- Add `where` option to `all` function
- Generators have been added to make generating schema and "context" modules within Phoenix applications easier.

### Changed

- Suffix is excluded by default. Suffix is only generated explicitly now with suffix: true.
- Small refactoring making it slightly simpler to read through the `resource` macro

### Fixed

- Some documentation fixes

## [1.3.3]

### Fixed

- Incorrect functions generated when providing both `suffix: false` and other options to the `resource` macro

---

## [1.3.2]

### Fixed

- Incorrect function name generation when providing both `suffix: false` and other options to the `resource` macro

---

## [1.3.1]

### Changed

- Allow keyword lists where currently only maps are supported

### Fixed

- Fixed some bad tests to have better assertions

---

## [1.3.0]

### Added

- `changeset` convenience function added

---

## [1.2.0] - 2019-09-17

### Added

- Now generates `get_by`, and `get_by!` functions
- `suffix: false` option

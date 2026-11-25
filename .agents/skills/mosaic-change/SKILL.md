---
name: mosaic-change
description: Use when changing Mosaic, the shared SwiftUI toolkit: adding or editing a control, a prose or note view, the palette or a symbol; running its tests; checking that the apps still build against it; or releasing a version.
---

# Changing Mosaic

`AGENTS.md` carries the rules. This is the procedure around them.

## 1. Two apps depend on it

Mosaic is linked by **the app** and **the app**. One app compiling proves nothing about the other, which is why the repo ships a script that builds both:

```sh
swift test
Scripts/verify-apps.sh
```

`Scripts/verify-apps.sh` expects both checkouts beside `~/Sources/Mosaic`, builds each against this package in its own derived data under the temporary directory, and keeps a log per step. Run it before a release, not just the package tests.

## 2. Rules that bite

- No `try?`. Catch and log, or return `nil`.
- No SF Symbol strings. Add a `SFSymbol` case in Motley instead of naming one here.
- No global functions or variables; scope them to an enum.
- Public API is shared by two apps: a rename or a removed default is a breaking change for both.
- One type per file, sorted imports, trailing commas, `@State` private.
- A `#Preview` that uses a fixture sits inside `#if DEBUG`, or an archive fails while previews still compile.

## 3. Format and lint

`.swift-format` is the formatting source of truth, and SwiftLint runs as a build plugin — a warning is a failure.

## 4. Release, because the apps pin a version

1. Set `MosaicInfo.version` to the release number, then commit in the repo's style: `v1.6.0 – Gives the settings row a synopsis`. An assistant's body ends with `Assisted-by: AI (<model>)`, never a `Co-Authored-By` or "Generated with" line.
2. Tag it with `git tag -a v1.6.0 -m "v1.6.0"`, then push branch and tag by name:

   ```sh
   git push github main
   git push github v1.6.0
   ```

3. Raise the pin in both consumers — `XCRemoteSwiftPackageReference` `minimumVersion` in the app's and the app's `project.pbxproj` — then:

   ```sh
   xcodebuild -resolvePackageDependencies -project the app.xcodeproj -scheme the app
   xcodebuild -resolvePackageDependencies -project the app.xcodeproj -scheme the app
   ```

Never edit a package checkout under DerivedData; the next resolve throws it away.

## Checklist

- [ ] No `try?`, no SF Symbol strings, no global free functions
- [ ] `swift test` passes and lint is clean
- [ ] `MosaicInfo.version` matches the tag
- [ ] `Scripts/docs.sh` builds the guides without a warning from this repo
- [ ] `Scripts/verify-apps.sh` passes before a release
- [ ] An assistant's commit ends `Assisted-by: AI (<model>)`, with no `Co-Authored-By`
- [ ] Tagged and pushed
- [ ] the app and the app pins raised, `Package.resolved` committed with each

---
name: mosaic-change
description: Use when changing Mosaic, the few pieces of SwiftUI here: adding or editing a control, a prose or note view, the palette or a symbol; running its tests; building it for each platform; or releasing a version.
---

# Changing Mosaic

`AGENTS.md` carries the rules. This is the procedure around them.

## 1. Prove it on every platform

```sh
swift test
Scripts/build-docs.sh
```

Mosaic builds for iOS, tvOS and macOS, and a control that compiles on one can still fail on another. CI builds the package for all three; run the docs script when you touch a doc comment or a guide. Do both before a release, not just the package tests.

## 2. Rules that bite

- No `try?`. Catch and log, or return `nil`.
- No SF Symbol strings. Add a `SFSymbol` case in Motley instead of naming one here.
- No global functions or variables; scope them to an enum.
- The public API is shared, so a rename or a removed default breaks the apps that link it.
- One type per file, sorted imports, trailing commas, `@State` private.
- A `#Preview` that uses a fixture sits inside `#if DEBUG`, or an archive fails while previews still compile.

## 3. Format and lint

`.swift-format` is the formatting source of truth, and SwiftLint runs as a build plugin — a warning is a failure.

## 4. Release, because apps pin a version

1. Set `MosaicInfo.version` to the release number, then commit in the repo's style: `v1.6.0 – Gives the settings row a synopsis`. An assistant's body ends with `Assisted-by: AI (<model>)`, never a `Co-Authored-By` or "Generated with" line.
2. Tag it with `git tag -a v1.6.0 -m "v1.6.0"`, then push branch and tag by name:

   ```sh
   git push github main
   git push github v1.6.0
   ```

3. Raise the pin in each app that links it, then:

   ```sh
   xcodebuild -resolvePackageDependencies -project <name>.xcodeproj -scheme <name>
   ```

Never edit a package checkout under DerivedData; the next resolve throws it away.

## Checklist

- [ ] No `try?`, no SF Symbol strings, no global free functions
- [ ] `swift test` passes and lint is clean
- [ ] `MosaicInfo.version` matches the tag
- [ ] `Scripts/build-docs.sh` builds the guides without a warning from this repo
- [ ] An assistant's commit ends `Assisted-by: AI (<model>)`, with no `Co-Authored-By`
- [ ] Tagged and pushed
- [ ] Pins raised in the apps that link it, if they need the change

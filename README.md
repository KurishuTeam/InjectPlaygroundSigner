# InjectPlaygroundSigner

> [!WARNING]
> WIP
> 
> this project is WIP so expect that it will blow up ur mac until stability is confirmed

Basically calls swift playground's sign method.

## Usage:
### Requirements:
- Swift Playground installed (obviously)
- A mac with SIP disabled

### Steps
1. place ur binary/framework/app(s) in `~/Library/Containers/com.apple.PlaygroundsMac/Data/Documents/SignAll/`
2. download latest dylib from releases
3. type this command:
```bash
DYLD_INSERT_LIBRARIES="/path/to/InjectPlaygroundSignerMac.dylib" \
  /Applications/Swift\ Playground.app/Contents/MacOS/Swift\ Playground/
```
4. If it worked, the binaries at `~/Library/Containers/com.apple.PlaygroundsMac/Data/Documents/SignAll/` will be signed with the "Swift Playgrounds Local Development" identity (verify with `codesign -dvvv` or `zsign -C`)

**confirmed**:
- dlopen in Swift Playground works on binaries signed with this

**will test**:
- signed binaries support ipad playgrounds or not
- linkerSettings to link actual libraries


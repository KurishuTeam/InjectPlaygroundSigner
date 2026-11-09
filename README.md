# InjectPlaygroundSigner

just swizzles a swift playground function, signs all binaries at `~/Library/Containers/com.apple.PlaygroundsMac/Data/Documents/SignAll/`

**confirmed**:
- dlopen in Swift Playground works on binaries signed with this

**will test**:
- signed binaries support ipad playgrounds or not
- linkerSettings to link actaul libraries


# Obtaining the SecIdentityRef of 'Swift Playgrounds Local Development'

**Through the power of reverse engineering, I discovered some symbols**:

### `_PGSSecIdentityCreate`
**Disassembly:**
```asmasm
mov        x2, x1                                      
mov        x1, x0
adrp       x8, #0x14000                                
ldr        x8, [x8, #0x4c8]                            
ldr        x0, [x8]                                   
b          imp___stubs__SecIdentityCreate
```

This takes two args, which is (im assuming):
- a SecKey
- a SecCertificate

It then calls into SecIdentityCreate, using the `kCFAllocatorDefault`

### `static PlaygroundCodeSigning.CertificateManager.swiftPlaygroundsSigningIdentity() throws -> __C.SecIdentityRef+36`

*Mangled: `_$s21PlaygroundCodeSigning18CertificateManagerO016swiftPlaygroundsC8IdentitySo03SecH3RefayKFZ+36`*

The `+36` part is likely just a weird compiler thing, but the rest shows that it returns the signing identity of Swift Playground.

**Disassembly:**

```armasm
000000000000c160         stp        x23, x22, [sp, #-0x30]!                     ; Begin of unwind block (FDE at 0x13c88)
000000000000c164         stp        x20, x19, [sp, #0x10]
000000000000c168         stp        fp, lr, [sp, #0x20]
000000000000c16c         add        fp, sp, #0x20
000000000000c170         bl         sub_ce30                                    ; sub_ce30
000000000000c174         cbnz       x21, loc_c1b8

000000000000c178         mov        x19, x0
000000000000c17c         bl         sub_c3a4                                    ; sub_c3a4
000000000000c180         mov        x20, x21
000000000000c184         cbz        x21, loc_c194

000000000000c188         bl         imp___stubs__objc_release_x19               ; objc_release_x19
000000000000c18c         mov        x21, x20
000000000000c190         b          loc_c1b8

                     loc_c194:
000000000000c194         mov        x22, x0                                     ; CODE XREF=_$s21PlaygroundCodeSigning18CertificateManagerO016swiftPlaygroundsC8IdentitySo03SecH3RefayKFZ+36
000000000000c198         mov        x0, x19                                     ; argument #1 for method _PGSSecIdentityCreate
000000000000c19c         mov        x1, x22                                     ; argument #2 for method _PGSSecIdentityCreate
000000000000c1a0         bl         _PGSSecIdentityCreate                       ; _PGSSecIdentityCreate
000000000000c1a4         mov        x23, x0
000000000000c1a8         bl         imp___stubs__objc_release_x19               ; objc_release_x19
000000000000c1ac         bl         imp___stubs__objc_release_x22               ; objc_release_x22
000000000000c1b0         mov        x0, x23
000000000000c1b4         mov        x21, x20

                     loc_c1b8:
000000000000c1b8         ldp        fp, lr, [sp, #0x20]                         ; CODE XREF=_$s21PlaygroundCodeSigning18CertificateManagerO016swiftPlaygroundsC8IdentitySo03SecH3RefayKFZ+20, _$s21PlaygroundCodeSigning18CertificateManagerO016swiftPlaygroundsC8IdentitySo03SecH3RefayKFZ+48
000000000000c1bc         ldp        x20, x19, [sp, #0x10]
000000000000c1c0         ldp        x23, x22, [sp], #0x30
```

This just gets the identity.

I can call this whole swift function to get the identity.
_: _final: prev: {
  gitui = prev.gitui.overrideAttrs (attrs: {
    postPatch =
      attrs.postPatch
      + prev.lib.optionalString prev.stdenv.hostPlatform.isDarwin ''
        # Patch the sha1-asm dependency for aarch64-darwin. The GNU-style
        # relocation specifiers (#:lo12:...@PAGEOFF) are not supported by the
        # macOS assembler. We replace the single complex `ldr` instruction with
        # a standard two-instruction sequence: `add` to calculate the full
        # address using the @PAGEOFF relocation, and then a simple `ldr`.
        local asm_file="../gitui-0.27.0-vendor/sha1-asm-0.5.3/src/aarch64_apple.S"
        substituteInPlace "$asm_file" \
          --replace-fail $'\tldr\tq4, [x1, #:lo12:.K0@PAGEOFF]' $'\tadd\tx1, x1, .K0@PAGEOFF\n\tldr\tq4, [x1]'
        substituteInPlace "$asm_file" \
          --replace-fail $'\tldr\tq4, [x1, #:lo12:.K1@PAGEOFF]' $'\tadd\tx1, x1, .K1@PAGEOFF\n\tldr\tq4, [x1]'
        substituteInPlace "$asm_file" \
          --replace-fail $'\tldr\tq4, [x1, #:lo12:.K2@PAGEOFF]' $'\tadd\tx1, x1, .K2@PAGEOFF\n\tldr\tq4, [x1]'
        substituteInPlace "$asm_file" \
          --replace-fail $'\tldr\tq4, [x1, #:lo12:.K3@PAGEOFF]' $'\tadd\tx1, x1, .K3@PAGEOFF\n\tldr\tq4, [x1]'
      '';
  });
}

# Manual Adder Operation Validation Note

The published `RTL_trial3` module has default `N = 3`, so each input port can
represent unsigned values `0..7`.

Two requested final-validation cases contain values outside that range:

- `3 + 6 + 9`: `9` does not fit in 3 bits.
- `0 + 8 + 2`: `8` does not fit in 3 bits.

The correction is to keep `N = 3` and explicitly mark those cases invalid. The
testbench must not change `N` to make out-of-range values fit.

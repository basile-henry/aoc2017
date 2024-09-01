{ pkgs ? import <nixpkgs> {} }:

with pkgs;

mkShell {
  packages = [
    pkgsCross.riscv32-embedded.buildPackages.gcc
    gdb
    qemu
    dtc
  ];
}

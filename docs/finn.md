# FINN: A Fork Of Nim for Bare Metal
Finn is an experimental compiler/build wrapper used for freestanding and bare-metal Nim projects.

It exists to support environments where the standard Nim toolchain assumptions do not apply, such as:

- No operating system
- No libc
- No runtime
- No garbage collector
- Manual linking
- Explicit control over generated objects

Finn does **not** replace the Nim compiler.
It orchestrates and constrains it.

Think of Finn as a tool for asking:
“What does Nim look like when nothing else is there?”

This project is primarily used by experimental kernels and low-level systems.
It is not intended for general application development.

Changes:
- Introduced `-d:nimNoRuntime` and `-d:nimBareMetal` flags
- Disabled `nimErrorFlag` for freestanding compatibility
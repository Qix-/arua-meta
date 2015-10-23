![logo](logo.png)

---

# Arua-Lang Proposal

This is the Arua Language proposal. This readme answers some meta-questions
(i.e. *why another language*, etc.) and provides a table of contents to the
rest of the proposal's contents.

## Answers

#### Why yet another language?&#8482;
The dogmatic answers include:

- Language design is fun
- Compiler design is fun

The pragmatic answers include:

- C is great; let's improve on some of those ideas
- Rust has good design, but sub-par execution (purely opinion)
- Readability is something often overlooked
- Many languages assume a lot about the underlying system; let's not do that

#### What kind of language is Arua?
Arua is a systems programming language. It is meant to be compiled down to
machine code.

#### What architectures/platforms will Arua aim to support?
Arua will aim to support LLVM as its backend; any LLVM backend is thus
supported. This means x86, ARM, and a slew of other target platforms.

#### Does Arua aim to replace XYZ language?
No.

#### Is Arua better than XYZ language?
That is a completely subjective question. Arua aims to be Arua and solve many
common problems of modern computing.

#### Is Arua opinionated?
Yes, sort of. Every language is opinionated, though. For example:

- Arua is white-space scoped (no braces)
- Concurrent modification of memory between threads is unsupported (by choice)
- References, references, references

In other ways, Arua is very anti-opinion:

- Numeric widths (including floats) have arbitrary widths - always
- Every memory model is supported - not just stack and heap
- Aims to work with existing ABIs (no FFI nonsense to deal with)

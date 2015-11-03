![logo](logo.png)

---

# Arua-Lang Proposal

This is the Arua Language proposal. This readme answers some meta-questions
(e.g. *why another language*, etc.) and provides a table of contents to the
rest of the proposal's contents.

## Answers

#### What is Arua's core philosophy?
Arua code shows the **intent** of the program instead of writing code that
accommodates the system itself.

The compiler takes care of what that code actually transforms into given the
configuration and target.

For example, in C, it's commonly accepted to use the `int` type for booleans.
This is due to a mix of simplicity and optimizations via alignment.

However, in Arua, `i1` (an integer with a 1-bit width) is used. That is because
its *intent* is *not* to allow any other value than `1` or `0`.

The compiler can then make the assesment on how that type is optimized. If the
target system doesn't benefit from 32-bit alignment, a single byte will be used
in order to conserve memory. However, if the compiler is configured to favor
performance over memory usage/size, and a 32-bit value is faster than an 8-bit
value due to alignment, the compiler will decide to use a 32-bit value instead.

The target's optimizations should never influence the **intent** of the code.

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

- Numeric widths have arbitrary widths - always
- Every memory model is supported - not just stack and heap
- Aims to work with existing ABIs (no FFI nonsense to deal with)

#### Tl;dr feature list?
Sure:

- Traits + Composition = <3
- Immutable until specified otherwise
- Arbitrary integer widths
- Java-like dependency resolution (Java *gets it right*&#8482;)
- Explicit switch fallthrough
- Bounds-checked arrays (that are still 100% compatible with the C family ABI)
- **No macros**. Why is this a feature? See below.
- Language conveys intent; **directives** convey specifics (i.e. compiler
  options for portions of code). This means you can apply compiler options
  globally (via the command line), or for blocks of code (not just functions!)
- Fully compatible with C/C++ ABI
- Designed with embedded/operating systems in mind
- Compiler planned to provide comprehensive errors/warnings/notices, including
  how the compiler came to a conclusion about some code - allowing you to tweak
  verbosity however you please.
- AST optimizer planned to allow for complex pattern selection, and will be
  completely configurable for just *how extreme* you want size/speed
  considerations to be (e.g. loop unrolling thresholds, extent of de-branching,
  etc.)
- Complex math built directly into the language

#### Why is *No Macros* considered a feature?
If you've been following Rust at all, you'd know that [macros are currently the
reason behind poor tooling](https://www.reddit.com/r/rust/comments/35pn5a/criticizing_the_rust_language_and_why_cc_will/cr6o8jn). 
The complex nature of Rust macros cause the language
to be too irregular for predictive tooling to be created.

Further, as we all know, C-style macros are indeed very powerful, but they allow
for crazy and unsensible code to be written.

I took a step back and asked _what are we **really** trying to accomplish with
macros_? Simple: writing complex, potentially repetative code multiple times,
inlining such instructions.

We can achieve this with functions, but indeed with traditional functions you
lose the power of compile time inlining. This is why Arua's static optimizer
will provide extremely robust and extensive constant propagation strategies
in order to inline most const-able functions - many of which may be evaluated
in place at compile time.

As well, for those functions you know can't be statically evaluated, you can
always slip in a compiler directive to instruct the compiler to inline if
possible.

#### Where does the language draw the line between compiler-related constructs?
For clarification, this question could be re-worded:

> How does the language decide what is *intent* and what is considered a
> compilation *detail*? For instance, the C-family mixes the two with the
> `inline` and `volatile` keywords.

It's pretty simple, actually. If it tells the compiler how to do something,
it's a *detail*, thus it is specified within a compiler directive.

Otherwise, it most likely attempts to describe some sort of logic or layout of
the program, in which case it belongs in the language semantics (notwithstanding
compiler directives).

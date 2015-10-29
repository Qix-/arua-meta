#                                  (
#                                 ,@@.
#                                .@@@@
#                                @@@@@
#                               &@@@@
#                              /@@@@
#                              @@@@/
#                             @@@@@
#                            @@@@@
#                           (@@@@
#                          .@@@@,
#                          @@@@%
#                         &@@@@
#                        %@@@@
#                       *@@@@
#                       @@@@(
#                      @@@@&
#                     @@@@@
#                    (@@@@,
#                   .@@@@,
#                   @@@@%
#                  &@@@@
#                 %@@@@.
#                *@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#                @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&
#               @@@@&
#              (@@@@
#             #@@@@.
#            .@@@@,
#            @@@@&
#           &@@@@


#                 ARUA LANGUAGE SPECIFICATION v1 DRAFT
#                             October 2015
#                     Joshua Lee Junon, maintainer
#                            josh@junon.me
#                    Released under the MIT License

# ---------------------------------------------------------------------------- #

# !!! THIS DOCUMENT IS DESIGNED TO BE VIEWED USING THE SUPPLIED ViM SYNTAX !!! #

# 0 ARUA

# This document shall be referred to as the official Arua Language specification
# draft for the year of 2015.

# 0.1 ABSTRACT

# Arua is a systems language that is intended to mix new syntax with classic
# computation. In full, Arua's goal is to create a fully robust system's
# language that is not only easy to read, easy to write, but easy to use:
# kernels, applications, drivers, firmware, etc.

# Arua is a strongly typed, compiled systems programming language. Its focus
# is readability first, functionality second, and compatibility third. Unlike
# fellow contemporary languages, Arua doesn't intend to break existing ABIs -
# instead, it allows users to seamlessly work between them. A significant pillar
# when considering behaviors of compilation and tooling must, at all times, be
# at least in part the consideration of usability -- only sacrifice this when
# power or flexibility is at stake.

# As for runtime considerations, performance should be top priority.

# Many users might find similarities between Arua and other languages. This is
# intentional; Arua is simply the careful crafting of many great language con-
# structs melded together to form a simple but flexible language.

# Arua also aims to create a syntax that promotes extensive static analysis.
# Further, Arua aims to allow "free" memory constructs that not only allow
# such protections as bounds checking, while still being completely compatible
# to unsafe companion code or libraries.

# 0.2 OVERVIEW

# This specification is a living organism, and will *always* be as such. Arua
# shall favor syntactic clarity and progression over backwards compatibility
# (although breaking backwards compatibility should still be considered a near-
# last resort). If it makes the language 'better', but makes minor breaks to
# existing code, it shall be favored.

# 0.2.1 SCOPE

# This specification shall cover the following, and only the following:

# -- the syntax of the Arua language
# -- semantic rules for interpreting the Arua language
# -- the limitations, requirements, and boundaries of Arua language
#    implementations

# This specification shall NOT cover any of the following:

# -- implementation details, including machine code generation techniques, if
#    any
# -- limitations of target platforms
# -- implementation details of the standard ('official') Arua compiler or
#    associated tools
# -- input / outputs associated with Arua programs
# -- the mechanism that executes, analyzes, or otherwise interprets the Arua
#    language

# 0.2.2 LAYOUT

# This document is split into three parts:

# 1) introduction
# 2) high-level concepts
# 3) syntax, constrants and semantics

# 0.3 LICENSE

# The Arua Language, specification, logo and all associated documents are
# Copyright (C) 2015, Joshua Lee Junon. All Rights Reserved. All aforementioned
# materials are licensed under the MIT license, of which is just a Google search
# away.

# 0.4 ACKNOWLEDGEMENTS

# The Arua team recognizes there are many, many figures that have influenced
# the language, both directly and indirectly.

# First and foremost, this document's format and flow are heavily influenced
# by the X3J11 Technical Committee and American National Standards Committee
# of Computers and Information Processing's C89 (ANSI C) standard.

# Secondly, Arua was inspired by Rust, and much of its motivations stem from
# frustrations with the Rust language, timeline, and community. Even then,
# the Rust language can be attributed to many of Arua's semantics.

# Lastly, thank you to all brilliant minds before this publication that have
# progressed technology to what it is today; there are too many to list. It is
# an understatement to say you all have done the hard part.

# ---------------------------------------------------------------------------- #

# 1 UNIVERSE

# The Arua universe makes up the Arua language, dependency system, methodology
# and mindset (the approach Arua takes to systems programming), and rules and
# philosophies that govern them.

# 1.1 ANATOMY OF A SYSTEM

# Arua views a system as a collection of units. Each unit provides a specific
# function to the system. Each unit performs one, simple and independent
# function. Nothing more.

# Units in computing are generally analogous to resources. Processors, memory
# banks, peripherals, etc.

# Just as a biological cell has many units (components), units can be grouped
# together to form subsystems. Subsystems also perform one function, but the
# function can be as specific or generic as required by the system. Usually,
# the most basic of subsystems yield high modularity but increase gross
# system complexity.

# Subsystems in computing can include memory management / garbage collection,
# virtualization, register arrays, busses, network links, plugin architectures,
# or even subsystems as high-level as standard libraries.

# Subsystems can not only include units, but other subsystems as well, this
# characteristic most commonly mapped to libraries in modern computer science.

# Subsystems are then combined to create systems, the difference between the
# two being that systems are standalone bodies that do not merge (easily) into
# another system.

# For instance, humans and glass are both made up of many carbon atoms (units),
# and those atoms are present in compounds (subsystems), and those compounds
# are combined into solutions and coagulate into solid or semi-solid bodies
# (systems) that do not mesh well together unless under very specific
# conditions.

# While the above description of a system is broad and seemingly unrelated to
# a programming language, Arua is designed with the system in mind. Unlike C
# and its sister languages, Arua aims to inlude the system in its consider-
# ations.

# 1.2 INTENT

# Arua is built to convey intent. This is, and shall forever be, Arua's primary
# goal. The language and all code written with it should be written in order to
# convey what the program means, not how the program works on the target system.
# In fact, target systems shouldn't be a consideration in the semantics of the
# language, ever. This, of course, notwithstanding target-specific facilities.

# This means, unlike C, programs should type their integers according to what
# the integer requires, not what is best for the target system. This same
# concept applies to all parts of the program, micro and macro alike.

# Further, this plays a large part of why macros do not exist. Macros are purely
# a tool for making coding less tedious, and are essentially functions that are
# evaluated at compile-time (this, of course, not completely black-and-white
# for the C-family preprocessors).

# Arua recognizes this necessity, but instead chooses optimization rather than
# a new construct, and thus necessitates the use of functions (yes, regular
# functions) in lieu of macros, as all statically evaluatable code will be
# inlined depending on the optimization settings.

# Functions convey intent - logical separations of execution. Macros do not
# guarantee such conveyance.

# 1.3 DEPENDENCIES

# Arua uses a dot-path directory-based module system. Users of Java will find
# this dependency system very familiar and comfortable. Dependencies are to be
# considered part of the specification, and all implementations of the specifi-
# cation shall adhere to them.

# The dependency system has two components:

# 1) dependency paths
# 2) zones

# 1.3.1 DEPENDENCY PATHS

# The compiler shall take a set of paths, both directories and files, that
# indicate from where zones are located.

# In the event the path is a directory, there are two places implementations
# shall look:

# 1) in the top level of the directory, for all `.zone' files, added in ASCII-
#    alphabetical order
# 2) usage of the directory as a base folder for zone source files, as described
#    by section §1.3.2.1

# In the event the path is a file and a `.zone' file, the file shall be added
# as a zone library.

# In the event the path is a file not a `.zone' file, the path shall be con-
# sidered erroneous and thus be unused. In such a case, user notification
# is optional and implementation-specific.

# All dependency paths follow the host system's convention, or a convention
# enforced by the implementation, as dependency paths are not found in the
# language itself.

# 1.3.2 ZONES

# Zones are Arua's modules. Zones are similar to namespaces, and as such are
# nestable.

# The Arua universe operates on a global zone called the root zone. All top
# level zones are actually nested zones, direct children of the root zone.

# Zones must be named. There are no such things as anonymous zones. All zone
# names must be alpha-numeric, and must start with a letter. As with all
# Arua identifiers, zones may not contain any special characters.

UNCONFIRMED
zone_identifier: /[A-Za-z][A-Za-z0-9]*/

# 1.3.2.1 ZONE PATHS

# Zone paths are dot-delimited paths that take two forms:

# 1) relative
# 2) absolute

# RFC should the leading dot be for relative paths instead of absolute?

# Relative zone paths are resolved from the current zone. Unlike system paths,
# relative zones paths cannot traverse upwards. They must instead use absolute
# paths.

RFC
zone_path: <zone_identifier> ("." <zone_identifier>)*

# Absolute paths paths are resolved from the root zone, and indicate this
# with a preceeding period character.

RFC
zone_path_absolute: "." <zone_path>

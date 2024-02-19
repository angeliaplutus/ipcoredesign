
# Property Specification Language (PSL) with GHDL Simolator

A collection of examples of using [PSL](https://en.wikipedia.org/wiki/Property_Specification_Language) for functional and formal verification of VHDL designs with [GHDL](https://github.com/ghdl/ghdl) (and [Yosys](https://github.com/YosysHQ/yosys) / [SymbiYosys](https://github.com/YosysHQ/SymbiYosys)).

This is a project with the purpose to get a current state of PSL implementation in GHDL. It probably will find unsupported PSL features, incorrect implemented features or simple bugs like GHDL crashs.

It is also intended for experiments with PSL when learning the language. You can play around with the examples, as they are pretty simple. You can comment out failing assertions if you want to have a successful proof or simulation. You can change them to see what happens.

It is recommended to use an up-to-date version of GHDL as potential bugs are fixed very quickly. Especially the synthesis feature of GHDL is very new and still beta. You can build GHDL from source or use one of the Docker images which contain also the SymbiYosys toolchain.

For example the `hdlc/formal:min` docker image provided by the [hdl containers project](https://hdl.github.io/containers/) (recommended). 


The next lists will grow during further development

## Supported by GHDL:

### Directives

* `assert` directive
* `cover` directive
* `assume` directive (synthesis)
* `restrict` directive (synthesis)

### Temporal operators (LTL style)

* `always` operator
* `never` operator
* logical implication operator (`->`)
* logical iff operator (`<->`)
* `next` operator
* `next[n]` operator
* `next_a[i to j]` operator
* `next_e[i to j]` operator
* `next_event` operator
* `next_event[n]` operator
* `next_event_e[i to j]` operator
* `until` operator
* `until_` operator
* `before` operator (GHDL crash with a specific invalid property, see [PSL before example](https://github.com/tmeissner/psl_with_ghdl/blob/master/src/psl_before.vhd#L53))
* `eventually!` operator

### Sequential Extended Regular Expressions (SERE style)

* Simple SERE
* Concatenation operator (`;`)
* Fusion operator (`:`)
* Overlapping suffix implication operator (`|->`)
* Non overlapping suffix implication operator (`|=>`)
* Consecutive repetition operator (`[*]`, `[+]`, `[*n]`, `[*i to j]`)
* Non consecutive repetition operator (`[=n]`, `[=i to j]`)
* Non consecutive goto repetition operator (`[->]`, `[->n]`, `[->i to j]`)
* Length-matching and operator (`&&`)
* Non-length-matching and operator (`&`)
* or operator (`|`)
* `within` operator

### Other operators

* `abort` operator
* `async_abort` operator
* `sync_abort` operator

### Built-in functions

* `prev()` function (Synthesis only)
* `stable()` function (Synthesis only)
* `rose()` function (Synthesis only)
* `fell()` function (Synthesis only)
* `onehot()` function (Synthesis only)
* `onehot0()` function (Synthesis only)

### Convenient stuff

* Partial support of PSL vunits (synthesis only)
* Partial support of named sequences (some parameter types missing)
* Partial support of named properties (some parameter types missing)
* Partial support of PSL `endpoint` (simulation only, in PSL comments)
* vunit inhiterance (`inherit`, synthesis only)

### Yosys formal extensions (reference to [Symbiyosys docs](https://symbiyosys.readthedocs.io/en/latest/verilog.html#unconstrained-variables))

* `anyconst` attribute (synthesis only)
* `anyseq` attribute (synthesis only)

## Not yet supported by GHDL:

* `forall` operator
* `for` operator
* Synthesis of built-in functions `countones()`, `isunknown()`
* Synthesis of strong operator versions
* Simulation of built-in functions
* Simulation of PSL vunits
* PSL macros (`%for`, `%if`)
* `union` expression

## Supported, but under investigation

* `eventually!` behaviour with liveness proofs, see [GHDL issue 1345](https://github.com/ghdl/ghdl/issues/1345)

## Further Ressources

* [Wikipedia about PSL](https://en.wikipedia.org/wiki/Property_Specification_Language)
* [Doulos Designer's Guide To PSL](https://www.doulos.com/knowhow/psl/)
* [Project VeriPage PSL Tutorial](http://www.project-veripage.com/psl_tutorial_1.php)
* [FirstEDA Blog - An Introduction to Assertion-Based Verification](https://firsteda.com/news/an-introduction-to-assertion-based-verification-part-1)
* [FirstEDA Blog - Achieving Better Coverage with VHDL](https://firsteda.com/news/achieving-better-coverage-with-vhdl-part-2)
* [1850-2010 - IEEE Standard for PSL](https://standards.ieee.org/standard/1850-2010.html)
* [A Practical Introduction to PSL Book](https://www.springer.com/gp/book/9780387361239)
* [Formal Verification Book](https://www.elsevier.com/books/formal-verification/seligman/978-0-12-800727-3)
* [PSL Specification for WISHBONE System-on-Chip (from the PROSYD project)](https://opencores.org/websvn/filedetails?repname=copyblaze&path=%2Fcopyblaze%2Ftrunk%2Fcopyblaze%2Fdoc%2Fdev%2FWishBone%2Fprosyd1.4_1_annex.pdf)
* [GHDL documentation](https://ghdl.readthedocs.io)
* [SymbiYosys documentation](https://symbiyosys.readthedocs.io)

# ALU-Verification-Demo-using-OSVVM

## Description
This is a simple Verification environment demo for Arithmetic Logic Unit (ALU) using Open Source VHDL Verification Methodology (OSVVM)

## Overview
OSVVM is an advanced verification methodology that defines a VHDL verification framework, verification utility library, verification component library, and a scripting flow that simplifies your FPGA or ASIC verification project from start to finish. Using these libraries you can create a simple, readable, and powerful testbench that is suitable for either a simple FPGA block or a complex ASIC [\[Ref](https://github.com/OSVVM)\].

## Testbench Framework
The top level testbench Framwork sometimes called Test Harness contains three main components:

 The Device Under Test (DUT) 
The Test Sequencer/Control
The Verification Component


### The DUT
In this demo it is the ALU VHDL code which is intended to be tested, and is a simple design for ALU with the follwoing operations:

| Operation   | SEL         |
| :----:      | :----:      |
| Addition    | 000         |
| Subtraction | 001         |
| A - 1       | 010         |
| A + 1       | 011         |
| A AND B     | 100         |
| A OR  B     | 101         |
| NOT A       | 110         |
| A XOR B     | 111         |

And the output will be delayed one clock cycle from the input due to an additional register has been added at the output port.

### The Test Sequencer/ Control
The Test Control contains the test cases that will be fed into the model, in this design there are two main packages that have been used from the OSVVM Libraries

```vhdl
  library osvvm;
    context osvvm.OsvvmContext ;
    use osvvm.RandomPkg.all;
    use osvvm.CoveragePkg.all;
```
The Randomization Package is to feed the inputs signals with random values and the Coverage Package is to assure that we have covered all the possible combinations on the inputs.

### Verification Component (ALUController)
The main purpose of this component is to compare the output of the DUT with the golden model (the expected result), the main package used here is the Scoreboard Package.

```vhdl
library osvvm;
  context osvvm.OsvvmContext;
  use osvvm.ScoreboardPkg_slv.all;
```

## How to run this demo
First you need to download the OsvvmLibraries, you can simply run this command:
```
  $ git clone --recursive https://github.com/osvvm/OsvvmLibraries
```
after you successfully download the Libraries, you will now need a simulator that can compile VHDL - 2008

Now go to the directory that you have donwloaded the OsvvmLibraries and create a foleder called "sim", open your simulator (in my case ModelSim HDL Simulator), and in the TCL console change the directory to the "sim" directory that you hvae created before and run these commands.
```
source ../OsvvmLibraries/Scripts/StartUp.tcl
build ../OsvvmLibraries/OsvvmLibraries.pro
build ../OsvvmLibraries/ALU/RunAllTests.pro
```

Now open a new project and add all the soucre files and the testbench files in this project and run this script:
```
source ../OsvvmLibraries/ALU/run.tcl
```

Now go to the "sim" directory you will find the Test report has been generated.




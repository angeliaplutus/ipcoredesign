# ALU: Assertions Based Verification
<p align = "justify">A testbench was implemented using SystemVerilog Assertions on Mentor QuestaSim in order to verify an ALU RTL to ensure that the ALU functions as intended, and to detect any present bugs.</p>

<p align = "justify">The ALU has 4 input ports and 2 output ports.</p>
<p align = "justify">
Inputs:
  <ul>
  <li><i>A</i>: First Operand (8-Bit)</li>
  <li><i>B</i>: Second Operand (8-Bit)</li>
  <li><i>ALU_Sel</i>: Selection Line (4-Bit)</li>
  <li><i>clk</i></li>
  </ul>
  </p>
<p align = "justify">
Outputs:
  <ul>
  <li><i>ALU_Out</i>: ALU Output (8-Bit)</li>
  <li><i>CarryOut</i>: Carry Out Flag (1-Bit)</li>
  </ul>
  </p>

<b>Bugs Detection</b>
<p align = "justify">
The ALU (Device Under Test) has 3 bugs, namely Subtraction, Logical OR and Logical NAND operations, which were detected by the testbench.</p>

<p align = "justify">The tesbench includes a total of 19 assertions: one for each ALU operation to validate the correctness of the ALU output (16 assertions), as well as, an assertion which ensures that the carry out is correct and two assertions which check that the corner cases were tested (Corner Case 1: <i>A = 0 and B = 0</i>, Corner Case 2: <i>A = 255 and B = 255</i>). Since the randomization still fails to generate the desired corner cases (as shown in the previous screenshot where both assertions did not pass), the corner cases could be added manually to the testbench.</p>

<b>Coverage</b>
<p align = "justify">  
The HTML coverage report as well as detailed coverage report were generated to analyze the verification. The detailed coverage report was generated using the <i>coverage report -detail</i> command option.
</p>

<p align = "center"><b>HTML Coverage Report</b></p>


<p align = "center"><b>Directive Coverage</b></p>

 

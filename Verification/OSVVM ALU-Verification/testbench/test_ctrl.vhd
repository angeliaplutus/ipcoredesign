library IEEE;
  use IEEE.Std_logic_1164.all;
  use IEEE.Numeric_Std.all;

library osvvm;
  context osvvm.OsvvmContext ;
  use osvvm.RandomPkg.all;
  use osvvm.CoveragePkg.all;

entity test_ctrl is
    Port (
            rstn_i      : in   STD_LOGIC;
            A_o         : out  STD_LOGIC_VECTOR(3 downto 0);
            B_o         : out  STD_LOGIC_VECTOR(3 downto 0);
            SEL_o       : out  STD_LOGIC_VECTOR(2 downto 0);
            test_done_o : out  STD_LOGIC := '0'
        );
end test_ctrl;

architecture osvvmbench of test_ctrl is

  -- Signals connected to the ALU
  signal RES              : std_logic_vector(3 downto 0) := (others => '0');
  signal A, B             : std_logic_vector(3 downto 0) := (others => '0');
  signal SEL              : std_logic_vector(2 downto 0) := (others => '0');

  -- Delay constants
  constant OP_DELAY : TIME := 10 ns;

  -- define the coverage signals combinations
  shared variable cp_SEL       : covPType;
  shared variable cp_A         : covPType;
  shared variable cp_B         : covPType;
  shared variable cp_A_SEL     : covPType;
  shared variable cp_B_SEL     : covPType;
  shared variable cp_A_B_SEL   : covPType;

  -- declare end of simulation signals
  signal Stop : BOOLEAN;
  -- signal CoutF : std_logic_vector(8 downto 0);

begin

  -- Output conncetions
  A_o   <= A;
  B_o   <= B;
  SEL_o <= SEL;

  -- Randomized stimulus
  Stim: process

    -- The random variables
    variable RndSEL : RandomPType;
    variable RndB   : RandomPType;
    variable RndA   : RandomPType;

    -- ncycles counts how many vectors were applied
    variable ncycles : natural;

    -- alldone is set true when simulation is complete
    variable alldone : boolean;

    -- integer versions of the inputs to the DUT
    variable SELInt     : natural range 0 to 7;   -- 3 bits for the selction
    variable AInt, BInt : natural range 0 to 15;  -- 4 bits for the inputs

  begin
    -- Wait until the reset to be deasserted
	wait until rstn_i = '1';

    -- Generate initial seeds
    RndSEL.InitSeed(RndSEL'instance_name);
    RndA.InitSeed  (RndA'instance_name);
    RndB.InitSeed  (RndB'instance_name);

    -- Set Normal distribution with mean of 8 and std deviation 3
    RndSEL.setRandomParm(NORMAL, 8.0, 3.0);

    -- allDone indicates end of test and NOW < 1ms is a timeout in case allDone is not asserted
    while not allDone and (NOW < 1 ms)  loop

        -- Generate random variables
        SEL <= RndSEL.Randslv(0,  7, 3);
        A   <= RndA.Randslv  (0, 15, 4);
        B   <= RndB.randslv  (0, 15, 4);
        wait for OP_DELAY;

        -- stop simulating when every combination of A, B, and SEL has been covered
        allDone := cp_A_B_SEL.isCovered;
        nCycles := nCycles + 1;
    end loop;

    wait for 1 ns;
    report "Number of simulation cycles = " & to_string(nCycles);
    STOP <= TRUE;
    wait;

  end process Stim;

----------------------------------------------------------------------------

  InitCoverage: process -- Sets up coverpoint bins
  begin

    -- 3 discrete bins for SEL
    cp_SEL.AddBins(GenBin(0, 7, 3));

    -- 4 equal bins for A, (e.g. 0-3, 4-7, 8-11, and 12-15)
    cp_A.AddBins(GenBin(0, 15, 4));

    -- 4 equal bins for B, (e.g. 0-3, 4-7, 8-11, and 12-15)
    cp_B.AddBins(GenBin(0 , 15, 4));


    -- Look for every combination of A and SEL
    cp_A_SEL.AddCross(GenBin(0, 15, 4), GenBin(0, 7, 3));

    -- look for every combination of B and SEL
    cp_B_SEL.AddCross(GenBin(0, 15, 4), GenBin(0, 7, 3));

    -- Every combination of A x B x SEL
    cp_A_B_SEL.AddCross(GenBin(0, 15, 4), GenBin(0, 15, 4), GenBin(0, 7, 3));

    wait;
  end process InitCoverage;

----------------------------------------------------------------------------

  Sample: process
  begin
    loop
      -- trigger a new sample when Op changes
      wait on SEL;
      -- wait until all signals stable
      wait for 1 ns;

      -- Sample the simple coverpoints
      cp_SEL.ICover     (TO_INTEGER(UNSIGNED(SEL)));
      cp_A.ICover       (TO_INTEGER(UNSIGNED(A)));
      cp_B.ICover       (TO_INTEGER(UNSIGNED(B)));

      -- The remaining coverpoints are crosses.
      cp_A_SEL.ICover    ( (TO_INTEGER(UNSIGNED(A)), TO_INTEGER(UNSIGNED(SEL))) );
      cp_B_SEL.ICover    ( (TO_INTEGER(UNSIGNED(B)), TO_INTEGER(UNSIGNED(SEL))) );
      cp_A_B_SEL.ICover  ( (TO_INTEGER(UNSIGNED(A)), TO_INTEGER(UNSIGNED(B)), TO_INTEGER(UNSIGNED(SEL))) );

    end loop;
  end process Sample;

----------------------------------------------------------------------------
  CoverReport: process
  begin

    wait until STOP;
    
    -- SetAlertLogName("TbALU") ;
    -- SetLogEnable(PASSED, TRUE) ;    -- Enable PASSED logs
    -- SetLogEnable(INFO, TRUE) ;      -- Enable INFO logs
    -- TranscriptOpen("./TbALU.txt") ;
    SetTranscriptMirror(TRUE) ; 
 

    report("A Coverage details");
    report("---------------------------------------------------------");
    cp_A.WriteBin;

    report("B Coverage details");
    report("---------------------------------------------------------");
    cp_B.WriteBin;

    report("SEL Coverage details");
    report("---------------------------------------------------------");
    cp_SEL.WriteBin;

    report "A x SEL Coverage details";
    report("---------------------------------------------------------");
    cp_A_SEL.writebin;
	
    report "B x SEL Coverage details";
    report("---------------------------------------------------------");
    cp_B_SEL.writebin;

    report("A x B  x SEL Coverage details");
    report("---------------------------------------------------------");
    cp_A_B_SEL.WriteBin;

    report "Coverage holes in A x B  x SEL = " & to_string(cp_A_B_SEL.CountCovHoles);
    
    if STOP = TRUE then
      test_done_o <= '1';
	  wait for 5 * OP_DELAY;
      report "End of simulation" severity failure;
    end if;
	
  end process CoverReport;

end architecture osvvmbench;

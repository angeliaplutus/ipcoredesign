library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use ieee.numeric_std_unsigned.all;
  use ieee.std_logic_unsigned.all;

library osvvm;
  context osvvm.OsvvmContext;
  use osvvm.ScoreboardPkg_slv.all;

library osvvm_common;
  context osvvm_common.OsvvmCommonContext;

entity ALUController is
  generic (
           tperiod_Clk      : time   := 10 ns
  ) ;
  port (
           clk_i       : in  STD_LOGIC;
           rstn_i      : in  STD_LOGIC;
           A_i         : in  STD_LOGIC_VECTOR(3 downto 0);
           B_i         : in  STD_LOGIC_VECTOR(3 downto 0);
           SEL_i       : in  STD_LOGIC_VECTOR(2 downto 0);
           RES_i       : in  STD_LOGIC_VECTOR(3 downto 0);
           test_done_i : in  STD_LOGIC
  ) ;

end entity ALUController ;

architecture behv of ALUController is

  signal expected_RES : STD_LOGIC_VECTOR(3 downto 0);
  signal ModelID      : AlertLogIDType ;

begin

  INITIALIZE_PROC : process
    variable ID : AlertLogIDType ;
  begin
    -- Alerts
    ID        := NewID("ALU_INST") ;
    ModelID   <= ID ;
    wait ;
  end process INITIALIZE_PROC ;

  MODEL_PROC : process(SEL_i, A_i, B_i) begin
 
    case SEL_i is
        when "000" =>
            expected_RES <= A_i + B_i after tperiod_Clk;
            AffirmIfEqual(
              ModelID,
              RES_i,
              expected_RES,
              "  Operation: Add              , SEL: "     & to_hxstring(SEL_i) &
              "  A_i: "                      & to_hxstring(A_i)   &
              "  B_i: "                      & to_hxstring(B_i)   &
              "       expected_RES: "        & to_hxstring(expected_RES));
        when "001" =>
            expected_RES <= A_i - B_i after tperiod_Clk;
            AffirmIfEqual(
              ModelID,
              RES_i,
              expected_RES,
              "  Operation: Subtrcat         , SEL: "     & to_hxstring(SEL_i) &
              "  A_i: "                      & to_hxstring(A_i)   &
              "  B_i: "                      & to_hxstring(B_i)   &
              "       expected_RES: "        & to_hxstring(expected_RES));
        when "010" =>
            expected_RES <= A_i - 1 after tperiod_Clk;
            AffirmIfEqual(
              ModelID,
              RES_i,
              expected_RES,
              "  Operation: A - 1            , SEL: "        & to_hxstring(SEL_i) &
              "  A_i: "                      & to_hxstring(A_i)   &
              "  B_i: "                      & to_hxstring(B_i)   &
              "       expected_RES: "        & to_hxstring(expected_RES));
        when "011" =>
            expected_RES <= A_i + 1 after tperiod_Clk;
            AffirmIfEqual(
              ModelID,
              RES_i,
              expected_RES,
              "  Operation: A + 1            , SEL: "        & to_hxstring(SEL_i) &
              "  A_i: "                      & to_hxstring(A_i)   &
              "  B_i: "                      & to_hxstring(B_i)   &
              "       expected_RES: "        & to_hxstring(expected_RES));
        when "100" =>
            expected_RES <= A_i and B_i after tperiod_Clk;
            AffirmIfEqual(
              ModelID,
              RES_i,
              expected_RES,
              "  Operation: A AND B          , SEL: "      & to_hxstring(SEL_i) &
              "  A_i: "                      & to_hxstring(A_i)   &
              "  B_i: "                      & to_hxstring(B_i)   &
              "       expected_RES: "        & to_hxstring(expected_RES));
        when "101" =>
            expected_RES <= A_i or B_i after tperiod_Clk;
            AffirmIfEqual(
              ModelID,
              RES_i,
              expected_RES,
              "  Operation: A OR B           , SEL: "       & to_hxstring(SEL_i) &
              "  A_i: "                      & to_hxstring(A_i)   &
              "  B_i: "                      & to_hxstring(B_i)   &
              "       expected_RES: "        & to_hxstring(expected_RES));
        when "110" =>
            expected_RES <= not A_i after tperiod_Clk;
            AffirmIfEqual(
              ModelID,
              RES_i,
              expected_RES,
              "  Operation: NOT A            , SEL: "        & to_hxstring(SEL_i) &
              "  A_i: "                      & to_hxstring(A_i)   &
              "  B_i: "                      & to_hxstring(B_i)   &
              "       expected_RES: "        & to_hxstring(expected_RES));
        when "111" =>
            expected_RES <= A_i xor B_i after tperiod_Clk;
            AffirmIfEqual(
              ModelID,
              RES_i,
              expected_RES,
              "  Operation: A XOR B          , SEL: "        & to_hxstring(SEL_i) &
              "  A_i: "                      & to_hxstring(A_i)   &
              "  B_i: "                      & to_hxstring(B_i)   &
              "       expected_RES: "        & to_hxstring(expected_RES));
        when others =>
        NULL;
    end case;
  end process;

  REPORT_PROC : process begin
	SetAlertLogName("ALUCtrl") ;
	SetLogEnable(PASSED, TRUE) ;
	SetLogEnable(INFO, TRUE) ;
	TranscriptOpen("./test_report.txt") ;
	SetTranscriptMirror(TRUE) ; 
	
	wait until test_done_i = '1';
	TranscriptClose;
	EndOfTestReports;

	wait;
  end process REPORT_PROC;

end architecture behv ;

library ieee ;
  use ieee.std_logic_1164.all ;
  use ieee.numeric_std.all ;
  use ieee.numeric_std_unsigned.all ;
  use ieee.std_logic_unsigned.ALL;

library osvvm ;
  context osvvm.OsvvmContext;
  use osvvm.RandomPkg.all;
  use osvvm.CoveragePkg.all;



entity tbALU is
end entity tbALU ;


architecture TestHarness of tbALU is

  -- Delay definations
  constant tperiod_Clk : time := 10 ns ;
  constant tpd         : time := 2 ns ;

  -- Clock and reset interface
  signal Clk         : std_logic := '0';
  signal nReset      : std_logic := '0';

  -- ALU interface
  signal A_internal         : std_logic_vector(3 downto 0) := (others => '0');
  signal B_internal         : std_logic_vector(3 downto 0) := (others => '0');
  signal SEL_internal       : std_logic_vector(2 downto 0) := (others => '0');
  signal RES_internal       : std_logic_vector(3 downto 0) := (others => '0');
  signal test_done_internal : std_logic := '0';


  -- Declare the DUT
  component alu is
      Port (
              clk_i       : in  STD_LOGIC;
              rstn_i      : in  STD_LOGIC;
              A_i         : in  STD_LOGIC_VECTOR(3 downto 0);
              B_i         : in  STD_LOGIC_VECTOR(3 downto 0);
              SEL_i       : in  STD_LOGIC_VECTOR(2 downto 0);
              RES_o       : out STD_LOGIC_VECTOR(3 downto 0)
        );
  end component alu;

  -- Declare the TestCtrl
  component test_ctrl is
      Port (
              rstn_i      : in   STD_LOGIC;
              A_o         : out  STD_LOGIC_VECTOR(3 downto 0);
              B_o         : out  STD_LOGIC_VECTOR(3 downto 0);
              SEL_o       : out  STD_LOGIC_VECTOR(2 downto 0);
              test_done_o : out  STD_LOGIC := '0'
          );
  end component test_ctrl;

  -- Declare the VC
  component ALUController is
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
  end component ALUController;

begin

  -- create Clock
  Osvvm.TbUtilPkg.CreateClock (
    Clk        => Clk,
    Period     => Tperiod_Clk
  )  ;

  -- create nReset
  Osvvm.TbUtilPkg.CreateReset (
    Reset       => nReset,
    ResetActive => '0',
    Clk         => Clk,
    Period      => 7 * tperiod_Clk,
    tpd         => tpd
  ) ;

  ------------------------------------------------------------
   ALU_1 : ALU
  ------------------------------------------------------------
    port map (
      clk_i         => Clk,
      rstn_i        => nReset,
      A_i           => A_internal,
      B_i           => B_internal,
      SEL_i         => SEL_internal,
      RES_o         => RES_internal
    ) ;

  ------------------------------------------------------------
  TestCtrl_1 : test_ctrl
  ------------------------------------------------------------
  port map (
      rstn_i      => nReset,
      A_o         => A_internal,
      B_o         => B_internal,
      SEL_o       => SEL_internal,
      test_done_o => test_done_internal
  ) ;


  ------------------------------------------------------------
  VC_1 : ALUController
  ------------------------------------------------------------
  port map (
      clk_i       => Clk,
      rstn_i      => nReset,
      A_i         => A_internal,
      B_i         => B_internal,
      SEL_i       => SEL_internal,
      RES_i       => RES_internal,
      test_done_i => test_done_internal
  ) ;
end architecture TestHarness ;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library UNIMACRO;
use UNIMACRO.vcomponents.all;

entity lab2 is
    Port ( clk   : in  STD_LOGIC;
           reset_n : in  STD_LOGIC;
           -- HDMI outputs
           tmds  : out  STD_LOGIC_VECTOR (3 downto 0);
           tmdsb : out  STD_LOGIC_VECTOR (3 downto 0);
           -- optional board IO
           switch: in  STD_LOGIC_VECTOR(3 downto 0);
           btn   : in  STD_LOGIC_VECTOR(4 downto 0);
           led   : out STD_LOGIC_VECTOR(7 downto 0));
end lab2;

architecture behavior of lab2 is

    -- signals between AXI regs and graphics_datapath
    signal exRow_sig  : std_logic_vector(9 downto 0);
    signal exCol_sig  : std_logic_vector(9 downto 0);
    signal exData_sig : std_logic_vector(15 downto 0);
    signal exWen_sig  : std_logic;
    signal exSel_sig  : std_logic;

    ----------------------------------------------------------------
    -- Component declaration for your AXI slave (Vivado generates it)
    ----------------------------------------------------------------
    component mygraphicsregs_v1_0
        Port (
            -- standard AXI signals
            S_AXI_ACLK    : in  std_logic;
            S_AXI_ARESETN : in  std_logic;
            S_AXI_AWADDR  : in  std_logic_vector(3 downto 0);
            S_AXI_AWVALID : in  std_logic;
            S_AXI_WDATA   : in  std_logic_vector(31 downto 0);
            S_AXI_WSTRB   : in  std_logic_vector(3 downto 0);
            S_AXI_WVALID  : in  std_logic;
            S_AXI_BREADY  : in  std_logic;
            S_AXI_ARADDR  : in  std_logic_vector(3 downto 0);
            S_AXI_ARVALID : in  std_logic;
            S_AXI_RREADY  : in  std_logic;
            S_AXI_AWREADY : out std_logic;
            S_AXI_WREADY  : out std_logic;
            S_AXI_BRESP   : out std_logic_vector(1 downto 0);
            S_AXI_BVALID  : out std_logic;
            S_AXI_ARREADY : out std_logic;
            S_AXI_RDATA   : out std_logic_vector(31 downto 0);
            S_AXI_RRESP   : out std_logic_vector(1 downto 0);
            S_AXI_RVALID  : out std_logic;

            -- custom outputs to graphics_datapath
            exRow_out  : out std_logic_vector(9 downto 0);
            exCol_out  : out std_logic_vector(9 downto 0);
            exData_out : out std_logic_vector(15 downto 0);
            exWen_out  : out std_logic;
            exSel_out  : out std_logic
        );
    end component;

begin

    ----------------------------------------------------------------
    -- Instantiate the graphics datapath
    ----------------------------------------------------------------
    datapath: entity work.graphics_datapath
        port map (
            clk      => clk,
            reset_n  => reset_n,
            tmds     => tmds,
            tmdsb    => tmdsb,

            -- disable FSM test
            fsmCol   => (others => '0'),
            fsmRow   => (others => '0'),
            fsmWen   => '0',
            fsmData  => (others => '0'),

            -- connect to MicroBlaze regs
            exRow    => exRow_sig,
            exCol    => exCol_sig,
            exData   => exData_sig,
            exWen    => exWen_sig,
            exSel    => exSel_sig
        );

    ----------------------------------------------------------------
    -- Instantiate the AXI slave
    ----------------------------------------------------------------
    myregs: mygraphicsregs_v1_0
        port map (
            -- tie AXI bus to the block design (Vivado auto-connects this
            -- when you drop it into the BD with MicroBlaze)
            S_AXI_ACLK    => clk,
            S_AXI_ARESETN => reset_n,

            -- other AXI signals connected in Block Design GUI

            -- connect outputs
            exRow_out  => exRow_sig,
            exCol_out  => exCol_sig,
            exData_out => exData_sig,
            exWen_out  => exWen_sig,
            exSel_out  => exSel_sig
        );

end behavior;


--+----------------------------------------------------------------------------
--|
--| FILENAME      : tdms.vhdl
--| AUTHOR(S)     : Mike Field (original), Claude 4.5 Sonnet (header/fixes)
--| MODIFIED      : 2025-11-05
--| DESCRIPTION   : TMDS 8b/10b encoder for DVI/HDMI output.
--|                 - Fixes out-of-range index on XOR/XNOR chain.
--|                 - Replaces non-VHDL ternary with if statements.
--|                 - Uses local q_m variables to avoid read-after-write.
--|
--+----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TDMS_encoder is
    Port (
        clk     : in  STD_LOGIC;
        data    : in  STD_LOGIC_VECTOR (7 downto 0);
        c       : in  STD_LOGIC_VECTOR (1 downto 0);
        blank   : in  STD_LOGIC;
        encoded : out STD_LOGIC_VECTOR (9 downto 0)
    );
end TDMS_encoder;

architecture Behavioral of TDMS_encoder is
    -- Transition-minimized running XOR/XNOR sequences over input data
    signal xored   : STD_LOGIC_VECTOR (7 downto 0);
    signal xnored  : STD_LOGIC_VECTOR (7 downto 0);

    -- Running disparity (tracks DC balance across symbols)
    signal dc_bias : INTEGER range -32 to 32 := 0;

    -- Utility: count number of '1' bits in a vector
    function count_ones(v : STD_LOGIC_VECTOR) return integer is
        variable cnt : integer := 0;
    begin
        for i in v'range loop
            if v(i) = '1' then cnt := cnt + 1; end if;
        end loop;
        return cnt;
    end function;
begin
    -- Build XOR/XNOR sequences without out-of-range indexing (i=1..7)
    xored(0)  <= data(0);
    xnored(0) <= data(0);

    gen_xor: for i in 1 to 7 generate
        xored(i)  <= xored(i-1) xor  data(i);
        xnored(i) <= xnored(i-1) xnor data(i);
    end generate;

    process(clk)
        variable ones_d    : integer;
        variable ones_qm   : integer;
        variable disp_qm   : integer;
        variable q_m_local     : std_logic_vector(8 downto 0);
        variable q_m_inv_local : std_logic_vector(8 downto 0);
        variable next_bias : integer;
        variable next_enc  : std_logic_vector(9 downto 0);
    begin
        if rising_edge(clk) then
            if blank = '1' then
                -- Control period encoding on Blue channel (c carries VS,HS)
                case c is
                    when "00"   => next_enc := "1101010100";
                    when "01"   => next_enc := "0010101011";
                    when "10"   => next_enc := "0101010100";
                    when others => next_enc := "1010101011";
                end case;
                next_bias := 0;
            else
                -- Transition minimization: choose XOR or XNOR stream
                ones_d := count_ones(data);
                if (ones_d > 4) or ((ones_d = 4) and (data(0) = '0')) then
                    q_m_local     := '0' & xnored;          -- q_m[8]=0
                    q_m_inv_local := '0' & not xnored;
                else
                    q_m_local     := '1' & xored;           -- q_m[8]=1
                    q_m_inv_local := '1' & not xored;
                end if;

                -- Disparity over q_m[7:0]
                ones_qm := count_ones(q_m_local(7 downto 0));
                disp_qm := 2*ones_qm - 8;

                -- DC-balance to build 10-bit TMDS word and update running bias
                if (dc_bias = 0) or (disp_qm = 0) then
                    if q_m_local(8) = '0' then
                        next_enc  := "10" & q_m_inv_local(7 downto 0);
                        next_bias := dc_bias - disp_qm;
                    else
                        next_enc  := "01" & q_m_local(7 downto 0);
                        next_bias := dc_bias + disp_qm;
                    end if;
                elsif ((dc_bias > 0) and (disp_qm > 0)) or
                      ((dc_bias < 0) and (disp_qm < 0)) then
                    next_enc  := '1' & q_m_local(8) & q_m_inv_local(7 downto 0);
                    next_bias := dc_bias - disp_qm;
                    if q_m_local(8) = '0' then
                        next_bias := next_bias - 2;
                    else
                        next_bias := next_bias + 2;
                    end if;
                else
                    next_enc  := '0' & q_m_local;
                    next_bias := dc_bias + disp_qm;
                    if q_m_local(8) = '0' then
                        next_bias := next_bias + 2;
                    else
                        next_bias := next_bias - 2;
                    end if;
                end if;
            end if;

            -- Register outputs
            encoded <= next_enc;
            dc_bias <= next_bias;
        end if;
    end process;

end Behavioral;

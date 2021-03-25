library verilog;
use verilog.vl_types.all;
entity CONV is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        busy            : out    vl_logic;
        ready           : in     vl_logic;
        iaddr           : out    vl_logic_vector(11 downto 0);
        idata           : in     vl_logic_vector(19 downto 0);
        cwr             : out    vl_logic;
        caddr_wr        : out    vl_logic_vector(11 downto 0);
        cdata_wr        : out    vl_logic_vector(19 downto 0);
        crd             : out    vl_logic;
        caddr_rd        : out    vl_logic_vector(11 downto 0);
        cdata_rd        : in     vl_logic_vector(19 downto 0);
        csel            : out    vl_logic_vector(2 downto 0)
    );
end CONV;

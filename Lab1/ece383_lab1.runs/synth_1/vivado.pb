
�
Command: %s
1870*	planAhead2�
�read_checkpoint -auto_incremental -incremental C:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.srcs/utils_1/imports/synth_1/lab1.dcpZ12-2866h px� 
�
;Read reference checkpoint from %s for incremental synthesis3154*	planAhead2Y
WC:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.srcs/utils_1/imports/synth_1/lab1.dcpZ12-5825h px� 
T
-Please ensure there are no constraint changes3725*	planAheadZ12-7989h px� 
`
Command: %s
53*	vivadotcl2/
-synth_design -top lab1 -part xc7a200tsbg484-1Z4-113h px� 
:
Starting synth_design
149*	vivadotclZ4-321h px� 
{
@Attempting to get a license for feature '%s' and/or device '%s'
308*common2
	Synthesis2

xc7a200tZ17-347h px� 
k
0Got license for feature '%s' and/or device '%s'
310*common2
	Synthesis2

xc7a200tZ17-349h px� 
E
Loading part %s157*device2
xc7a200tsbg484-1Z21-403h px� 

VNo compile time benefit to using incremental synthesis; A full resynthesis will be run2353*designutilsZ20-5440h px� 
�
�Flow is switching to default flow due to incremental criteria not met. If you would like to alter this behaviour and have the flow terminate instead, please set the following parameter config_implementation {autoIncr.Synth.RejectBehavior Terminate}2229*designutilsZ20-4379h px� 
o
HMultithreading enabled for synth_design using a maximum of %s processes.4828*oasys2
2Z8-7079h px� 
a
?Launching helper process for spawning children vivado processes4827*oasysZ8-7078h px� 
N
#Helper process launched with PID %s4824*oasys2
17756Z8-7075h px� 
�
%s*synth2{
yStarting RTL Elaboration : Time (s): cpu = 00:00:04 ; elapsed = 00:00:11 . Memory (MB): peak = 1013.617 ; gain = 469.938
h px� 
�
synthesizing module '%s'638*oasys2
lab12g
cC:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.srcs/sources_1/imports/Lab01_cadet_code/lab1.vhdl2
208@Z8-638h px� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
debounce_fsm2W
UC:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.srcs/sources_1/new/debounce_fsm.vhd2
52
debounce_btn02
debounce_fsm2g
cC:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.srcs/sources_1/imports/Lab01_cadet_code/lab1.vhdl2
598@Z8-3491h px� 
�
synthesizing module '%s'638*oasys2
debounce_fsm2Y
UC:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.srcs/sources_1/new/debounce_fsm.vhd2
148@Z8-638h px� 
�
%done synthesizing module '%s' (%s#%s)256*oasys2
debounce_fsm2
02
12Y
UC:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.srcs/sources_1/new/debounce_fsm.vhd2
148@Z8-256h px� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
debounce_fsm2W
UC:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.srcs/sources_1/new/debounce_fsm.vhd2
52
debounce_btn12
debounce_fsm2g
cC:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.srcs/sources_1/imports/Lab01_cadet_code/lab1.vhdl2
608@Z8-3491h px� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
debounce_fsm2W
UC:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.srcs/sources_1/new/debounce_fsm.vhd2
52
debounce_btn22
debounce_fsm2g
cC:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.srcs/sources_1/imports/Lab01_cadet_code/lab1.vhdl2
618@Z8-3491h px� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
debounce_fsm2W
UC:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.srcs/sources_1/new/debounce_fsm.vhd2
52
debounce_btn32
debounce_fsm2g
cC:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.srcs/sources_1/imports/Lab01_cadet_code/lab1.vhdl2
628@Z8-3491h px� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
video2f
dC:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.srcs/sources_1/imports/Lab01_cadet_code/video.vhdl2
102

video_inst2
video2g
cC:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.srcs/sources_1/imports/Lab01_cadet_code/lab1.vhdl2
1098@Z8-3491h px� 
�
synthesizing module '%s'638*oasys2
video2h
dC:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.srcs/sources_1/imports/Lab01_cadet_code/video.vhdl2
258@Z8-638h px� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
	clk_wiz_02~
|C:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.runs/synth_1/.Xil/Vivado-11908-C26-5CG2151GFM/realtime/clk_wiz_0_stub.vhdl2
62
mmcm_adv_inst_display_clocks2
	clk_wiz_02h
dC:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.srcs/sources_1/imports/Lab01_cadet_code/video.vhdl2
718@Z8-3491h px� 
�
synthesizing module '%s'638*oasys2
	clk_wiz_02�
|C:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.runs/synth_1/.Xil/Vivado-11908-C26-5CG2151GFM/realtime/clk_wiz_0_stub.vhdl2
198@Z8-638h px� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
VGA2N
LC:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.srcs/sources_1/new/VGA.vhd2
632

vga_inst2
VGA2h
dC:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.srcs/sources_1/imports/Lab01_cadet_code/video.vhdl2
828@Z8-3491h px� 
�
synthesizing module '%s'638*oasys2
VGA2P
LC:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.srcs/sources_1/new/VGA.vhd2
828@Z8-638h px� 
K
%s
*synth23
1	Parameter g_base bound to: 800 - type: integer 
h p
x
� 
J
%s
*synth22
0	Parameter g_bits bound to: 10 - type: integer 
h p
x
� 
L
%s
*synth24
2	Parameter g_initial bound to: 0 - type: integer 
h p
x
� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
counter_baseN2X
VC:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.srcs/sources_1/new/counter_baseN.vhd2
582
column_counter2
counter_baseN2P
LC:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.srcs/sources_1/new/VGA.vhd2
1438@Z8-3491h px� 
�
synthesizing module '%s'638*oasys2
counter_baseN2Z
VC:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.srcs/sources_1/new/counter_baseN.vhd2
728@Z8-638h px� 
K
%s
*synth23
1	Parameter g_base bound to: 800 - type: integer 
h p
x
� 
J
%s
*synth22
0	Parameter g_bits bound to: 10 - type: integer 
h p
x
� 
L
%s
*synth24
2	Parameter g_initial bound to: 0 - type: integer 
h p
x
� 
�
%done synthesizing module '%s' (%s#%s)256*oasys2
counter_baseN2
02
12Z
VC:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.srcs/sources_1/new/counter_baseN.vhd2
728@Z8-256h px� 
K
%s
*synth23
1	Parameter g_base bound to: 525 - type: integer 
h p
x
� 
J
%s
*synth22
0	Parameter g_bits bound to: 10 - type: integer 
h p
x
� 
N
%s
*synth26
4	Parameter g_initial bound to: 520 - type: integer 
h p
x
� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
counter_baseN2X
VC:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.srcs/sources_1/new/counter_baseN.vhd2
582
row_counter2
counter_baseN2P
LC:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.srcs/sources_1/new/VGA.vhd2
1568@Z8-3491h px� 
�
synthesizing module '%s'638*oasys2
counter_baseN__parameterized12Z
VC:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.srcs/sources_1/new/counter_baseN.vhd2
728@Z8-638h px� 
K
%s
*synth23
1	Parameter g_base bound to: 525 - type: integer 
h p
x
� 
J
%s
*synth22
0	Parameter g_bits bound to: 10 - type: integer 
h p
x
� 
N
%s
*synth26
4	Parameter g_initial bound to: 520 - type: integer 
h p
x
� 
�
%done synthesizing module '%s' (%s#%s)256*oasys2
counter_baseN__parameterized12
02
12Z
VC:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.srcs/sources_1/new/counter_baseN.vhd2
728@Z8-256h px� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
synch_blank2V
TC:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.srcs/sources_1/new/synch_blank.vhd2
592
synch_blank_inst2
synch_blank2P
LC:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.srcs/sources_1/new/VGA.vhd2
1708@Z8-3491h px� 
�
synthesizing module '%s'638*oasys2
synch_blank2X
TC:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.srcs/sources_1/new/synch_blank.vhd2
708@Z8-638h px� 
�
%done synthesizing module '%s' (%s#%s)256*oasys2
synch_blank2
02
12X
TC:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.srcs/sources_1/new/synch_blank.vhd2
708@Z8-256h px� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
	scopeFace2T
RC:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.srcs/sources_1/new/scopeFace.vhd2
272
scopeFace_inst2
	scopeFace2P
LC:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.srcs/sources_1/new/VGA.vhd2
1838@Z8-3491h px� 
�
synthesizing module '%s'638*oasys2
	scopeFace2V
RC:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.srcs/sources_1/new/scopeFace.vhd2
418@Z8-638h px� 
�
%done synthesizing module '%s' (%s#%s)256*oasys2
	scopeFace2
02
12V
RC:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.srcs/sources_1/new/scopeFace.vhd2
418@Z8-256h px� 
�
%done synthesizing module '%s' (%s#%s)256*oasys2
VGA2
02
12P
LC:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.srcs/sources_1/new/VGA.vhd2
828@Z8-256h px� 
�
synthesizing module '%s'638*oasys2
dvid2g
cC:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.srcs/sources_1/imports/Lab01_cadet_code/dvid.vhdl2
318@Z8-638h px� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
TDMS_encoder2e
cC:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.srcs/sources_1/imports/Lab01_cadet_code/tdms.vhdl2
142
TDMS_encoder_red2
TDMS_encoder2g
cC:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.srcs/sources_1/imports/Lab01_cadet_code/dvid.vhdl2
568@Z8-3491h px� 
�
synthesizing module '%s'638*oasys2
TDMS_encoder2g
cC:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.srcs/sources_1/imports/Lab01_cadet_code/tdms.vhdl2
228@Z8-638h px� 
�
%done synthesizing module '%s' (%s#%s)256*oasys2
TDMS_encoder2
02
12g
cC:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.srcs/sources_1/imports/Lab01_cadet_code/tdms.vhdl2
228@Z8-256h px� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
TDMS_encoder2e
cC:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.srcs/sources_1/imports/Lab01_cadet_code/tdms.vhdl2
142
TDMS_encoder_green2
TDMS_encoder2g
cC:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.srcs/sources_1/imports/Lab01_cadet_code/dvid.vhdl2
578@Z8-3491h px� 
�
Hmodule '%s' declared at '%s:%s' bound to instance '%s' of component '%s'3392*oasys2
TDMS_encoder2e
cC:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.srcs/sources_1/imports/Lab01_cadet_code/tdms.vhdl2
142
TDMS_encoder_blue2
TDMS_encoder2g
cC:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.srcs/sources_1/imports/Lab01_cadet_code/dvid.vhdl2
588@Z8-3491h px� 
P
%s
*synth28
6	Parameter DDR_ALIGNMENT bound to: C0 - type: string 
h p
x
� 
:
%s
*synth2"
 	Parameter INIT bound to: 1'b0 
h p
x
� 
L
%s
*synth24
2	Parameter SRTYPE bound to: ASYNC - type: string 
h p
x
� 
�
,binding component instance '%s' to cell '%s'113*oasys2
	ODDR2_red2
ODDR22g
cC:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.srcs/sources_1/imports/Lab01_cadet_code/dvid.vhdl2
608@Z8-113h px� 
P
%s
*synth28
6	Parameter DDR_ALIGNMENT bound to: C0 - type: string 
h p
x
� 
:
%s
*synth2"
 	Parameter INIT bound to: 1'b0 
h p
x
� 
L
%s
*synth24
2	Parameter SRTYPE bound to: ASYNC - type: string 
h p
x
� 
�
,binding component instance '%s' to cell '%s'113*oasys2
ODDR2_green2
ODDR22g
cC:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.srcs/sources_1/imports/Lab01_cadet_code/dvid.vhdl2
638@Z8-113h px� 
P
%s
*synth28
6	Parameter DDR_ALIGNMENT bound to: C0 - type: string 
h p
x
� 
:
%s
*synth2"
 	Parameter INIT bound to: 1'b0 
h p
x
� 
L
%s
*synth24
2	Parameter SRTYPE bound to: ASYNC - type: string 
h p
x
� 
�
,binding component instance '%s' to cell '%s'113*oasys2

ODDR2_blue2
ODDR22g
cC:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.srcs/sources_1/imports/Lab01_cadet_code/dvid.vhdl2
668@Z8-113h px� 
P
%s
*synth28
6	Parameter DDR_ALIGNMENT bound to: C0 - type: string 
h p
x
� 
:
%s
*synth2"
 	Parameter INIT bound to: 1'b0 
h p
x
� 
L
%s
*synth24
2	Parameter SRTYPE bound to: ASYNC - type: string 
h p
x
� 
�
,binding component instance '%s' to cell '%s'113*oasys2
ODDR2_clock2
ODDR22g
cC:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.srcs/sources_1/imports/Lab01_cadet_code/dvid.vhdl2
698@Z8-113h px� 
�
%done synthesizing module '%s' (%s#%s)256*oasys2
dvid2
02
12g
cC:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.srcs/sources_1/imports/Lab01_cadet_code/dvid.vhdl2
318@Z8-256h px� 
�
,binding component instance '%s' to cell '%s'113*oasys2
OBUFDS_blue2
OBUFDS2h
dC:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.srcs/sources_1/imports/Lab01_cadet_code/video.vhdl2
1248@Z8-113h px� 
�
,binding component instance '%s' to cell '%s'113*oasys2

OBUFDS_red2
OBUFDS2h
dC:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.srcs/sources_1/imports/Lab01_cadet_code/video.vhdl2
1268@Z8-113h px� 
�
,binding component instance '%s' to cell '%s'113*oasys2
OBUFDS_green2
OBUFDS2h
dC:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.srcs/sources_1/imports/Lab01_cadet_code/video.vhdl2
1288@Z8-113h px� 
�
,binding component instance '%s' to cell '%s'113*oasys2
OBUFDS_clock2
OBUFDS2h
dC:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.srcs/sources_1/imports/Lab01_cadet_code/video.vhdl2
1308@Z8-113h px� 
�
%done synthesizing module '%s' (%s#%s)256*oasys2
video2
02
12h
dC:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.srcs/sources_1/imports/Lab01_cadet_code/video.vhdl2
258@Z8-256h px� 
�
%done synthesizing module '%s' (%s#%s)256*oasys2
lab12
02
12g
cC:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.srcs/sources_1/imports/Lab01_cadet_code/lab1.vhdl2
208@Z8-256h px� 
s
9Port %s in module %s is either unconnected or has no load4866*oasys2
i_clk2
synch_blankZ8-7129h px� 
w
9Port %s in module %s is either unconnected or has no load4866*oasys2
	i_reset_n2
synch_blankZ8-7129h px� 
m
9Port %s in module %s is either unconnected or has no load4866*oasys2
btn[4]2
lab1Z8-7129h px� 
�
%s*synth2{
yFinished RTL Elaboration : Time (s): cpu = 00:00:05 ; elapsed = 00:00:14 . Memory (MB): peak = 1123.215 ; gain = 579.535
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
;
%s
*synth2#
!Start Handling Custom Attributes
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Handling Custom Attributes : Time (s): cpu = 00:00:05 ; elapsed = 00:00:14 . Memory (MB): peak = 1123.215 ; gain = 579.535
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished RTL Optimization Phase 1 : Time (s): cpu = 00:00:05 ; elapsed = 00:00:14 . Memory (MB): peak = 1123.215 ; gain = 579.535
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2
Netlist sorting complete. 2

00:00:002
00:00:00.0162

1123.2152
0.000Z17-268h px� 
S
-Analyzing %s Unisim elements for replacement
17*netlist2
8Z29-17h px� 
�
�Pin '%s' on instance '%s' of cell type '%s' does not have an equivalent function on the new cell type '%s'. Net '%s' that is connected to this pin will not be connected to the replacement instance.326*netlist2
C12!
video_inst/dvid_inst/ODDR2_blue2
ODDR22
ODDR2
clk_nZ29-151h px� 
�
�Pin '%s' on instance '%s' of cell type '%s' does not have an equivalent function on the new cell type '%s'. Net '%s' that is connected to this pin will not be connected to the replacement instance.326*netlist2
C12"
 video_inst/dvid_inst/ODDR2_clock2
ODDR22
ODDR2
clk_nZ29-151h px� 
�
�Pin '%s' on instance '%s' of cell type '%s' does not have an equivalent function on the new cell type '%s'. Net '%s' that is connected to this pin will not be connected to the replacement instance.326*netlist2
C12"
 video_inst/dvid_inst/ODDR2_green2
ODDR22
ODDR2
clk_nZ29-151h px� 
�
�Pin '%s' on instance '%s' of cell type '%s' does not have an equivalent function on the new cell type '%s'. Net '%s' that is connected to this pin will not be connected to the replacement instance.326*netlist2
C12 
video_inst/dvid_inst/ODDR2_red2
ODDR22
ODDR2
clk_nZ29-151h px� 
X
2Unisim Transformation completed in %s CPU seconds
28*netlist2
0Z29-28h px� 
K
)Preparing netlist for logic optimization
349*projectZ1-570h px� 
>

Processing XDC Constraints
244*projectZ1-262h px� 
=
Initializing timing engine
348*projectZ1-569h px� 
�
$Parsing XDC File [%s] for cell '%s'
848*designutils2s
oc:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.gen/sources_1/ip/clk_wiz_0/clk_wiz_0/clk_wiz_0_in_context.xdc2+
'video_inst/mmcm_adv_inst_display_clocks	8Z20-848h px� 
�
-Finished Parsing XDC File [%s] for cell '%s'
847*designutils2s
oc:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.gen/sources_1/ip/clk_wiz_0/clk_wiz_0/clk_wiz_0_in_context.xdc2+
'video_inst/mmcm_adv_inst_display_clocks	8Z20-847h px� 
�
Parsing XDC File [%s]
179*designutils2f
bC:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.srcs/constrs_1/imports/Lab01_cadet_code/Lab1.xdc8Z20-179h px� 
�
Finished Parsing XDC File [%s]
178*designutils2f
bC:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.srcs/constrs_1/imports/Lab01_cadet_code/Lab1.xdc8Z20-178h px� 
�
�Implementation specific constraints were found while reading constraint file [%s]. These constraints will be ignored for synthesis but will be used in implementation. Impacted constraints are listed in the file [%s].
233*project2d
bC:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.srcs/constrs_1/imports/Lab01_cadet_code/Lab1.xdc2
.Xil/lab1_propImpl.xdcZ1-236h px� 
H
&Completed Processing XDC Constraints

245*projectZ1-263h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2
Netlist sorting complete. 2

00:00:002
00:00:00.0012

1216.7152
0.000Z17-268h px� 
�
!Unisim Transformation Summary:
%s111*project2�
�  A total of 8 instances were transformed.
  OBUFDS => OBUFDS_DUAL_BUF (INV, OBUFDS(x2)): 4 instances
  ODDR2 => ODDR: 4 instances
Z1-111h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2"
 Constraint Validation Runtime : 2

00:00:002
00:00:00.0162

1216.7152
0.000Z17-268h px� 

VNo compile time benefit to using incremental synthesis; A full resynthesis will be run2353*designutilsZ20-5440h px� 
�
�Flow is switching to default flow due to incremental criteria not met. If you would like to alter this behaviour and have the flow terminate instead, please set the following parameter config_implementation {autoIncr.Synth.RejectBehavior Terminate}2229*designutilsZ20-4379h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
Finished Constraint Validation : Time (s): cpu = 00:00:11 ; elapsed = 00:00:26 . Memory (MB): peak = 1216.715 ; gain = 673.035
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
D
%s
*synth2,
*Start Loading Part and Timing Information
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
9
%s
*synth2!
Loading part: xc7a200tsbg484-1
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Loading Part and Timing Information : Time (s): cpu = 00:00:11 ; elapsed = 00:00:26 . Memory (MB): peak = 1216.715 ; gain = 673.035
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
H
%s
*synth20
.Start Applying 'set_property' XDC Constraints
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished applying 'set_property' XDC Constraints : Time (s): cpu = 00:00:11 ; elapsed = 00:00:26 . Memory (MB): peak = 1216.715 ; gain = 673.035
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
x
3inferred FSM for state register '%s' in module '%s'802*oasys2
current_state_reg2
debounce_fsmZ8-802h px� 
~
%s
*synth2f
d---------------------------------------------------------------------------------------------------
h p
x
� 
z
%s
*synth2b
`                   State |                     New Encoding |                Previous Encoding 
h p
x
� 
~
%s
*synth2f
d---------------------------------------------------------------------------------------------------
h p
x
� 
y
%s
*synth2a
_                stable_0 |                               01 |                               00
h p
x
� 
y
%s
*synth2a
_                  wait_1 |                               11 |                               11
h p
x
� 
y
%s
*synth2a
_                stable_1 |                               10 |                               10
h p
x
� 
y
%s
*synth2a
_                  wait_0 |                               00 |                               01
h p
x
� 
~
%s
*synth2f
d---------------------------------------------------------------------------------------------------
h p
x
� 
�
Gencoded FSM with state register '%s' using encoding '%s' in module '%s'3353*oasys2
current_state_reg2

sequential2
debounce_fsmZ8-3354h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished RTL Optimization Phase 2 : Time (s): cpu = 00:00:11 ; elapsed = 00:00:27 . Memory (MB): peak = 1216.715 ; gain = 673.035
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
:
%s
*synth2"
 Start RTL Component Statistics 
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
9
%s
*synth2!
Detailed RTL Component Info : 
h p
x
� 
(
%s
*synth2
+---Adders : 
h p
x
� 
F
%s
*synth2.
,	   2 Input   20 Bit       Adders := 5     
h p
x
� 
F
%s
*synth2.
,	   2 Input   10 Bit       Adders := 9     
h p
x
� 
F
%s
*synth2.
,	   3 Input   10 Bit       Adders := 4     
h p
x
� 
F
%s
*synth2.
,	   8 Input    4 Bit       Adders := 3     
h p
x
� 
F
%s
*synth2.
,	   9 Input    4 Bit       Adders := 3     
h p
x
� 
F
%s
*synth2.
,	  11 Input    4 Bit       Adders := 3     
h p
x
� 
F
%s
*synth2.
,	   4 Input    4 Bit       Adders := 3     
h p
x
� 
F
%s
*synth2.
,	  10 Input    4 Bit       Adders := 3     
h p
x
� 
&
%s
*synth2
+---XORs : 
h p
x
� 
H
%s
*synth20
.	   2 Input      1 Bit         XORs := 42    
h p
x
� 
+
%s
*synth2
+---Registers : 
h p
x
� 
H
%s
*synth20
.	               20 Bit    Registers := 1     
h p
x
� 
H
%s
*synth20
.	               10 Bit    Registers := 14    
h p
x
� 
H
%s
*synth20
.	                4 Bit    Registers := 3     
h p
x
� 
H
%s
*synth20
.	                1 Bit    Registers := 2     
h p
x
� 
'
%s
*synth2
+---Muxes : 
h p
x
� 
F
%s
*synth2.
,	   5 Input   10 Bit        Muxes := 6     
h p
x
� 
F
%s
*synth2.
,	   4 Input   10 Bit        Muxes := 3     
h p
x
� 
F
%s
*synth2.
,	   2 Input   10 Bit        Muxes := 9     
h p
x
� 
F
%s
*synth2.
,	   2 Input    9 Bit        Muxes := 6     
h p
x
� 
F
%s
*synth2.
,	   2 Input    4 Bit        Muxes := 9     
h p
x
� 
F
%s
*synth2.
,	   4 Input    2 Bit        Muxes := 4     
h p
x
� 
F
%s
*synth2.
,	   2 Input    2 Bit        Muxes := 5     
h p
x
� 
F
%s
*synth2.
,	   2 Input    1 Bit        Muxes := 11    
h p
x
� 
F
%s
*synth2.
,	   4 Input    1 Bit        Muxes := 4     
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
=
%s
*synth2%
#Finished RTL Component Statistics 
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
6
%s
*synth2
Start Part Resource Summary
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
s
%s
*synth2[
YPart Resources:
DSPs: 740 (col length:100)
BRAMs: 730 (col length: RAMB18 100 RAMB36 50)
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
9
%s
*synth2!
Finished Part Resource Summary
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
E
%s
*synth2-
+Start Cross Boundary and Area Optimization
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
H
&Parallel synthesis criteria is not met4829*oasysZ8-7080h px� 
m
9Port %s in module %s is either unconnected or has no load4866*oasys2
btn[4]2
lab1Z8-7129h px� 
�
ESequential element (%s) is unused and will be removed from module %s.3332*oasys23
1debounce_btn0/FSM_sequential_current_state_reg[1]2
lab1Z8-3332h px� 
�
ESequential element (%s) is unused and will be removed from module %s.3332*oasys23
1debounce_btn0/FSM_sequential_current_state_reg[0]2
lab1Z8-3332h px� 
�
ESequential element (%s) is unused and will be removed from module %s.3332*oasys23
1debounce_btn1/FSM_sequential_current_state_reg[1]2
lab1Z8-3332h px� 
�
ESequential element (%s) is unused and will be removed from module %s.3332*oasys23
1debounce_btn1/FSM_sequential_current_state_reg[0]2
lab1Z8-3332h px� 
�
ESequential element (%s) is unused and will be removed from module %s.3332*oasys23
1debounce_btn2/FSM_sequential_current_state_reg[1]2
lab1Z8-3332h px� 
�
ESequential element (%s) is unused and will be removed from module %s.3332*oasys23
1debounce_btn2/FSM_sequential_current_state_reg[0]2
lab1Z8-3332h px� 
�
ESequential element (%s) is unused and will be removed from module %s.3332*oasys23
1debounce_btn3/FSM_sequential_current_state_reg[1]2
lab1Z8-3332h px� 
�
ESequential element (%s) is unused and will be removed from module %s.3332*oasys23
1debounce_btn3/FSM_sequential_current_state_reg[0]2
lab1Z8-3332h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Cross Boundary and Area Optimization : Time (s): cpu = 00:00:27 ; elapsed = 00:01:02 . Memory (MB): peak = 1445.789 ; gain = 902.109
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
@
%s
*synth2(
&Start Applying XDC Timing Constraints
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Applying XDC Timing Constraints : Time (s): cpu = 00:00:32 ; elapsed = 00:01:11 . Memory (MB): peak = 1445.789 ; gain = 902.109
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
4
%s
*synth2
Start Timing Optimization
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2
}Finished Timing Optimization : Time (s): cpu = 00:00:35 ; elapsed = 00:01:17 . Memory (MB): peak = 1445.789 ; gain = 902.109
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
3
%s
*synth2
Start Technology Mapping
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2~
|Finished Technology Mapping : Time (s): cpu = 00:00:35 ; elapsed = 00:01:18 . Memory (MB): peak = 1453.703 ; gain = 910.023
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
-
%s
*synth2
Start IO Insertion
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
?
%s
*synth2'
%Start Flattening Before IO Insertion
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
B
%s
*synth2*
(Finished Flattening Before IO Insertion
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
6
%s
*synth2
Start Final Netlist Cleanup
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
9
%s
*synth2!
Finished Final Netlist Cleanup
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2y
wFinished IO Insertion : Time (s): cpu = 00:00:37 ; elapsed = 00:01:23 . Memory (MB): peak = 1605.250 ; gain = 1061.570
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
=
%s
*synth2%
#Start Renaming Generated Instances
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Renaming Generated Instances : Time (s): cpu = 00:00:37 ; elapsed = 00:01:23 . Memory (MB): peak = 1605.250 ; gain = 1061.570
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
:
%s
*synth2"
 Start Rebuilding User Hierarchy
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Rebuilding User Hierarchy : Time (s): cpu = 00:00:37 ; elapsed = 00:01:23 . Memory (MB): peak = 1605.250 ; gain = 1061.570
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
9
%s
*synth2!
Start Renaming Generated Ports
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Renaming Generated Ports : Time (s): cpu = 00:00:37 ; elapsed = 00:01:23 . Memory (MB): peak = 1605.250 ; gain = 1061.570
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
;
%s
*synth2#
!Start Handling Custom Attributes
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Handling Custom Attributes : Time (s): cpu = 00:00:37 ; elapsed = 00:01:23 . Memory (MB): peak = 1605.250 ; gain = 1061.570
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
8
%s
*synth2 
Start Renaming Generated Nets
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Renaming Generated Nets : Time (s): cpu = 00:00:37 ; elapsed = 00:01:23 . Memory (MB): peak = 1605.250 ; gain = 1061.570
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
9
%s
*synth2!
Start Writing Synthesis Report
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
/
%s
*synth2

Report BlackBoxes: 
h p
x
� 
=
%s
*synth2%
#+------+--------------+----------+
h p
x
� 
=
%s
*synth2%
#|      |BlackBox name |Instances |
h p
x
� 
=
%s
*synth2%
#+------+--------------+----------+
h p
x
� 
=
%s
*synth2%
#|1     |clk_wiz_0     |         1|
h p
x
� 
=
%s
*synth2%
#+------+--------------+----------+
h p
x
� 
/
%s*synth2

Report Cell Usage: 
h px� 
:
%s*synth2"
 +------+---------------+------+
h px� 
:
%s*synth2"
 |      |Cell           |Count |
h px� 
:
%s*synth2"
 +------+---------------+------+
h px� 
:
%s*synth2"
 |1     |clk_wiz_0_bbox |     1|
h px� 
:
%s*synth2"
 |2     |CARRY4         |    44|
h px� 
:
%s*synth2"
 |3     |LUT1           |    15|
h px� 
:
%s*synth2"
 |4     |LUT2           |   104|
h px� 
:
%s*synth2"
 |5     |LUT3           |    59|
h px� 
:
%s*synth2"
 |6     |LUT4           |   102|
h px� 
:
%s*synth2"
 |7     |LUT5           |    58|
h px� 
:
%s*synth2"
 |8     |LUT6           |   149|
h px� 
:
%s*synth2"
 |9     |ODDR2          |     4|
h px� 
:
%s*synth2"
 |10    |FDCE           |    41|
h px� 
:
%s*synth2"
 |11    |FDRE           |   111|
h px� 
:
%s*synth2"
 |12    |FDSE           |     4|
h px� 
:
%s*synth2"
 |13    |IBUF           |     7|
h px� 
:
%s*synth2"
 |14    |OBUFDS         |     4|
h px� 
:
%s*synth2"
 +------+---------------+------+
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Writing Synthesis Report : Time (s): cpu = 00:00:37 ; elapsed = 00:01:23 . Memory (MB): peak = 1605.250 ; gain = 1061.570
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
a
%s
*synth2I
GSynthesis finished with 0 errors, 0 critical warnings and 10 warnings.
h p
x
� 
�
%s
*synth2�
Synthesis Optimization Runtime : Time (s): cpu = 00:00:30 ; elapsed = 00:01:19 . Memory (MB): peak = 1605.250 ; gain = 968.070
h p
x
� 
�
%s
*synth2�
�Synthesis Optimization Complete : Time (s): cpu = 00:00:37 ; elapsed = 00:01:23 . Memory (MB): peak = 1605.250 ; gain = 1061.570
h p
x
� 
B
 Translating synthesized netlist
350*projectZ1-571h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2
Netlist sorting complete. 2

00:00:002
00:00:00.0202

1605.2502
0.000Z17-268h px� 
T
-Analyzing %s Unisim elements for replacement
17*netlist2
52Z29-17h px� 
�
�Pin '%s' on instance '%s' of cell type '%s' does not have an equivalent function on the new cell type '%s'. Net '%s' that is connected to this pin will not be connected to the replacement instance.326*netlist2
C12!
video_inst/dvid_inst/ODDR2_blue2
ODDR22
ODDR2

clk_out3Z29-151h px� 
�
�Pin '%s' on instance '%s' of cell type '%s' does not have an equivalent function on the new cell type '%s'. Net '%s' that is connected to this pin will not be connected to the replacement instance.326*netlist2
C12"
 video_inst/dvid_inst/ODDR2_clock2
ODDR22
ODDR2

clk_out3Z29-151h px� 
�
�Pin '%s' on instance '%s' of cell type '%s' does not have an equivalent function on the new cell type '%s'. Net '%s' that is connected to this pin will not be connected to the replacement instance.326*netlist2
C12"
 video_inst/dvid_inst/ODDR2_green2
ODDR22
ODDR2

clk_out3Z29-151h px� 
�
�Pin '%s' on instance '%s' of cell type '%s' does not have an equivalent function on the new cell type '%s'. Net '%s' that is connected to this pin will not be connected to the replacement instance.326*netlist2
C12 
video_inst/dvid_inst/ODDR2_red2
ODDR22
ODDR2

clk_out3Z29-151h px� 
X
2Unisim Transformation completed in %s CPU seconds
28*netlist2
0Z29-28h px� 
K
)Preparing netlist for logic optimization
349*projectZ1-570h px� 
U
1Inserted %s IBUFs to IO ports without IO buffers.100*opt2
1Z31-140h px� 
Q
)Pushed %s inverter(s) to %s load pin(s).
98*opt2
02
0Z31-138h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2
Netlist sorting complete. 2

00:00:002

00:00:002

1620.6992
0.000Z17-268h px� 
�
!Unisim Transformation Summary:
%s111*project2�
�  A total of 8 instances were transformed.
  OBUFDS => OBUFDS_DUAL_BUF (INV, OBUFDS(x2)): 4 instances
  ODDR2 => ODDR: 4 instances
Z1-111h px� 
V
%Synth Design complete | Checksum: %s
562*	vivadotcl2

4810b80eZ4-1430h px� 
C
Releasing license: %s
83*common2
	SynthesisZ17-83h px� 

G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
692
212
02
0Z4-41h px� 
L
%s completed successfully
29*	vivadotcl2
synth_designZ4-42h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2
synth_design: 2

00:00:402

00:01:512

1620.6992

1316.730Z17-268h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2
Write ShapeDB Complete: 2

00:00:002
00:00:00.0062

1620.6992
0.000Z17-268h px� 
�
 The %s '%s' has been generated.
621*common2

checkpoint2I
GC:/Users/Dustin.Mock/code/ece383/Lab1/ece383_lab1.runs/synth_1/lab1.dcpZ17-1381h px� 
�
Executing command : %s
56330*	planAhead2S
Qreport_utilization -file lab1_utilization_synth.rpt -pb lab1_utilization_synth.pbZ12-24828h px� 
\
Exiting %s at %s...
206*common2
Vivado2
Wed Feb 19 08:19:30 2025Z17-206h px� 


End Record
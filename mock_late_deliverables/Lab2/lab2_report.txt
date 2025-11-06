# **Lab 2 — Oscilloscope with BRAM & Triggering**

## Overview

In Lab 2, I expanded the Lab 1 video pipeline (VGA/HDMI, ScopeFace, and Synchronize) into a working oscilloscope. Audio data from the Audio Codec is captured and stored in BRAM, and triggers were implemented so live audio from the headphone jack appears stationary on-screen. As the trigger voltage is adjusted with button presses, the audio stream triggers at that voltage and looks stationary.

Key upgrades from Lab 1:

* Integrated Audio Codec input and BRAM buffering
* Implemented trigger voltage (and attempted trigger time)
* Added channel enable/disable and external/internal data selection (`sim_live`)
* Connected FSM control to the datapath with status/control words

---

## Modules

### Lab 2 (Top)

* **Purpose:** Top-level file.
* **Inputs:** `clk`, `reset_n`, `ctrl`, `ac_adc_sdata (in)`, `scl`, `sda`
* **Outputs:** `ac_mclk`, `ac_bclk`, `ac_lrclk`
* **Behavior:** Connects the finite state machine to the datapath.

### Lab 2 Datapath

* **Purpose:** Take input from the computer audio jack and output a voltage to display on a monitor through HDMI.
* **Inputs:**
  `clk`, `reset_n`, `ctrl`, `ac_adc_sdata (in)`, `scl`, `sda`, `sim_live`, `exWrAddr`, `exWen`, `exSel`, `ch1_enable`, `ch2_enable`, `flagClear`, `exRBus`, `exLBus`, `cw(2 downto 0)`
* **Outputs:**
  `ac_bclk`, `ac_lrclk`, `scl`, `sda`, `ac_mclk`, `sw(2 downto 0)`, `L_Bus_Out`, `R_Bus_Out`, `tr_volt`, `tr_time`, `flagQ`, `tmds`, `tmdsb`, `ac_dac_sdata (out)`
* **Behavior:** Uses control words and switches to direct the Audio Codec Wrapper and BRAM to write data for the monitor. Selects internal or external data via `sim_live`. Can enable/disable channels and adjust trigger voltage/time. Provides a status word to the Control Unit.

### Lab 2 Control Unit (FSM)

* **Purpose:** Direct the datapath through states via a control word.
* **Inputs:** `clk`, `reset_n`, `sw(2 downto 0)`
* **Outputs:** `cw(2 downto 0)`
* **Behavior:** Generates control words based on current state and status inputs from the datapath.

### Flag Register

* **Purpose:** Allows the top module to see when `readyReady` (`sw(1)`) is set.
* **Inputs:** `clk`, `reset_n`, `readyReady`, `flagClear`
* **Outputs:** `flagQ`
* **Behavior:** On a clock edge, if `readyReady` is set, `flagQ` becomes `1`. When `flagClear` is set, `flagQ` becomes `0`.

### `wrAddrMux`

* **Purpose:** Provide an address to the BRAM.
* **Inputs:** `exSel` (select), `writeCntr`, `exWrAddr`
* **Outputs:** `w_wrAddrMux`
* **Behavior:** `w_wrAddrMux` = `writeCntr` when `exSel` (switch(2)) is `1`; `exWrAddr` when `exSel` is `0`.

### `DinMux` (Left and Right)

* **Purpose:** Provide BRAM data-in for left/right memories to display on HDMI.
* **Inputs:** `exXBus`, `w_Xbus_out`, `exSel` (select)
* **Outputs:** `w_DinMuxX`
* **Behavior:** `w_DinMuxX` = `exLBus` when `exSel` is `1`; `w_Xbus_out` when `exSel` is `0`.

### Memory Counter

* **Purpose:** Increment memory addresses for `wrAddrMux`.
* **Inputs:** `cw(1:0)`
* **Outputs:** `writeCntr`
* **Behavior:** On each clock, reads the control word and either resets, increments, or holds.

### `wrEnbMux`

* **Purpose:** Provide the enable bit to the BRAM.
* **Inputs:** `cw(2)`, `exWen`, `exSel` (select)
* **Outputs:** `w_wrEnbMux`
* **Behavior:** `w_wrEnbMux` = `exWen` when `exSel` is `1`; `cw(2)` when `exSel` is `0`.

---

## Testing & Demos

To showcase functionality, I ran the design on a monitor and adjusted the trigger voltage up/down, verifying the channels triggered correctly and appeared stationary. For Gate Check 3, I checked whether data scrolled when toggling `sim_live`. I knew the lab was working when changing the input frequency from the frequency generator still resulted in a stationary display on a valid trigger.

> **Note:** I was not able to get `triggerTime` to have any functionality.

---

## Challenges & Lessons Learned

* **Signed vs. Unsigned:** I ran into issues converting signed audio data to the unsigned range needed by the display. I mistakenly assumed type casting would simply reinterpret bits; in reality, it changes the value. A better VHDL strategy (akin to “casting the address” in C rather than the data) would have avoided this.
* **Debouncing & UI Feel:** I believe debouncing was working by the end. However, my button implementation differed from most examples, leading to smooth motion but not discrete “press” granularity—i.e., holding the button continuously scrolled by one pixel per time division.

---

## Milestones

| Milestone              | Date      | Status                                                                     |
| ---------------------- | --------- | -------------------------------------------------------------------------- |
| Gate Check 1           | 2/11/2025 | Fully achieved in class demo                                               |
| Gate Check 2           | 3/23/2025 | Fully achieved in class demo                                               |
| Gate Check 3           | 4/13/2025 | Fully achieved (did not demo by itself)                                    |
| Required Functionality | 9/15/2025 | Fully achieved (EI demo)                                                   |
| B-Level Functionality  | 9/15/2025 | Fully achieved (EI demo)                                                   |
| A-Level Functionality  | 9/15/2025 | Fully achieved (Trigger time not required). Debouncing should be reviewed. |

---

## Gate Check 1 — BRAM Read-Out with Lab 1 Video [5 Points]

**Goal (by end of Day 1; submit by Day 2):**
Start a Lab 2 Vivado project; import Lab 1’s `Video`, `VGA`, `ScopeFace`, `dvid`, and `tmds` into Lab 2. Verify ScopeFace reads left/right BRAM and displays on the monitor using the two initialized BRAM components in `lab2_datapath.vhdl`. Audio Wrapper and Control Unit aren’t required yet.

**Implementation Notes:**

* Implement `Video` to read left/right BRAM and drive Channel 1/2 when `readL`/`readR` equals the current `row`.
* Re-implement the Clocking Wizard in Lab 2 to eliminate undriven outputs at top level.
* Copy over ScopeFace and button processes from Lab 1.
* You may need another Clocking Wizard for the Audio Codec Wrapper inside the Datapath to generate the bit stream.

**How to read continuously from BRAM:**

* Put the requested column address on `RDADDR` (the column from `Video`).
* Keep `RDEN <= '1'`.
* The BRAM outputs the 16-bit value at `DO`; compare `DO` with the current `row`. If equal, assert `ch1 <= '1'` (and similarly for `ch2`).

**Centering & Scaling Hint:**

* Scope DC center is row `220`. If you grab the upper 10 bits from BRAM `DO`, its DC center is `512`. Offset `Δ = 512 - 220 = 292`. Update the comparator logic accordingly (e.g., compare `ReadL` to `row ± Δ`).

**Progressive Tests (expected images):**

* ![](../_images/Lab02_GC1-1.png)
* ![](../_images/Lab02_GC1-2.png)
* ![](../_images/Lab02_GC1-3.png)

**Deliverables:**

* Demo live or upload an image to Teams.
* Tag repo: `Lab2_GC1`.

---

## Gate Check 2 — Simulated Audio to BRAM [5 Points]

**Goal (by end of Day 2; submit by Day 3):**
Connect the BRAM Address Counter to left/right BRAMs; instantiate the Audio Codec Wrapper in **simulation mode** (`sim_live = '0'`); add your Control Unit so simulated audio is written to BRAM and plotted. Without trigger, the waveform may scroll; if the counter and FSM write the same 1024 values repeatedly, it can appear stationary. To force scrolling, roll over at a smaller value (e.g., 640). Consider initializing the counter at column 20 (first visible scope column).

**How to write a sample to BRAM:**

1. Set `WE => "11"` (byte enables; not otherwise used here).
2. Put the address on `WRADDR` (from the counter).
3. Put the converted 16-bit sample on `DI`.
4. Assert `WREN = '1'` via a CW from the FSM.

**FSM Flow Suggestion:**

* Reset counter → wait for `Ready` → save sample (`WE='1'`) → increment counter → check done (via status word) → repeat or reset.

**Conversion Reminder:**

* Convert signed audio from the Audio Codec Wrapper to the unsigned range needed for the monitor.
* Recenter the DC value to row 220.
* If stuck, write a Testbench (see example testbenches in the zip).

**Deliverables:**

* Demo live, or upload image (stationary) / video (scrolling) to Teams.
* Tag repo: `Lab2_GC2`.

---

## Gate Check 3 — Live Audio Input [5 Points]

**Goal (by end of Day 3; submit by Day 4):**
Repeat Gate Check 2 with the Audio Codec Wrapper in **live mode** (`sim_live = '1'`). Without trigger, the waveform should scroll. Loop back the serial ADC input to the DAC output so you can hear the line-in signal on line-out while seeing it on the monitor.

**After GC3:**

* Implement proper triggering on `trig_volt`. Add an initial “wait for trigger” state in the FSM; the rest of the FSM is unchanged. If issues arise, build a Testbench.

**Deliverables:**

* Demo live or upload a video to Teams.
* (I observed partial success here; scrolling worked, but `triggerTime` had no functionality.)

---

## Required Functionality [30 Points]

**Target:** One channel displays with reliable triggering, holding the waveform at the left edge (fixed `trigger_volt`). A 220 Hz waveform should match the page’s reference screenshot. Additionally:

* Waveform centered on row **220**.
* Separate **datapath** and **control unit**.
* State machine coding style from Lesson 9: a state-transition process plus a CSA LUT section for output CWs (Mini-C optional).
* Datapath built from processes for standard blocks (counter, register, mux, etc.). Avoid one monolithic process.

**Deliverables:**

* Demo live or upload a video to Teams.
* Tag repo: `Lab2_ReqdFunc`.

---

## B-Level Functionality [10 Points]

* Meet all **Required** items.
* Add **second channel** (green).
* Include the **flag register** and `exSel` (plus other `ex___` signals) with the shown muxing.

**Deliverables:**

* Demo live or upload a video to Teams.
* Tag repo: `Lab2_BFunc`.

---

## A-Level Functionality [10 Points]

* Meet all **B-Level** items.
* Use the **trigger voltage marker** to set the actual trigger voltage. As you move the trigger up/down, the intersection at the left edge should change accordingly. The arrow marker must be calibrated with the waveform start at **column 20**.
* Integrate the button debouncing strategy from **HW #7** (or equivalent) for the buttons controlling trigger time and trigger voltage.
* Move the **trigger volt** and **trigger time** cursors using the buttons.

**Deliverables:**

* Demo live or upload a video to Teams.
* Tag repo: `Lab2_AFunc`.

---

## Conclusion

This lab significantly increased oscilloscope capability and robustness over Lab 1 by adding the Audio Codec + BRAM pipeline, channel control, and triggering. The display behaved as expected under trigger voltage adjustments and across input frequencies. `triggerTime` functionality remains unresolved, and debouncing should be reviewed, but overall objectives—including Required, B-level, and A-level functionality—were achieved as noted above.

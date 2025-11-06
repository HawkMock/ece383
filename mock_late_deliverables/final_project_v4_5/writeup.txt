# Final Project Report: VHDL First-Person 3D Maze on Nexys Video

**Author**: C1C Dustin Mock
**Course**: ECE 383 - Embedded Systems II
**Date**: 20 October 2025

## 1. Project Plan

### 1.1. Proposal

#### 1.1.1. Objective Statement
The objective of this project is to design, implement, and verify a complete, synthesizable VHDL system that renders a real-time, first-person 3D maze on the Digilent Nexys Video board. The system will utilize a column-based raycasting algorithm, and output a 640x480 resolution image via HDMI. (The design will not use any soft-core processors (e.g., MicroBlaze), High-Level Synthesis (HLS), or C/C++ code, adhering to a resource-aware, "pure hardware" design philosophy.)

#### 1.1.2. Requirements
*   **Minimum Functionality (C-Level):**
    1.  The system renders a static 2D top-down view of a hardcoded 16x16 maze map to the HDMI output.
    2.  A pixel representing the player's position is displayed on the map.
    3.  The on-board buttons (BTNU/BTND) move the player forward and backward, and the on-board LEDs display the player's integer coordinates.

*   **Target Functionality (B-Level):**
    1.  The system renders a first-person 3D view of the maze using a raycasting algorithm.
    2.  The on-board buttons control player movement (forward/backward) and rotation (left/right).
    3.  The implementation uses fixed-point arithmetic and look-up tables (LUTs) for all trigonometric calculations to ensure synthesizability and timing closure.

*   **Advanced Functionality (A-Level):**
    1.  The rendering is real-time, achieving a stable 60 frames per second at 640x480 resolution.
	2.  An external controller is used to move the player.

#### 1.1.3. Level-0 Top Level Design
The system accepts input from the Nexys Video's on-board push-buttons for user control and outputs a TMDS video signal to an HDMI monitor. The core logic is implemented on the Artix-7 FPGA.


### 1.2. Detailed Architecture and Sub-System Design

#### 1.2.1. Level-1 Design
The FPGA design is partitioned into two main hierarchical blocks: `lab2_datapath` and the `video` pipeline, which itself contains the `VGA` timing generator and the `scopeFace` raycaster. The design is purely custom hardware, with no FSM, as the player state is managed synchronously and the rendering is purely combinational.

*   **`lab2_datapath`:** The highest-level entity within the FPGA.
    *   **Responsibilities:** Manages player state (`f_px`, `f_py`, `f_ang_idx`) in synchronous registers. It samples button inputs on a 50 Hz tick to update the player's position and angle. It then packs this state information into legacy trigger signals to be consumed by the video pipeline.
    *   **Inputs:** `xi_clk`, `xi_reset_n`, `xi_btn`.
    *   **Outputs:** `xo_tmds`, `xo_tmdsb` (to HDMI port), `xo_led` (for debug).

*   **`video`:** The top-level video pipeline module.
    *   **Responsibilities:** Instantiates the `clk_wiz_0` IP to generate the required pixel and serialization clocks. It then connects the `VGA` and `dvid` modules to form the video signal chain.
    *   **Inputs:** `i_clk` (100MHz system clock), `i_trigger_volt`/`i_trigger_time` (packed player state).
    *   **Outputs:** `o_tmds`, `o_tmdsb`.

*   **`VGA`:** Generates VGA timing signals (`h_sync`, `v_sync`, `blank`) and the current pixel coordinates (`o_row`, `o_column`) based on the 25.175 MHz pixel clock. It instantiates the `scopeFace` module, passing it the pixel coordinates and packed player state for rendering.

*   **`scopeFace`:** The core raycasting engine.
    *   **Responsibilities:** This is a purely combinational module. For each pixel coordinate it receives, it performs the following:
        1.  Unpacks the player's position and angle.
        2.  Calculates the specific ray vector for the current screen column.
        3.  Executes a pipelined Digital Differential Analysis (DDA) algorithm to find the distance to the first wall intersection.
        4.  Calculates the vertical wall slice height based on the distance.
        5.  Outputs the final RGB color for the pixel, corresponding to either the ceiling, floor, or a shaded wall.


### 1.3. Calculations/Analysis/Drawings

#### 1.3.1. Fixed-Point Arithmetic
To implement the raycaster in hardware without floating-point units, fixed-point arithmetic was used.
*   **Player Position (`f_px`, `f_py`):** A `Q6.10` format was chosen, represented by a `signed(15 downto 0)` vector. This provides 6 bits for the integer part (range -32 to +31, more than enough for a 16x16 map) and 10 bits for the fractional part (precision of $$2^{-10} \approx 0.001$$).
*   **Direction Vectors (`v_dirx`, `v_diry`):** A `Q1.15` format was used for sine and cosine values from the LUTs. This provides a range of -1.0 to +0.9999, which is ideal for normalized direction vectors.

#### 1.3.2. Trigonometry Look-Up Tables (LUTs)
To avoid complex rotational logic, pre-calculated 16-entry LUTs for sine and cosine (`k_sin16`, `k_cos16`) were implemented. This quantizes the player's angle to 16 discrete directions ($$360 / 16 = 22.5$$ degrees per step), which is sufficient for maze navigation.

#### 1.3.3. Wall Height Calculation (Division-by-LUT)
A critical performance bottleneck in raycasting is calculating the projected wall height, which involves a division: `height = CONSTANT / distance`. To avoid a slow, resource-intensive division circuit, a 32-entry LUT (`k_height_lut`) was implemented. The DDA loop provides the distance in discrete steps (0-31), which directly indexes the LUT to retrieve a pre-calculated wall height.

#### 1.3.4. Example `scopeFace` Display
The display is a 640x480 pixel area. The top half of the screen is rendered as a dark blue ceiling, and the bottom half is a dark gray floor. When the raycaster detects a wall, it draws a vertical column. The height of this column is inversely proportional to the calculated distance. Walls facing North/South/East/West are shaded with different colors (Red, Yellow, Green, Blue) to provide clearer environmental cues.


### 1.4. Bill of Materials
1.  **FPGA Board:** Digilent Nexys Video (XC7A200T-1SBG484C) - Provided by USAFA.
2.  **Power Supply:** 12V DC Power Adapter - Provided by USAFA.
3.  **Display:** Standard HDMI Monitor - Provided by USAFA.
4.  **Cables:** Micro-USB for programming, HDMI for video output - Provided by USAFA.

### 1.5. Milestones
*   **Milestone I (Completed):** The initial design successfully rendered a 2D top-down view of the map and player. The system compiled, was programmed to the FPGA, and displayed a static image correctly. Button input was verified by observing LED changes corresponding to player coordinates.
*   **Milestone II (Completed):** The full 3D raycasting engine was implemented and verified. The system renders the maze in real-time at 60 FPS. Player movement and rotation controls via the on-board buttons are fully functional. The implementation meets all timing constraints in Vivado 2024.2.

## 2. Final Demonstration and Test Results
The final design successfully meets all B-level requirements. The project was synthesized and implemented using Vivado 2024.2, resulting in a bitstream that was successfully downloaded to the Nexys Video board. Upon power-up, the system displays a stable, real-time, first-person 3D rendering of the hardcoded maze on an HDMI monitor.

The on-board buttons function as specified:
*   `BTNU`: Move forward
*   `BTND`: Move backward
*   `BTNL`: Turn left
*   `BTNR`: Turn right

The on-board LEDs provide debug information, displaying the player's current angle and the integer part of the X-coordinate. The design successfully meets all timing constraints, demonstrating the viability of the divisionless DDA algorithm and LUT-based approach for high-performance graphics rendering in pure VHDL.


## 3. Appendix A: Running the Project
Follow these steps to duplicate the demonstration:

1.  **Prerequisites:**
    *   Xilinx Vivado 2024.2 Design Suite.
    *   Digilent Adept 2 software for board drivers.
    *   A Digilent Nexys Video board and the required cables (USB, HDMI, Power).

2.  **Compilation Steps:**
    *   [Provide a step-by-step guide for compiling the project. For example:
        1.  Create a new project in Vivado targeting the `xc7a200tsbg484c-1` device.
        2.  Add all provided `.vhd` source files to the project.
        3.  Add the `final_project.xdc` constraints file.
        4.  Generate the `clk_wiz_0` IP Core with the specified output frequencies (25.175 MHz and 125.875 MHz).
        5.  Run Synthesis, Implementation, and Generate Bitstream.]

3.  **Running the Demo:**
    1.  Connect the Nexys Video board to the PC via the PROG Micro-USB port and to an HDMI monitor.
    2.  Power on the Nexys Video board.
    3.  In Vivado, open the Hardware Manager and connect to the board.
    4.  Program the device with the generated bitstream (`.bit` file).
    5.  The 3D maze should immediately appear on the HDMI monitor.
    6.  Use the on-board buttons (BTNU, BTND, BTNL, BTNR) to navigate the maze. The CPU_RESET button (`reset_n`) will reset the player to the starting position.

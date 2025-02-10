## Introduction
Provide a brief overview of the problem.

*The purpose of this lab is to implement VGA protocol on the Nexys Video Board FPGA, allowing display of an oscilloscope grid, waveforms, and trigger arrows. The intention with this lab is that later labs will be able to utilize the waveform visualizations to display analog signals.*

## Design/Implementation
Include your diagrams from HW5. Provide the block-diagram of your solution using the signal names in your code. The block diagram given above is somewhat incomplete, make sure to include corrections to this diagram. An editable block diagram PPT is provided here. For each module that you built, explain its overall purpose, inputs, outputs, and behavior. You do not need to include code in this report (instead put all your vhdl files (code and testbench), wcfg file, and bit files in GitHub). Tip: How to add images to your README

## Test/Debug
Briefly describe the methods used to verify system functionality (such as products from gate check 1 and 2).

## VGA Test Bench:

## Show the h_synch going high, low, and high in relation to column count.

## Show the v_synch going high, low, and high in relation to row count AND column count.

## Show the blank signals going high, low, and high in relation to column count and row count.

## Show the column count rolling over causing the row count to increment and max counts for both counters.

## Major Problems

Major Problem 1: Windows marking files as "read only"

Major Problem 2: Github file management (operator error)

Major Problem 3: Buttons cause trigger levels to scroll at maximum speed with no delay.

## Results
This section should clearly state for each milestone/functionality the date/time it was achieved, level of achievement (e.g, achieved, partially-achieved, not achieved), what was achieved, and evidence you proved it worked (e.g., via demo or images/videos). We no longer use the printed lab cutsheets signed by your instructor as you meet each milestone, but instead have you make a submission in Gradescope for each milestone.

| Milestone    | Date/Time           | What was acheived:                               |
| :----------- | :------------------ | :----------------------------------------------- |
| Gate Check 1 | 2025-01-24 21:37    | Implemented and demonstrated via screenshots uploaded to GitHub the functionality of the row and column counters, as well as appropriate rollover. |
| Gate Check 2 | 2025-01-27 23:51    | Implemented and demonstrated via screenshots uploaded to Github the functionality of the synch and blank signals as the row and column counters progress. |
| Lab 1 Full Functionality | 2025-02-04 08:30 | Completed scopeface module and channel logic, demonstrating an output on monitor showing the two waveforms, gridlines, trigger arrows, and hash marks. |

## Conclusion - Explain what your learned from this lab and what changes you would recommend in future years to this lab or the lectures leading up to this lab.
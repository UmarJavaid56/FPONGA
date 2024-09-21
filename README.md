# FPONGA: Bringing Pong to Life with FPGA

FPONGA is a reinterpretation of the classic Pong game, implemented using Verilog on an FPGA board.

## Demonstration

[![YouTube Video](https://img.youtube.com/vi/gM5NCk0KDhk/0.jpg)](https://www.youtube.com/watch?v=gM5NCk0KDhk)

## Getting Started
### Prerequisites
- An FPGA development board (e.g., Nandland GoBoard).
- Familiarity with Verilog and FPGA toolchains.

### Setup
- Clone this repository: git clone https://github.com/UmarJavaid56/Nandland-Go-Board-Projects.git
- Synthesize the Verilog code using your FPGA toolchain (e.g., Vivado, Quartus).
- Program the FPGA board with the synthesized bitstream.

Connect the board to a display to start playing FPONGA!

## Overview 

The implementation of FPONGA involves creating separate modules for each paddle and the ball. These modules interact with the main game board to render the game in real time.

The Gameboard is set to 40×30 pixels, which is derived by dividing the standard 640×480 display by 16. This scaling is achieved by dropping the 4 least significant bits of the Row and Column indexes.
   - Explanation: In FPGA design, dividing by a power of 2 is accomplished by shifting bits to the right. Therefore, to divide by 16, we drop the 4 least significant bits (since 16 is 2^4), effectively achieving the division without the need for complex division circuitry.
  
## Game Logic and Functional Blocks
Each component of the game (paddles and ball) is handled by its respective module. These modules operate by comparing the current pixel’s Row/Col index to the position of the paddle or ball:

![Pong Goboard](https://github.com/user-attachments/assets/76245fd1-4a4f-4842-861e-e967426a1423)

### Paddle and Ball Modules:
- Each module tracks its position based on the current Row/Col index of the frame.
- When the current pixel matches the component's location, the module outputs a high signal, prompting the main Pong Top module to render a white pixel.

### Modules Description
- `Pong_Paddle.v`: Manages the movement and rendering of each paddle. It keeps track of its position and ensures the paddle appears in the correct location on the board.

- `Pong_Ball.v`: Controls the movement and collision of the ball. It calculates the ball's position and determines when to render it based on its current coordinates.

- `Pong_Top.v:` The top-level module that coordinates the inputs from the paddle and ball modules to draw the game on the display. It integrates the outputs from each module and renders the game frame by frame. It also monitors and updates the game scores, which are displayed using a 7-segment display.

- `UART_RX.v:` The UART Receiver receives a start command from the computer to kick off the pong game. The UART receiver is configured to operate at 115200 baud with the following settings: 8 data bits, no parity, 1 stop bit, and no flow control. It also transmits the tracked score to the 7-segment display.

- `Binary_To_7Segment.v:` Displays the Score for each player from 0 to 9.

- `Sync To Count.v:` Generates row and column counters synchronized to VGA signals, resetting them at the start of each frame for accurate pixel tracking.

- `VGA_Sync_Porch.v:` Handles VGA synchronization and video data processing. It generates the correct horizontal and vertical sync signals by accounting for the front and back porch intervals, ensuring proper timing for display. Additionally, it passes the video data for red, green, and blue colours through without modification, ensuring accurate colour representation on the display.

- `VGA_Sync_Pulses.v:` Generates horizontal and vertical sync pulses for VGA display timing. It counts columns and rows to track the current position within the frame.

- `Debounce_Switch.v:` Ensures that brief, noisy changes in the switch input are ignored and only stable, long-duration changes are considered valid. This prevents rapid, unintended toggling due to switch bounce.





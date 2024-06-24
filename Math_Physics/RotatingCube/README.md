# Cube Rotation in LOVE2D

This project is a demonstration of a rotating 3D cube in a 2D screen using LOVE2D. The application allows viewing a cube in perspective, with interactive controls for rotation and zoom.

## Features

- **Automatic Rotation:** The cube rotates automatically around the three axes (X, Y, Z).
- **User Interaction:**
  - Press the left mouse button and drag to manually rotate the cube.
  - Use the mouse wheel to zoom in or out.
  - Press the `R` key to toggle between fullscreen and windowed mode.
- **Dynamic Color Change:** The cube's color varies over time, creating a dynamic visual effect.

## Controls

- **Manual Rotation:** Click and drag with the left mouse button.
- **Zoom:** Use the mouse wheel to adjust the camera position.
- **Fullscreen:** Press the `R` key to toggle fullscreen mode.

## Main Code

- `initCube(size)`: Initializes the cube vertices based on the provided size.
- `project3D(x, y, z, width, height, cameraZ)`: Projects 3D coordinates into 2D for screen visualization.
- Rotation functions (`rotateX`, `rotateY`, `rotateZ`): Rotate the cube points around the X, Y, and Z axes, respectively.
- `interpolate3D(p1, p2, steps)`: Interpolates points between two vertices to fill the cube's faces.
- `love.load()`: Function called once at the start to initialize the cube.
- `love.update(dt)`: Updates the rotation angles and cube color each frame.
- `love.wheelmoved(x, y)`: Adjusts the zoom based on mouse wheel movement.
- `love.mousepressed(x, y, button, istouch, presses)`: Starts manual rotation when the left mouse button is pressed.
- `love.mousereleased(x, y, button, istouch, presses)`: Stops manual rotation when the left mouse button is released.
- `love.mousemoved(x, y, dx, dy, istouch)`: Updates the rotation angles based on mouse movement during manual rotation.
- `love.keypressed(key)`: Toggles between fullscreen and windowed mode when the `R` key is pressed.
- `love.draw()`: Draws the rotated and interpolated cube on the screen, along with instruction texts.

## Requirements

- LOVE2D (version 11.3 or higher recommended)

## Running the Project

1. Install LOVE2D from the [official website](https://love2d.org/).
2. Clone this repository or download the files.
3. Run LOVE2D in the project folder or with the `main.lua` file.

   ```bash
   love .


# Walking in Space

---

**Tools Used:** Godot game engine, GDScript &nbsp;&nbsp;&nbsp;&nbsp; **Keywords:** 3D, Rotation using bases, Particle effects, Lighting

---

### Description:
&nbsp;&nbsp;&nbsp;&nbsp;A minute-long game where the player finds themself on a thin white stripe in the void, their only reference a series of street lights that flicker into existence as they are approached. As time passes, they begin to hear music slowly growing in volume, until, at the song's climax, planets and stars flicker into the sky around them, and they are flung upwards. Now, their rotation is based on the gravity of the planets, leaving them swinging wildly in space. Finally, a large explosion is heard, and a bright white star begins to grow, leaching the color from nearby planets. When the star reaches the player, they are engulfed in white light, and a few seconds later, the game closes.


### Features:
- &nbsp;&nbsp;&nbsp;&nbsp;**Gameplay Experience:**  
This game was built to be an experience rather than tell a compelling story or have any deep game mechanics. To achieve this experience, I used custom particle effects, lighting, and sound design to make sure that the experience felt immersive. Each handmade street light makes a flickering sound when first approached that solidifies to a low buzz that goes perfectly with the bright sparks intermittently spat out from the bulb. Other areas with these effects also include the distant stars that slowly fade in and out, the player's trail once lifted, and the final star that casts such a bright white light that the colored lights from the planets become overwhelmed.

- &nbsp;&nbsp;&nbsp;&nbsp;**Rotation Using Physics:**  
Once the player is lifted, their rotation becomes a function of the gravities of the planets around them (whose trajectories are also determined by physics). To achieve this, I rotated the player by changing the player's basis' Y component and then ortho-normalizing the player's basis to get a targeted basis, then tweened the player's basis to match the target over a time equal to a function of the distance between these values.


### Code Breakdown:
- &nbsp;&nbsp;&nbsp;&nbsp;**3DLevel:**  
This is the primary file of the project. It contains the 3D space of the player and first floor segment as well as the code for music, spawning planets, calculating physics for planets and player rotation, and adding more floor segments as the player traverses.

- &nbsp;&nbsp;&nbsp;&nbsp;**Player:**  
This file contains the player camera and collision as well as logic for basic movement of the player.

- &nbsp;&nbsp;&nbsp;&nbsp;**FloorSegment:**  
This is a helper file that contains the sprite for a section of the white strip, with street lights instantiated. As the player moves forward, more of these are added to the primary scene.

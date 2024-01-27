
# Walking in Space

---

**Tools Used:** Godot Game Engine, GDScript &nbsp;&nbsp;&nbsp;&nbsp; **Keywords:** 3D, Rotation using bases, Particle effects, Lighting

---

### Description:
&nbsp;&nbsp;&nbsp;&nbsp;A minute long game where the player finds themself on a thin white strip in the void, their only reference a series of street lights that flicker into existence as they are aproached. As time passes they begin to hear music slowly growing in volume, until, at the song's climax, planets and stars flicker into the sky around them and they are flung upwards. Now their rotation is based on the gravity of the planets leaving them swinging wildly in space. Finally a large explosion is heard and a bright white star begins to grow, leaching the color from nearby planets. When the star reaches the player they are engulfed in white light and a few seconds later the game closes.


### Features:
- **Gameplay Expirence:**  
&nbsp;&nbsp;&nbsp;&nbsp;This game was build to be an expirence rather then tell a compelling story or have any deep game mechanics. To achieve this expirence I used custom particle effects, lighting, and sound design to make sure that the expirence felt imersive. Each handmade street light makes a flickering sound when first aproached that soldifies to a low buzz that goes perfectly with the bright sparks intermitently spat out from the bulb. Other areas with these effects also include the distant stars that slowly fade in and out, the player's trail once lifted, and the final star that casts such a bright white light that the colored lights from the planets become overwhelmed.

- **Rotation Using Physics:**  
&nbsp;&nbsp;&nbsp;&nbsp;Once the player is lifted, their rotation becomes a function of the gravities of the planets around them (whose trajectories are also determined by physics). To achieved this I rotated the player by changing the player's basis' Y component and then orthonormalizing the player's basis to get a target basis, then tweened the player's basis to match the target over a time equal to a function of the distance between these values.


### Code Breakdown:
- **File:**  
&nbsp;&nbsp;&nbsp;&nbsp;File description

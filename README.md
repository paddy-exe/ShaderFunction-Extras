# ShaderFunction-Extras
<div id="badges" align="center">
  <a href="https://ko-fi.com/flamelizard">
    <img src="https://img.shields.io/badge/Support my work-red?style=for-the-badge&logo=kofi&logoColor=white" alt="Ko-Fi Badge"/>
  </a>
  <a href="https://twitter.com/patrick_exe">
    <img src="https://img.shields.io/badge/Twitter-blue?style=for-the-badge&logo=twitter&logoColor=white" alt="Twitter Badge"/>
  </a>
  <a href="https://mastodon.gamedev.place/@flamelizard">
    <img src="https://img.shields.io/badge/Mastodon-purple?style=for-the-badge&logo=mastodon&logoColor=white" alt="Mastodon Badge"/>
  </a>
</div>

![ShaderFunctions-GitHub-Preview](https://user-images.githubusercontent.com/38077837/223874483-03c037d6-d27f-4e83-a5b1-2d4af3c991fb.png)


This project aims to help Godot developers writing custom written shaders by providing high-level functions which are often used.

## :tada: Using the addon
Download the source (releases and AssetLib version are still WIP) and put the `ShaderFunction-Extras` inside
your `addons` folder. If you don't have one, create it or put the whole addons folder inside your project directory.

After that, you can include the include files you need in your shader like this:
![gdshaderinc-use-showcase](https://user-images.githubusercontent.com/38077837/224516902-06e97d30-e889-4544-b8ce-3b9f2be4144c.gif)


## 🔢 Versioning
This repository is only meant for projects created with Godot 4.0 and upwards. However, if you are using Godot 3.x and want to
use specific functions, you can copy and paste it inside your shader code still.

## ℹ️ Contributing
All these shader functions are based on publicly available shader functions (open-source licensed with permissive licenses such as MIT). If you want to contribute a function, create an issue starting with `Proposal: ...` describing the shader function and why you think it should be included in here. We can then discuss on how this function and its parameters should be called (for clarity of the users). After that you are open to create a PR (Pull Request) with the dicussed details of the proposal.

## Provided Functions

<details>
  <summary>
    Click me to enlarge
  </summary>

  ### Color
  #### Blend Modes
  * `blend_normal`
  * `blend_dissolve`
  * `blend_multiply`
  * `blend_screen`
  * `blend_overlay`
  * `blend_hard_light`
  * `blend_soft_light`
  * `blend_burn`
  * `blend_dodge`
  * `blend_lighten`
  * `blend_darken`
  * `blend_difference`
  * `blend_additive`
  * `blend_addsub`
  * `blend_linear_light`
  * `blend_vivid_light`
  * `blend_pin_light`
  * `blend_hard_mix`
  * `blend_exclusion`

  #### Color Adjustment
  * `greyscale`
  * `hsv_to_rgb`
  * `rgb_to_hsv`
  * `hsv_adjustment`

  ### Noise
  * `psrdnoise3_with_gradient`
  * `psrdnoise3`
  * `psrdnoise2_with_gradient`
  * `psrdnoise2`

  ### Utility
  * `depth_camera_*`
  * `depth_vertex_*`
  * `linear_scene_depth_*`
  * `distance_fade`
  * `proximity_camera_fade_*`
  * `proximity_vertex_fade_*`
  * `world_position_from_depth_*`
  * `screen_normal_world_space`
  * `rotation_matrix_by_axis`
  * `rotate_by_axis`
  * `random_range`
  * `remap`
  * `fresnel`
  * `fresnel_glow`
  * `smooth_clamp`
  * `soft_clamp`
  * `saturate`

  ### UV
  * `uv_panning`
  * `uv_scaling`
  * `uv_rotate`
  * `uv_polar_coord_*`
  * `uv_flipbook`
  * `uv_twirl`
  * `uv_grid_tiler`

  ### Wave
  * `sawtooth_wave`
  * `sine_wave`
  * `sine_wave_angular`
  * `square_wave`
  * `triangle_wave`

  ### Shapes
  * `polygon`
  * `circle`
  * `square`
  * `square_stroke`
  * `square_rounded`
  * `swirl`
  * `line`

</details>

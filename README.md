# Tutorial 7 - Basic 3D Game Mechanics & Level Design
#### Nama: Muhammad Farid Hasabi
#### NPM : 2306152512

## Implementasi Mekanik 3D (Tutorial 7 & Latihan Mandiri)
Sistem mekanik dasar FPS telah diintegrasikan untuk memberikan pengalaman bermain yang responsif dan utuh (*game loop*):
* **Advanced FPS Controller:** Mengimplementasikan fitur *Sprinting* dan *Crouching* berbasis *state*. Pemain dapat berlari cepat (disertai pelebaran *Field of View* kamera secara dinamis) dan jongkok dg penurunan tinggi kamera serta pengecilan `CollisionShape3D`. Seluruh transisi pergerakan diperhalus menggunakan interpolasi matematis (`lerp`).
* **Anti-Stuck System:** Menggunakan komponen `RayCast3D` (`ceiling_check`) yang mengarah ke atas kepala karakter. Sistem ini mencegah pemain untuk berdiri secara otomatis dari mode jongkok jika masih berada di bawah rintangan atau lorong sempit.
* **Pick up item & inventory system:** Sistem inventori terbagi menjadi dua level fungsionalitas. Pada Level 1, pemain mengumpulkan 5 koin (Sistem Hitung Numerik). Pada Level 2, pemain harus mengambil balok warna secara spesifik ke dalam 5 slot inventori di HUD untuk memecahkan teka-teki logika warna (Sistem Slot *Array*).

## Fitur Tambahan
Selain fitur wajib di atas, saya juga menambahkan fitur-fitur lainnya, antara lain:

### Contextual Interaction System
* **RayCast Detection & Smart UI:** Menggunakan `RayCast3D` dari titik tengah kamera karakter untuk mendeteksi objek di dunia yang meng-`extends Interactable`. HUD akan menampilkan instruksi dinamis secara otomatis (contoh: "Press [E] to open door" atau "Press [E] to pick up block") hanya saat *crosshair* membidik objek yang valid.
* **Feedback Logic (Punishment):** Menampilkan peringatan visual di layar seperti "LOCKED" atau "WRONG ANSWER!" (disertai manipulasi warna teks via `modulate`) ketika pemain gagal memenuhi syarat interaksi pintu. Jika kombinasi warna inventori salah di Level 2, *scene* akan otomatis di-*restart*.

### Polishing Visual & Antarmuka (HUD)
* **Animasi Objek 3D (Koin Berputar):** Mengimplementasikan rotasi kontinu pada objek *collectible* koin menggunakan skrip di dalam fungsi `_process(delta)`. Koin berputar secara konstan pada sumbu Y (`rotate_y`), memberikan *feedback* visual yang dinamis dan menarik.
* **Integrasi Aset Eksternal:** Meningkatkan estetika permainan (*polishing*) dengan mengimpor dan menggunakan aset 3D dari luar (format `.glb` / `.gltf`) untuk model Pintu, menggantikan bentuk dasar geometri (*primitives*) bawaan Godot agar dunia game terasa lebih detail dan realistis.
* **VFX & Portal Mechanics:** Memberikan *game feel* yang memuaskan saat pintu terbuka dengan menonaktifkan *collision* tembok secara aman menggunakan `set_deferred()`, memunculkan portal bersinar (`MeshInstance3D` dengan *Emission*), dan memicu pancaran debu magis (`GPUParticles3D`).
* **Dynamic HUD Manager:** Sistem arsitektur UI yang beradaptasi dengan *State* level. Skrip mendeteksi level yang aktif melalui `get_tree().current_scene.name` untuk otomatis menyembunyikan indikator koin di Level 2, dan menggantinya dengan visibilitas kotak slot *puzzle*.
* **Mouse Capture Handling & Win Screen:** Mengelola sistem `Input.MOUSE_MODE_CAPTURED` secara presisi selama *gameplay* (termasuk fitur pendeteksi klik kiri untuk mencegah kursor lepas/*out-of-focus*). Saat *gameplay* selesai, sistem melepaskan mouse ke `MOUSE_MODE_VISIBLE` dan memanggil `WinScreen.tscn` yang menampilkan aset gambar apresiasi (*Full Rect*, *Keep Aspect Centered*) beserta navigasi *Play Again* dan *Quit*.

## Referensi Tambahan
* [Godot Docs: RayCast3D and Intersecting](https://docs.godotengine.org/en/stable/classes/class_raycast3d.html)
* [Godot Docs: CharacterBody3D 3D movement](https://docs.godotengine.org/en/stable/tutorials/physics/using_character_body_2d.html)
* [Godot Docs: Instancing Scenes](https://docs.godotengine.org/en/stable/tutorials/step_by_step/instancing.html)
* [Godot Docs: Mouse and input coordinates](https://docs.godotengine.org/en/stable/tutorials/inputs/mouse_and_input_coordinates.html)
* [Kenney Assets 3D](https://kenney.nl/assets)

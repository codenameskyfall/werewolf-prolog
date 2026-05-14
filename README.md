# Project Werewolf Prolog

Id:
Hiii!! Selamat datang di repository kodingan Werewolf saya!
Ini tuh projek gabut aja sebenernya. Ngide aja kayak penasaran bisa ga ya bikin game werewolf di prolog?
Still aku masih pemula banget, ini tempat aku belajar aja. Enjoy!

En :
Hiii!! Welcome to my Werewolf coding repository!
This is just a little side project, really. I was just curious to see if I could make a Werewolf game in Prolog.
I’m still a total beginner, so this is just where I’m learning. Enjoy!


Id:
## Daftar Versi:
* **[Versi 1.0](https://github.com/codenameskyfall/werewolf-prolog/tree/v1.0)**
  - Inisialisasi game
  - Registrasi player yang berisikan input jumlah, nama player, dan berapa jumlah peran yang diinginkan
  - *Pembagian peran kepada player: werewolf, hunter, dan villager
  - *Fase malam: ketika semua peran menjalankan aktivitasnya diakhiri resolusi malam
  - Fase siang: berisikan hasil resolusi malam seperti siapa yang mati serta sistem voting
  - Cek kemenangan: werewolf menang jika jumlah WW >= jumlah villager atau jumlah villager = 0. 
    Villager menang jika jumlah WW = 0
  *Note:
   - *Pembagian peran dibuatkan aturan jika:
     4 - 5 orang maka ada maksimal 2 werewolf dan tidak ada hunter
     6 - 8 orang maka ada maksimal 2 werewolf dan maksimal 1 hunter
     9 orang maka ada maksimal 2 werewolf dan maksimal 2 hunter
     10 orang maka ada maksimal 3 werewolf dan maksimal 3 hunter
   - *Fase malam terbagi jadi beberapa aktivitas tergantung peran:
     villager: bisa milih antara 3 kegiatan yaitu bersih-bersih, ngopi, atau tidur. Tidak mempengaruhi alur game apapun pilihannya.
     werewolf: memilih mangsa, jika ada lebih dari satu werewolf maka bisa memangsa lebih dari satu orang.
     hunter: memilih buruan, meskipun yang diburu villager maka hunter tetap bisa valid. tak ada konsekuensi untuk salah tembak.

* **[Versi 2.0](https://github.com/codenameskyfall/werewolf-prolog/tree/v2.0)**
  - Coming soon: [Update role tambahan: Joker dan Orang Kuat]

En:
## List Version:
* **[Version 1.0](https://github.com/codenameskyfall/werewolf-prolog/tree/v1.0)**
  - Game Initialization
  - Player registration, which includes inputting the number of players, their names, and the desired number of roles
  - *Role assignment to players: werewolf, hunter, and villager
  - *Night phase: when all roles perform their actions, ending with the night resolution
  - Day phase: includes the results of the night resolution, such as who died, and the voting system
  - Checking the winner: werewolves win if the number of WW is greater than or equal to the number of villagers, or if the number of villagers is 0. Villagers win if the number of WW is 0
  *Note:
   - *Role distribution follows these rules:
     4–5 players: a maximum of 2 werewolves and no hunters
     6–8 players: a maximum of 2 werewolves and a maximum of 1 hunter
     9 players: there are a maximum of 2 werewolves and a maximum of 2 hunters
     10 players: there are a maximum of 3 werewolves and a maximum of 3 hunters
   - *The night phase is divided into several activities depending on the role:
     villager: can choose between 3 activities: cleaning, having coffee, or sleeping. The choice does not affect the game flow in any way.
     Werewolf: Choose a target; if there is more than one werewolf, they can target more than one person.
     Hunter: Choose a target; even if the target is a villager, the hunter’s action is still valid. There are no consequences for a missed shot.

* **[Version 2.0](https://github.com/codenameskyfall/werewolf-prolog/tree/v2.0)**
  - Coming soon: [Additional role updates: Joker and The Strong Man]
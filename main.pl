:- dynamic(player/3).
:- dynamic(target_bunuh/1).
:- dynamic(target_buru/1).

% -------------------------
% 1. PENGATURAN AWAL
% -------------------------
mulai :-
    retractall(player(_, _, _)),
    retractall(target_bunuh(_)),
    retractall(target_buru(_)),
    write('=== SETTING PERMAINAN WEREWOLF (HUNTER EDITION) ==='), nl,
    write('Jumlah pemain (4-10): '), read(Total),
    ( Total < 4 ; Total > 10 -> write('Jumlah tidak valid!'), nl, mulai ; true ),
    
    hitung_max_peran(Total, MaxWW, MaxHunt),
    format_input_peran(Total, MaxWW, MaxHunt, JmlWW, JmlHunt),
    
    JmlVillager is Total - JmlWW - JmlHunt,
    buat_list_peran(JmlWW, JmlHunt, JmlVillager, PeranList),
    acak_list(PeranList, PeranAcak),
    
    write('Registrasi dimulai. Siapkan pemain satu per satu.'), nl,
    registrasi_pemain(Total, PeranAcak),
    
    write('Semua siap. Game Dimulai!'), nl,
    fase_malam.

% Aturan Pembatasan Peran
hitung_max_peran(10, 3, 3) :- !.
hitung_max_peran(9, 2, 2) :- !.
hitung_max_peran(N, 2, 1) :- N >= 6, !.
hitung_max_peran(_, 2, 0). % 4-5 orang tidak ada Hunter

format_input_peran(Total, MaxW, MaxH, JmlW, JmlH) :-
    write('--- KONFIGURASI PERAN ---'), nl,
    write('Maksimal Werewolf: '), write(MaxW), nl,
    write('Maksimal Hunter: '), write(MaxH), nl,
    write('Input jumlah Werewolf: '), read(JmlW),
    ( MaxH > 0 -> write('Input jumlah Hunter: '), read(JmlH) ; JmlH = 0 ),
    ( (JmlW > MaxW ; JmlH > MaxH ; JmlW + JmlH >= Total ; JmlW < 1) -> 
        write('Input tidak valid! Pastikan jumlah masuk akal.'), nl,
        format_input_peran(Total, MaxW, MaxH, JmlW, JmlH)
    ; true ).

buat_list_peran(W, H, V, L) :-
    tambah_peran(W, werewolf, [], L1),
    tambah_peran(H, hunter, L1, L2),
    tambah_peran(V, villager, L2, L).

tambah_peran(0, _, L, L) :- !.
tambah_peran(N, P, L, [P|R]) :- N > 0, N1 is N - 1, tambah_peran(N1, P, L, R).

% -------------------------
% 2. REGISTRASI & TURN
% -------------------------
registrasi_pemain(0, _) :- !.
registrasi_pemain(N, [P|Ps]) :-
    write('Nama pemain (huruf kecil): '), read(Nama),
    assertz(player(Nama, P, hidup)),
    write('Halo '), write(Nama), write(', peranmu: '), write(P), nl,
    write('Ketik ok. untuk sembunyikan peran: '), read(_),
    spasi_panjang,
    N1 is N - 1, registrasi_pemain(N1, Ps).

fase_malam :-
    cek_menang, !.
fase_malam :-
    write('--- FASE MALAM ---'), nl,
    retractall(target_bunuh(_)),
    retractall(target_buru(_)),
    findall(P, player(P, _, hidup), Hidup),
    giliran_malam_individu(Hidup),
    spasi_panjang,
    write('--- PAGI TELAH TIBA ---'), nl,
    resolusi_malam,
    fase_siang.

giliran_malam_individu([]).
giliran_malam_individu([P|Ps]) :-
    write('GILIRAN: '), write(P), nl,
    write('Pemain lain JANGAN MELIHAT! Ketik ok. jika sudah siap: '), read(_),
    player(P, Peran, hidup),
    aksi_malam(P, Peran),
    write('Ketik ok. untuk sembunyikan layar: '), read(_),
    spasi_panjang,
    giliran_malam_individu(Ps).

% --- Aksi Malam ---
aksi_malam(_, villager) :-
    write('Kamu VILLAGER. Tugas malam [bersih_bersih. / ngopi. / tidur.]: '), read(_).

aksi_malam(P, werewolf) :-
    write('Kamu WEREWOLF. Pilih mangsa: '),
    tampilkan_target_valid(P), read(T),
    assertz(target_bunuh(T)).

aksi_malam(P, hunter) :-
    write('Kamu HUNTER. Apakah ingin menembak? [tembak. / skip.]: '), read(Aksi),
    ( Aksi == tembak ->
        write('Siapa targetmu? (Hati-hati, jika salah tembak warga tetap mati): '),
        tampilkan_target_valid(P), read(T),
        assertz(target_buru(T)),
        write('Target dikunci.')
    ; write('Kamu memilih untuk menghemat peluru.') ), nl.

% -------------------------
% 3. RESOLUSI & ELIMINASI
% -------------------------
resolusi_malam :-
    % 1. Serangan Werewolf
    findall(T1, target_bunuh(T1), LB),
    ( LB \= [] -> acak_list(LB, [KB|_]), eliminasi(KB, dibunuh) ; true ),
    
    % 2. Tembakan Hunter (Siapapun bisa mati)
    findall(T2, target_buru(T2), LH),
    proses_buru(LH).

proses_buru([]).
proses_buru([T|Rest]) :-
    ( player(T, _, hidup) -> 
        eliminasi(T, ditembak_hunter)
    ; true ),
    proses_buru(Rest).

eliminasi(Nama, Alasan) :-
    player(Nama, Peran, hidup),
    retract(player(Nama, Peran, hidup)),
    assertz(player(Nama, Peran, mati)),
    cetak_eliminasi(Nama, Peran, Alasan), !.
eliminasi(_, _).

cetak_eliminasi(N, _, dibunuh) :- 
    write('BERITA DUKA: '), write(N), write(' tewas mengenaskan karena gigitan Werewolf!'), nl.
cetak_eliminasi(N, _, ditembak_hunter) :- 
    write('TRAGEDI: '), write(N), write(' ditemukan tewas dengan luka tembak peluru perak!'), nl.
cetak_eliminasi(N, P, divote) :- 
    write(N), write(' digantung warga. Ternyata dia adalah '), write(P), nl.

% -------------------------
% 4. FASE SIANG & WIN COND
% -------------------------
fase_siang :-
    cek_menang, !.
fase_siang :-
    write('--- FASE SIANG (DISKUSI & VOTE) ---'), nl,
    tampilkan_pemain_hidup,
    write('Siapa yang ingin digantung? (skip. jika tidak ada): '), read(T),
    ( T \= skip -> eliminasi(T, divote) ; write('Warga memutuskan tidak menggantung siapapun.'), nl ),
    fase_malam.

cek_menang :-
    findall(W, player(W, werewolf, hidup), WW),
    findall(V, (player(V, P, hidup), (P=villager; P=hunter)), Warga),
    length(WW, JWW), length(Warga, JWG),
    ( JWW =:= 0 -> write('=== VILLAGER & HUNTER MENANG! ==='), nl, true
    ; JWG =:= 0 -> write('=== WEREWOLF MENANG! Warga telah habis. ==='), nl, true
    ; JWW > JWG -> write('=== WEREWOLF MENANG! Jumlah tak terbendung. ==='), nl, true
    ; fail ).

% -------------------------
% 5. HELPER
% -------------------------
spasi_panjang :- cetak_nl(60).
cetak_nl(0) :- !.
cetak_nl(N) :- nl, N1 is N - 1, cetak_nl(N1).

tampilkan_pemain_hidup :-
    findall(N, player(N, _, hidup), L), write('Pemain hidup: '), write(L), nl.

tampilkan_target_valid(Self) :-
    findall(N, (player(N, _, hidup), N \= Self), L), write(L), nl.

acak_list([], []).
acak_list(List, [E|Sisa]) :-
    length(List, Len),
    random(0, Len, Index),
    ambil_elemen(Index, List, E, Temp),
    acak_list(Temp, Sisa).

ambil_elemen(0, [H|T], H, T).
ambil_elemen(N, [H|T], E, [H|S]) :- N > 0, N1 is N - 1, ambil_elemen(N1, T, E, S).
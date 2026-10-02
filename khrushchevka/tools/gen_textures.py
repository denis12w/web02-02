#!/usr/bin/env python3
"""Генератор текстур мода khrushchevka (16x16, без зависимостей).

Цвета взяты с фотографии панельной пятиэтажки: серо-бежевая панель
с каменной крошкой, светлые швы, белые рамы и тёмное стекло,
бежевые балконные экраны, рыжая водосточная труба.

Запуск из папки мода:  python3 tools/gen_textures.py
"""
import os
import random
import struct
import zlib

OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "textures")
T = (0, 0, 0, 0)


def save(name, px, w=16, h=16):
    rows = []
    for y in range(h):
        row = b"\x00"
        for x in range(w):
            c = px(x, y)
            if len(c) == 3:
                c = c + (255,)
            row += bytes(max(0, min(255, int(v))) for v in c)
        rows.append(row)

    def chunk(t, d):
        return struct.pack(">I", len(d)) + t + d + struct.pack(">I", zlib.crc32(t + d))

    data = (b"\x89PNG\r\n\x1a\n"
            + chunk(b"IHDR", struct.pack(">IIBBBBB", w, h, 8, 6, 0, 0, 0))
            + chunk(b"IDAT", zlib.compress(b"".join(rows)))
            + chunk(b"IEND", b""))
    with open(os.path.join(OUT, "khrushchevka_" + name + ".png"), "wb") as f:
        f.write(data)


def mix(a, b, t):
    return tuple(a[i] + (b[i] - a[i]) * t for i in range(3))


def pebbles(base, seed, spread=1.0):
    """Панель с каменной крошкой: светлые, тёмные и рыжеватые камешки."""
    rnd = random.Random(seed)
    grid = {}
    for y in range(16):
        for x in range(16):
            r = rnd.random()
            if r < 0.18:
                c = mix(base, (95, 88, 80), 0.55 * spread)      # тёмный камешек
            elif r < 0.30:
                c = mix(base, (225, 222, 215), 0.6 * spread)    # светлый камешек
            elif r < 0.36:
                c = mix(base, (170, 125, 95), 0.45 * spread)    # рыжеватый гранит
            else:
                d = rnd.randint(-9, 9)
                c = tuple(v + d for v in base)
            grid[(x, y)] = c
    return lambda x, y: grid[(x, y)]


PANEL = (163, 160, 152)         # серо-бежевая панель с фото
SEAM = (196, 199, 203)          # светлая герметизация швов
SEAM_SHADOW = (120, 118, 112)


def with_seams(base_px, h=False, v=False):
    def px(x, y):
        if h and y == 15:
            return SEAM
        if v and x == 15:
            return SEAM
        if h and y == 14:
            return mix(base_px(x, y), SEAM_SHADOW, 0.5)
        if v and x == 14:
            return mix(base_px(x, y), SEAM_SHADOW, 0.5)
        return base_px(x, y)
    return px


# --- Панели -----------------------------------------------------------
panel = pebbles(PANEL, 1)
save("panel", panel)
save("panel_seam", with_seams(panel, h=True, v=True))
save("panel_seam_h", with_seams(panel, h=True))
save("panel_seam_v", with_seams(panel, v=True))
save("panel_beige", with_seams(pebbles((196, 178, 138), 2, 0.7), h=True, v=True))
save("panel_blue", with_seams(pebbles((126, 150, 172), 3, 0.7), h=True, v=True))

# Гладкий бетон (балконная плита) и тёмная нижняя сторона плиты
conc_rnd = random.Random(4)
conc = {(x, y): conc_rnd.randint(-6, 6) for x in range(16) for y in range(16)}
save("concrete", lambda x, y: tuple(v + conc[(x, y)] for v in (150, 148, 142)))
save("concrete_under", lambda x, y: tuple(v + conc[(x, y)] for v in (78, 76, 72)))


# --- Окно: белая рама, крупная створка с форточкой + узкая створка ------
def window(x, y):
    frame = (238, 238, 232)
    shade = (196, 196, 190)
    if x in (0, 15) or y in (0, 15):
        return frame
    if x == 1 or y == 1:
        return shade                                  # тень от рамы
    if x == 10:
        return frame                                  # импост
    if x < 10 and y == 5:
        return frame                                  # форточка
    # тёмное стекло с бликом по диагонали
    glass = (52, 62, 66)
    if (x + y) in (9, 10) or (x + y) in (21,):
        glass = (110, 128, 136)
    return glass + (215,)


save("window", window)

# --- Силикатный кирпич -----------------------------------------------
brnd = random.Random(5)
bnoise = {(x, y): brnd.randint(-7, 7) for x in range(16) for y in range(16)}


def brick(x, y):
    row = y // 4
    off = 0 if row % 2 == 0 else 4
    if y % 4 == 3 or (x + off) % 8 == 7:
        return (176, 176, 172)
    return tuple(v + bnoise[(x, y)] for v in (222, 220, 212))


save("brick", brick)

# --- Кровля, асфальт ---------------------------------------------------
rrnd = random.Random(6)
save("roof", lambda x, y: tuple(v + rrnd.randint(-8, 8) for v in (52, 48, 46)))
arnd = random.Random(7)


def asphalt(x, y):
    r = arnd.random()
    if r < 0.12:
        return (92, 92, 94)
    return tuple(v + arnd.randint(-7, 7) for v in (58, 58, 62))


save("asphalt", asphalt)


# --- Балконы -------------------------------------------------------------
def rail(x, y):
    """Экран из бежевого профлиста под тёмным поручнем."""
    if y <= 1:
        return (70, 58, 50)
    if y == 2:
        return (55, 45, 40)
    base = (205, 186, 128) if x % 4 in (0, 1) else (178, 160, 108)
    if y >= 13:
        base = mix(base, (130, 95, 60), 0.25 * (y - 12))     # рыжие подтёки
    return base


save("rail", rail)
save("rail_top", lambda x, y: (70, 58, 50))


def rail_bars(x, y):
    if y <= 1 or y == 15:
        return (60, 60, 64)
    if x % 4 == 1:
        return (72, 72, 76)
    return T


save("rail_bars", rail_bars)

# --- Водосточная труба -------------------------------------------------
save("drainpipe", lambda x, y: (128, 52, 38) if x % 8 not in (0, 7) else (96, 38, 30)
     if y != 8 else (80, 30, 24))


# --- Подъездная дверь: деревянная, тёмно-бордовая, с филёнками -------------
def door(x, y):
    if x in (0, 15) or y in (0, 31):
        return (38, 26, 24)
    if 3 <= x <= 12 and (3 <= y <= 13 or 17 <= y <= 28):
        edge = x in (3, 12) or y in (3, 13, 17, 28)
        return (62, 34, 32) if edge else (98, 48, 44)
    if x == 13 and 14 <= y <= 16:
        return (200, 190, 150)                        # ручка
    return (84, 42, 38)


save("door", door, 16, 32)
save("door_item", lambda x, y: (84, 42, 38) if 4 <= x <= 11 and 1 <= y <= 14 else T)

# --- Интерьер ------------------------------------------------------------
save("stair_tile", lambda x, y: (196, 186, 166) if (x // 4 + y // 4) % 2 == 0 else (142, 74, 58))
save("rail_dark", lambda x, y: (58, 46, 40))
save("radiator", lambda x, y: (236, 234, 228) if x % 3 != 2 else (188, 186, 180))
save("linoleum", lambda x, y: (148, 104, 62) if (x // 4 + y // 4) % 2 == 0 else (128, 88, 52))
save("wallpaper", lambda x, y: (198, 186, 150) if x % 4 in (0, 1)
     else ((176, 160, 122) if (x + y) % 8 else (150, 110, 80)))


def carpet(x, y):
    if x in (0, 15) or y in (0, 15):
        return (230, 210, 160)
    d = max(abs(x - 7.5), abs(y - 7.5))
    return (150, 25, 35) if int(d) % 3 else (200, 160, 60)


save("carpet", carpet)

# --- Гаражи-ракушки ------------------------------------------------------
save("garage", lambda x, y: (128, 130, 134) if x % 4 else (104, 106, 110))
save("garage_gate", lambda x, y: (62, 112, 72) if y % 4 else (44, 88, 54))

print("ok")

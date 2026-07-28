-- 1. Tabla de equipos
CREATE TABLE IF NOT EXISTS equipos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    pais TEXT NOT NULL
);

-- 2. Tabla de goleadores
CREATE TABLE IF NOT EXISTS goleadores (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    jugador TEXT NOT NULL,
    equipo_id INTEGER,
    FOREIGN KEY (equipo_id) REFERENCES equipos(id)
);

-- 3. Tabla de partidos
CREATE TABLE IF NOT EXISTS partidos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    equipo_local_id INTEGER,
    equipo_visitante_id INTEGER,
    goles_local INTEGER,
    goles_visitante INTEGER,
    FOREIGN KEY (equipo_local_id) REFERENCES equipos(id),
    FOREIGN KEY (equipo_visitante_id) REFERENCES equipos(id)
);

-- --- DATOS DE PRUEBA ---
INSERT INTO equipos (pais) VALUES ('España'), ('Argentina');

INSERT INTO goleadores (jugador, equipo_id) VALUES 
('Yamal', 1),
('Pedri', 1),
('Messi', 2);

INSERT INTO partidos (equipo_local_id, equipo_visitante_id, goles_local, goles_visitante) VALUES 
(1, 2, 3, 1);

-- --- VISTA DE CLASIFICACIÓN ---
CREATE VIEW IF NOT EXISTS vista_clasificacion AS
SELECT 
    e.pais AS Pais,
    SUM(
        CASE 
            WHEN p.equipo_local_id = e.id THEN p.goles_local
            WHEN p.equipo_visitante_id = e.id THEN p.goles_visitante
            ELSE 0 
        END
    ) AS Goles,
    SUM(
        CASE 
            WHEN p.equipo_local_id = e.id AND p.goles_local > p.goles_visitante THEN 3
            WHEN p.equipo_visitante_id = e.id AND p.goles_visitante > p.goles_local THEN 3
            WHEN p.goles_local = p.goles_visitante THEN 1
            ELSE 0 
        END
    ) AS Puntos
FROM equipos e
LEFT JOIN partidos p ON e.id = p.equipo_local_id OR e.id = p.equipo_visitante_id
GROUP BY e.id, e.pais;
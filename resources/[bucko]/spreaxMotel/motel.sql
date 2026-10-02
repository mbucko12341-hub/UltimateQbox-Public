CREATE TABLE IF NOT EXISTS motel_rooms (
            id              INT AUTO_INCREMENT PRIMARY KEY,
            citizenid       VARCHAR(50) UNIQUE NOT NULL,
            room_bucket     INT NOT NULL,
            entry_door_index INT DEFAULT 1,
            is_inside       BOOLEAN DEFAULT FALSE,
            purchased_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            INDEX idx_citizenid (citizenid),
            INDEX idx_bucket    (room_bucket)
)
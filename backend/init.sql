CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    oauth_provider VARCHAR(50),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS dyspos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    location_zone VARCHAR(100) NOT NULL,
    intent_icon VARCHAR(16) NOT NULL,
    start_time TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    end_time TIMESTAMP WITH TIME ZONE NOT NULL
);

CREATE TABLE IF NOT EXISTS friendships (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    friend_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    status VARCHAR(20) NOT NULL DEFAULT 'pending',
    CONSTRAINT unique_friendship UNIQUE (user_id, friend_id)
);

CREATE TABLE IF NOT EXISTS groups (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    members_count INT NOT NULL DEFAULT 1,
    next_meeting VARCHAR(150) NOT NULL DEFAULT 'Brak zaplanowanych spotkań',
    invite_link VARCHAR(150) NOT NULL,
    icon VARCHAR(50) NOT NULL DEFAULT 'person.3',
    color_theme VARCHAR(20) NOT NULL DEFAULT 'green',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS meetings (
    id SERIAL PRIMARY KEY,
    day_label VARCHAR(10) NOT NULL,
    month_label VARCHAR(10) NOT NULL,
    title VARCHAR(150) NOT NULL,
    details VARCHAR(200) NOT NULL,
    group_name VARCHAR(100) NOT NULL,
    location_choice VARCHAR(100) NOT NULL,
    is_highlighted BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
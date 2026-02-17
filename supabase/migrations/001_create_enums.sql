-- ============================================================
-- 001_create_enums.sql
-- Enum types used across the database
-- Run in: Supabase SQL Editor
-- ============================================================

-- User roles
CREATE TYPE public.user_role AS ENUM ('super_admin', 'admin', 'author');

-- Content status
CREATE TYPE public.content_status AS ENUM ('draft', 'published');

-- Supported languages
CREATE TYPE public.content_language AS ENUM ('ta', 'en', 'sa', 'ml', 'hi');

-- Audit log actions
CREATE TYPE public.audit_action AS ENUM ('INSERT', 'UPDATE', 'DELETE');

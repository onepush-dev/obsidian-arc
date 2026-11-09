# Obsidian Arc on Railway

Obsidian Arc — a self-hosted multi-user AI chat service and OpenAI/Anthropic-compatible API gateway in one Go binary. Deploy on Railway with one click.

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/deploy/TEMPLATE_CODE)

This repository packages the official [Obsidian Arc](https://github.com/OnyxAxisOwO/ObsidianArc) image (`ghcr.io/onyxaxisowo/obsidianarc:v0.12.1`, MIT) for Railway. It is an independent community packaging, not affiliated with or endorsed by the Obsidian Arc project (and unrelated to the Obsidian note-taking app).

## What you get

- One service from `ghcr.io/onepush-dev/obsidian-arc:0.12.1`: upstream binary unmodified, SQLite on a Railway volume at `/data`.
- **Admin from the first second**: `OBSIDIAN_ADMIN_PASSWORD` is generated per deploy and the `admin` account is created on first boot, so the first visitor can't claim the instance.
- **`OBSIDIAN_SECRET_KEY`** generated per deploy (encrypts stored provider credentials; keep it, or they become unreadable).
- `OBSIDIAN_PUBLIC_URL` set to your Railway domain (OIDC issuer, OAuth callbacks, mail links).

## Use it

1. Open `https://<your-domain>/` and sign in as `admin` with `OBSIDIAN_ADMIN_PASSWORD` (Variables tab).
2. Admin console → add providers (Anthropic, OpenAI, DeepSeek, xAI, OpenRouter, Groq, Ollama, vLLM) and models, user groups and quotas.
3. Users chat in the web UI; developers create API keys and call `/v1/chat/completions` or `/v1/messages`.

## Notes

- Registration settings (open / invite-only / closed) are in the admin console.
- Back up the `/data` volume (database, attachments).

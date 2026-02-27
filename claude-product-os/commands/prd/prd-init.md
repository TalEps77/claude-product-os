{\rtf1\ansi\ansicpg1252\cocoartf2822
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tqr\tx720\tqr\tx1440\tqr\tx2160\tqr\tx2880\tqr\tx3600\tqr\tx4320\tqr\tx5040\tqr\tx5760\tqr\tx6480\tqr\tx7200\tqr\tx7920\tqr\tx8640\pardirnatural\qr\partightenfactor0

\f0\fs24 \cf0 # /prd-init\
\
Create a modular Release PRD folder from OS templates.\
\
## Usage\
/prd-init <RELEASE_ID>\
\
Example:\
/prd-init R0_MVP\
\
## What it does\
1) Checks whether `product/vision.md` and `product/roadmap.md` exist in the current project repo.\
   - If missing, it warns and asks:\
     "Vision/Roadmap not found. Create them now? (yes/no)"\
   - If yes: creates them from OS templates.\
2) Creates `product/prd/<RELEASE_ID>/` (if not exists).\
3) Copies PRD templates into that folder:\
   - `templates/prd/index.md` \uc0\u8594  `product/prd/<RELEASE_ID>/index.md`\
   - All files in `templates/release-prd/*.md` \uc0\u8594  `product/prd/<RELEASE_ID>/`\
4) Replaces placeholders minimally:\
   - \{\{RELEASE_ID\}\} = <RELEASE_ID>\
   - \{\{DATE_ISO\}\} = current date (ISO)\
   - \{\{DATE_HUMAN\}\} = current date (human readable)\
   - \{\{OWNER\}\} = current user (if known) or "TBD"\
   - \{\{PRODUCT_NAME\}\} = inferred from repo name or asks once if unclear\
   - \{\{VISION_REF\}\} = `/product/vision.md@v<vision_version_or_TBD>`\
5) Prints next step:\
   - "PRD initialized. Next: /prd-next (start with Problem Definition)."\
\
## Constraints (v0.1)\
- Does not lock sections.\
- Does not validate config mismatch (will be handled by orchestrator later).\
- Does not decompose tasks (future command: /decompose).\
\
## Notes\
- The PRD folder is the source of truth.\
- Do not manually edit section status fields; use /lock, /unlock, /revalidate, /approve when available.}
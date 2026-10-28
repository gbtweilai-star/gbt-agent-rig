#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
PYTHONPATH=src python -m gbt_agent_rig info
PYTHONPATH=src python -m gbt_agent_rig check --payload '{}'
PYTHONPATH=src python -m gbt_agent_rig run   --payload '{}'

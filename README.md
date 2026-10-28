# agent_rig

**One capability bit from GBT V8, packaged standalone.** No. 244 of 341,
`system` domain (System).

<p>
<img alt="python" src="https://img.shields.io/badge/python-3.9%2B-blue">
<img alt="license" src="https://img.shields.io/badge/license-MIT-green">
<img alt="deps" src="https://img.shields.io/badge/runtime%20dependencies-0-brightgreen">
</p>

> 编码智能体编队：**把本机已装的 CLI agent 编成并行流水线**（蒸馏自 GitHub 周榜 #02 orca，只取架构）：`agents` 只读盘点可编排的 agent（fail-closed）· `plan` 把一批任务分成 N 份（每份 worktree + 端口段 + 隔离 HOME + 独立日志，口径抄 tentacle_fleet）**只出计划** · `dispatch` 要 process_execute 门、任务只进文件不进命令行 · `collect` 从各份 worktree 收改动。op=agents/plan/dispatch/status/collect/verify/where

That description is copied verbatim from the registry. `tests/test_spec.py` pins it,
so documentation drift fails the build instead of shipping quietly.

## What this package actually is

It is the **contract** for one capability: its name, its parameters, the values it
accepts, and whether it can change state that cannot be restored. It is not the
implementation — that lives in the runtime this bit was extracted from.

So `run()` goes through a narrow `Backend` protocol, and the default backend is a
stub that **says so**:

```
status="validated"   backend="stub"   data={"executed": false}
```

Never `status="ok"`. A stub that reports success is worse than no stub, because the
caller stops looking for the real thing.

## Install

```bash
git clone https://github.com/gbtweilai-star/gbt-agent-rig.git
cd gbt-agent-rig
python -m pip install -e ".[dev]"
```

## Use

```bash
python -m gbt_agent_rig info                  # capability card
python -m gbt_agent_rig spec --json           # machine-readable contract
python -m gbt_agent_rig check --payload '{}'
python -m gbt_agent_rig run   --payload '{}'
```

Real `info` output from this machine:

```text
agent_rig  (system)  v1.0.0
----------------------------------------
编码智能体编队：**把本机已装的 CLI agent 编成并行流水线**（蒸馏自 GitHub 周榜 #02 orca，只取架构）：`agents` 只读盘点可编排的 agent（fail-closed）· `plan` 把一批任务分成 N 份（每份 worktree + 端口段 + 隔离 HOME + 独立日志，口径抄 tentacle_fleet）**只出计划** · `dispatch` 要 process_execute 门、任务只进文件不进命令行 · `collect` 从各份 worktree 收改动。op=agents/plan/dispatch/status/collect/verify/where

gated      : False
external   : False
multi-op   : True
params     : (none)
values     : agents, plan, dispatch, status, collect, verify, where
```

Wire a real implementation:

```python
from gbt_agent_rig import run

class MyBackend:
    name = "my-backend"
    def invoke(self, cap, payload):
        return {"cap": cap, "handled": sorted(payload)}

result = run({}, backend=MyBackend())
assert result.status == "ok"
```

## Parameters

| name | required | notes |
|---|---|---|
| — | no | the registry declares no required parameters |

Registry hint (`params_hint`): (empty)

**注册表登记的取值 / 子动作（7 个）**：`agents`、`plan`、`dispatch`、`status`、`collect`、`verify`、`where`

Types are deliberately absent: the registry does not declare them, and an invented
type is worse than no type, because callers believe it.

## Boundaries

- Not gated: the registry marks this bit `safe: true`.
- No external service dependency declared.
- Multi-op (`multi_op: true`): several sub-actions share one name — read `op` before calling.
- No implementation ships here. Bring a backend; the protocol is one method.

## What this is not

Not a wrapper around a hosted API. Not a model. Not a promise that calling it does
anything on its own. It is the typed seam plus the validation, which is the part that
stays correct even when the implementation changes.

## Tests

```bash
python -m pytest
```

```text
20 passed, 3 skipped in 0.15s
```

## Provenance

| field | value |
|---|---|
| capability | `agent_rig` |
| domain | `system` |
| handler | `agent_rig` |
| safe | `True` (gated = `False`) |
| external | `False` |
| atlas page | [system/agent_rig](https://github.com/gbtweilai-star/gbt-caps/blob/main/caps/system/agent_rig.md) |
| full index | [https://github.com/gbtweilai-star/gbt-caps](https://github.com/gbtweilai-star/gbt-caps) |

The parent README says 348 capabilities; an AST pass over the registry enumerates
`341 + 0 unimplemented + 0 disabled = 341`. The extra 7 are historical duplicates.
Numbering here follows 341 and matches the `gbt-caps` index one-to-one.

## License

MIT.

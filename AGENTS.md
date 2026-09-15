# Repository Guidelines

## Project Overview

This repository is a small Windows PowerShell utility for choosing an audio playback device through a graphical dialog and making the selection the Windows default playback device. The external `AudioDeviceCmdlets` module supplies audio-device enumeration and selection commands.

The repository currently contains one executable script and one setup note; there are no application modules, package manifests, or service components.

## Architecture & Data Flow

- `change.ps1` is the sole entry point and uses top-level imperative PowerShell.
- Startup loads `.NET` `System.Windows.Forms` and `System.Drawing`, then builds a modal WinForms dialog.
- `Get-AudioDevice -List` enumerates devices. The script keeps only objects whose `Type` is `Playback`.
- Each matching device is wrapped in a `PSCustomObject` containing the display `Name` and original `AudioDevice` object, so the UI displays a name while retaining the device ID.
- After the user selects a row and clicks **OK**, the selected ID is passed to `Set-AudioDevice ... -DefaultOnly`. **Cancel** and **OK** without a selection perform no device change.
- There is no persistence, background processing, or internal state beyond the form and selected object.

## Key Directories

The project is flat at the repository root:

- `change.ps1` — Windows Forms UI and audio-device selection flow.
- `setup.md` — documented dependency installation command.

There are currently no `src/`, `tests/`, fixtures, CI, build, or deployment directories.

## Development Commands

The repository documents only dependency setup:

```powershell
Install-Module -Name AudioDeviceCmdlets
```

For a manual run, execute the entry-point script from a Windows PowerShell session:

```powershell
.\change.ps1
```

The invocation above is the conventional execution for the `.ps1` entry point; the repository does not document a run command, execution-policy requirements, or a PowerShell version. There are no defined build, lint, format, type-check, or automated test commands. Do not introduce commands from another ecosystem without adding the corresponding project configuration.

## Code Conventions & Common Patterns

- Keep the script top-level and imperative unless a change genuinely requires a reusable function or module.
- Use approved PowerShell cmdlet naming (`Verb-Noun`), as in `Get-AudioDevice` and `Set-AudioDevice`.
- Preserve the existing WinForms control construction pattern and the `PSCustomObject` wrapper that separates the display name from the original device object.
- Existing naming is mixed: controls use names such as `$OKButton` and `$listBox`, while the device collection is `$device_list`. Match nearby style rather than performing unrelated renames.
- Existing blocks use two-space indentation. Strings use both single and double quotes; avoid broad formatting-only changes.
- Preserve the safety condition that requires both an **OK** result and a selected item before changing the default device. The script currently has no explicit error handling or logging.

## Important Files

| Path | Role |
| --- | --- |
| `change.ps1` | Entry point; creates the dialog, filters playback devices, and sets the selected device as default-only. |
| `setup.md` | Minimal setup instruction for installing `AudioDeviceCmdlets`. |
| `AGENTS.md` | AI-assistant guidance for repository structure, commands, conventions, and QA. |

## Runtime/Tooling Preferences

- Run on Windows with a desktop-capable PowerShell host and access to `.NET` Windows Forms and Drawing assemblies.
- Install and use the `AudioDeviceCmdlets` PowerShell module; its version and installation scope are not pinned.
- The code is PowerShell, not Node/Bun or a compiled project. No package manager, lockfile, formatter, linter, type checker, CI configuration, or reproducibility configuration is present.
- Changes that touch audio behavior should account for the side effect of changing the system default playback device and should not assume a non-interactive environment.

## Testing & QA

No automated tests, test framework, fixtures, coverage configuration, or CI workflow exist in the repository. Do not claim test coverage or invent a test command.

Use a manual Windows smoke check after script changes:

1. Install `AudioDeviceCmdlets` using the documented setup command.
2. Run `change.ps1` on a Windows desktop with playback devices available.
3. Confirm the list contains playback devices and excludes non-playback devices.
4. Select a device and click **OK**; verify that the selected device becomes the default playback device.
5. Re-run and click **Cancel**, or leave no item selected; verify that the default device is unchanged.

Because step 4 changes system audio state, use a safe test device and restore the intended default afterward. There is no repository-provided test harness for mocking `Get-AudioDevice` or `Set-AudioDevice`.

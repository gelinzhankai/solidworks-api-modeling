---
name: solidworks-api-modeling
description: Build, modify, and verify SolidWorks parts through the Windows COM API from Codex. Use when the user wants Codex to drive SolidWorks 2024 or similar versions directly, create or edit SLDPRT models from dimensions, engineering drawings, sketches, or screenshots, generate Python/pywin32 automation scripts, manage SolidWorks windows/documents, capture verification snapshots, or troubleshoot COM modeling issues such as wrong sketch planes, failed cuts, stale windows, unsaved files, and complex closed sketch profiles.
---

# SolidWorks API Modeling

Use this skill as the execution discipline for engineering-drawing-to-SolidWorks modeling. Use the installed `solidworks-automation` skill as the API helper/reference layer when reusable functions for sketches, features, assemblies, drawings, or export are useful.

## Operating Contract

1. Connect to the running SolidWorks session when possible; keep the user-visible session active.
2. Convert the drawing into a feature plan before coding: base body, datum/axis, secondary cuts, ribs, holes, fillets/chamfers, annotations.
3. Build one feature group at a time. Do not regenerate from a new blank part when the user is inspecting a paused intermediate state.
4. For complex sketches, pause after drawing the sketch and capture a normal-to snapshot before creating the feature.
5. After each committed feature group, rebuild, capture an isometric snapshot, and check geometry against the drawing.
6. Save the completed model, but leave the final SolidWorks document open.

## Use the Automation Skill

Prefer the installed helper skill at:

`C:\Users\24262\.codex\skills\solidworks-automation`

Read only the needed file:

- `scripts/sw_connect.py`: connection, new/open/save helpers, `mm()`, `deg()`.
- `scripts/sw_part.py`: sketches, boss/cut extrudes, revolve, fillet, chamfer, shell, rib, patterns, Hole Wizard.
- `scripts/sw_assembly.py`: components and mates.
- `scripts/sw_drawing.py`: drawing views, notes, dimensions, sheets.
- `scripts/sw_export.py`: STEP/STL/IGES/Parasolid/PDF/DXF export.
- `references/part-modeling.md`: API parameter reminders for sketches/features.
- `references/troubleshooting.md`: selection, sketch, and save failures.

Keep project-specific scripts in the workspace when they encode a real modeling sequence. Do not copy large generic helper code into each project script.

## Step Mode

For user-reviewed modeling, write scripts with explicit modes such as:

- `init-base`: create or reset only the intended automation-owned part.
- `add-<feature>-sketch`: attach to the active document, draw only the sketch, save a sketch snapshot, then stop.
- `commit-<feature>`: attach to the same active document and create the feature from the verified sketch.
- `verify`: rebuild, report body count, bounding box, feature names, active file path, and save a fresh snapshot.

Do not combine all steps into one rerun when the user is correcting plane, direction, or position errors.

## Plane and Direction Rules

- Treat sketch plane choice as a first-class design decision. State the intended plane, local axes, and feature direction before sketching.
- The extrude/cut direction follows the sketch plane normal; a correct outline on the wrong plane is still wrong.
- Prefer real faces selected by normal and bounding box over localized plane names.
- Use meters in COM calls and millimeters at user/script boundaries.
- Verify with actual geometry: `GetPartBox(True)`, body count, face normals, face boxes, and visible snapshots.

Common conventions:

- Plates/brackets: define global axes first. For example, `X=length`, `Y=height/thickness`, `Z=width`; then map each drawing view to a plane.
- Through holes in plates: sketch on the target face or mid-plane, then cut in the correct direction or both directions.
- Pockets/saddles/U-slots: sketch on the actual face that owns the opening; verify the cut does not pass into unrelated bodies.
- Ribs: sketch the side profile on the side-view plane and extrude by rib thickness; verify the rib intersects the base and target body.
- Shaft grooves: full-circumference grooves are turned geometry, not local slots.
- Shaft keyways: use a tangent plane on the cylinder, draw a clean closed round-ended slot, and cut inward.

## Sketch Quality Rules

- Use true arcs for geometry that is round in the drawing. Do not approximate arcs with polylines unless explicitly diagnosing an API failure.
- Use one clean closed profile for a round-ended slot: line, semicircle, line, semicircle. Avoid untrimmed rectangle-plus-two-circles profiles.
- For spline or tooth profiles, follow the drawing callout and section view; do not invent a generic star or rectangular pattern.
- Hidden construction lines, centerlines, or guide geometry must not create ambiguous closed regions.

## Window and File Hygiene

- Close only automation-owned stale documents: unsaved temporary parts or saved files inside the known output directory.
- Never close unrelated user documents.
- Use timestamped snapshot folders such as `snapshots/<part>/run_YYYYMMDD_HHMMSS/`; avoid fixed filenames that can show old model states.
- Treat `SaveAs3` as untrusted until the output exists, is non-empty, and the active document path is as expected.

## References

- Read `references/solidworks-com-patterns.md` for environment checks, COM quirks, cleanup, save, and snapshot snippets.
- Read `references/shaft-modeling.md` before shafts, keyways, grooves, splines, threads, or revolved features.
- Read `solidworks-automation/references/part-modeling.md` when feature API arguments or sketch entities are needed.

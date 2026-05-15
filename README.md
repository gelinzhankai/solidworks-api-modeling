# SolidWorks API Modeling Skill

This Codex skill helps an AI agent drive SolidWorks through the Windows COM API to create, modify, and verify parametric parts from dimensions, engineering drawings, sketches, or screenshots.

It is designed for practical CAD automation work where SolidWorks is installed locally and the model can be built step by step with visual verification.

## Best Fit

This skill performs best on parts with clear dimensions, regular geometry, and feature-based construction logic, especially:

- Stepped shafts, simple transmission shafts, keyway shafts, grooved shafts, and other axisymmetric parts.
- Simple bearing housings, support brackets, mounting bases, plates, covers, flanges, and hole-pattern parts.
- Parts built from common SolidWorks features such as sketches, extrudes, cuts, revolves, holes, fillets, chamfers, ribs, shells, and patterns.
- Engineering drawings where the main views, section views, diameters, lengths, hole positions, and groove/keyway details are readable.

For simple shaft parts and simple bearing-seat or bracket-like parts, the workflow is usually reliable because the model can be decomposed into clear feature groups: base body, holes, grooves, slots, ribs, rounds, and chamfers.

## What It Does

- Connects to a running SolidWorks session through Python and `pywin32`.
- Creates or edits SolidWorks part files (`.SLDPRT`).
- Converts millimeter dimensions into SolidWorks API meter units.
- Builds models using sketches and standard part features.
- Captures verification snapshots before and after important operations.
- Encourages step-by-step modeling instead of one-shot generation for complex parts.
- Keeps the final SolidWorks model open after saving so the user can inspect it.

## Important Limits

This skill is not a replacement for a human CAD engineer.

It works best when the drawing is clear and the geometry can be described with normal SolidWorks features. It may need extra human confirmation for:

- Complex castings with ambiguous freeform surfaces.
- Poorly scanned or incomplete drawings.
- Dense tolerance, GD&T, roughness, and manufacturing annotations.
- Advanced surfacing, loft-heavy parts, organic shapes, or aesthetic surfaces.
- Assemblies where mating intent is not clear from the input.

For complex sketches, the intended workflow is to draw the sketch first, capture a SolidWorks snapshot, let the user confirm the plane/orientation/profile, and only then create the feature.

## Requirements

- Windows.
- SolidWorks installed and registered for COM automation.
- Python 3.8+.
- `pywin32`.

Typical dependency setup:

```powershell
py -3 -m pip install pywin32
```

To check the local environment, run:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\check_sw_env.ps1
```

## Installation

Install this repository as a Codex skill, or copy the repository folder into your Codex skills directory:

```text
C:\Users\<you>\.codex\skills\solidworks-api-modeling
```

The required SolidWorks helper scripts are bundled in this repository:

- `scripts/sw_connect.py`
- `scripts/sw_part.py`

No separate installation of `solidworks-automation-skill` is required for normal part modeling.

## Recommended Workflow

1. Open SolidWorks manually.
2. Ask Codex to use this skill to model a part from a drawing or dimensions.
3. Let Codex extract a feature plan from the drawing.
4. Build one feature group at a time.
5. For any complex sketch, verify the screenshot before creating the feature.
6. Rebuild, inspect, and save the model.
7. Leave the final part open in SolidWorks.

This incremental workflow is important. It helps catch common CAD automation errors such as sketching on the wrong plane, cutting in the wrong direction, using stale windows, or creating an ambiguous sketch profile.

## Example Requests

```text
Use this skill to create a stepped shaft from this engineering drawing.
```

```text
Model a simple bearing housing with a base plate, four mounting holes, a central bore, ribs, and fillets.
```

```text
Continue editing the active SolidWorks part. Add a round-ended keyway on the shaft surface and show me the sketch before cutting.
```

```text
Create a 120 mm x 75 mm x 10 mm rectangular plate with four corner holes, a center pocket, and 1 mm chamfers.
```

## Modeling Notes

- Use millimeters in user-facing dimensions.
- Use SolidWorks API meter units internally.
- Prefer real arcs for round geometry instead of polyline approximations.
- For shaft grooves, model full-circumference turned grooves instead of local rectangular cuts.
- For keyways on cylinders, use a tangent sketch plane and cut inward.
- For ribs and brackets, define the global coordinate system before sketching.
- Store tolerances, roughness, material, and heat-treatment notes as custom properties unless full PMI annotation is requested.

## License Notes

Some bundled helper code is derived from `solidworks-automation-skill` under the MIT License. See `THIRD_PARTY_NOTICES.md`.

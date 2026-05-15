# SolidWorks API Modeling Skill

This Codex skill helps an AI agent drive SolidWorks through the Windows COM API to create, modify, and verify parametric parts from dimensions, engineering drawings, sketches, or screenshots.

It is designed for practical CAD automation work where SolidWorks is installed locally and the model can be built step by step with visual verification.

## Best Fit

This skill performs best on parts with clear dimensions, regular geometry, and feature-based construction logic, especially:

- Simple shaft parts: stepped shafts, transmission shafts, keyway shafts, grooved shafts, relief-groove shafts, and simple spline shafts.
- Simple bearing-seat and bracket parts: bearing housings, support brackets, mounting bases, base plates, ribbed structures, flanges, and covers.
- Plate and hole-pattern parts: rectangular plates, mounting plates, counterbored plates, and flange hole patterns.
- Parts built from common SolidWorks features such as sketches, extrudes, cuts, revolves, holes, fillets, chamfers, ribs, shells, and patterns.
- Engineering drawings where the main views, section views, dimensions, hole positions, grooves, diameters, and lengths are readable.

For simple shaft parts and simple bearing-seat or bracket-like parts, the workflow is usually more reliable because the model can be decomposed into clear feature groups: base body, steps, holes, grooves, slots, ribs, fillets, and chamfers.

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
- Dense tolerance, GD&T, roughness, heat-treatment, material, and manufacturing annotations.
- Advanced surfacing, loft-heavy parts, organic shapes, or aesthetic surfaces.
- Assemblies where mating intent is not clear from the input.

For complex sketches, the intended workflow is to draw the sketch first, capture a SolidWorks snapshot, let the user confirm the plane, orientation, and profile, and only then create the feature.

## Requirements

- Windows.
- SolidWorks installed and registered for COM automation.
- Python 3.8+.
- `pywin32`.

Install `pywin32`:

```powershell
py -3 -m pip install pywin32
```

Check the local SolidWorks automation environment:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\check_sw_env.ps1
```

## Installation

Install or copy this repository into your Codex skills directory, for example:

```text
C:\Users\<you>\.codex\skills\solidworks-api-modeling
```

The required SolidWorks helper scripts are bundled in this repository:

- `scripts/sw_connect.py`: SolidWorks connection, document creation/open/save, unit conversion, and COM compatibility helpers.
- `scripts/sw_part.py`: sketches, boss extrudes, cut extrudes, revolves, fillets, chamfers, ribs, patterns, and holes.

No separate installation of `solidworks-automation-skill` is required for normal part modeling.

## Recommended Workflow

1. Open SolidWorks manually.
2. Ask Codex to use this skill to model a part from a drawing or dimensions.
3. Let Codex extract a feature plan from the drawing.
4. Build one feature group at a time.
5. For any complex sketch, verify the screenshot before creating the feature.
6. Rebuild and inspect the model after important feature groups.
7. Save the final model, but leave the part window open in SolidWorks.

This incremental workflow is important. It helps catch common CAD automation errors such as sketching on the wrong plane, cutting in the wrong direction, reading stale window screenshots, or creating an ambiguous sketch profile.

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
- For shaft relief grooves and annular grooves, model full-circumference turned features instead of local rectangular cuts.
- For keyways on cylinders, use a tangent sketch plane and cut inward along the plane normal.
- For brackets, bearing seats, base plates, and ribs, define the global coordinate system before sketching.
- Store tolerances, roughness, material, and heat-treatment notes as custom properties unless full PMI annotation is requested.

## License Notes

Some bundled helper code is derived from `solidworks-automation-skill` under the MIT License. See `THIRD_PARTY_NOTICES.md`.

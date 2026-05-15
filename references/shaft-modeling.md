# Shaft Modeling Notes

## Coordinate Convention

Use the shaft axis as the modeling X axis. Build segments from left to right.

Recommended default workflow:

1. Create the first circular segment on the Right Plane.
2. Select the current right end face.
3. Sketch the next circular segment and extrude.
4. Repeat until the full stepped body is complete.
5. Add secondary features only after the base shaft is dimensionally correct.

## Turned Grooves

Grooves that run around the full circumference are turned features, not local cuts.

Robust options:

- Split the base shaft into smaller-diameter short segments at groove positions.
- Use revolved cuts only when the axis and sketch closure are verified.

Avoid modeling full-circumference grooves as local rectangular cuts from a side plane.

## Keyways

For a keyway on a cylindrical shaft:

- Create/select a tangent plane at the target shaft radius.
- Sketch the keyway on that tangent plane.
- Cut inward along the sketch normal.
- Use a clean closed slot profile.

For round-ended keyways:

- Top straight segment.
- Right `Create3PointArc` semicircle.
- Bottom straight segment.
- Left `Create3PointArc` semicircle.

Avoid untrimmed "rectangle + two full circles" profiles because SolidWorks may fail to select the intended closed region.

## Rectangular Splines

When the drawing specifies a rectangular spline such as `6x42x48x12`:

- `6`: tooth count.
- `42`: minor/root diameter.
- `48`: major diameter.
- `12`: tooth width.

Use the drawing's cross-section to decide whether root/crest geometry is straight, circular, or chamfered. If circular root or crest arcs are shown, draw real arcs with `Create3PointArc`; do not use polyline approximations unless diagnosing API behavior.

Always capture the spline cross-section sketch before extrusion. Verify:

- It is closed.
- It has the correct tooth count.
- Roots and crests match the drawing.
- The intended shaded region is the material region.

## Engineering Drawing Translation

Convert drawing annotations into a modeling spec before coding:

- Geometry: model as features.
- Tolerances and fits: custom properties unless PMI is requested.
- Roughness: custom properties unless annotations are requested.
- Heat treatment/material notes: custom properties.
- Datum labels: custom properties or 3D annotations only when requested.
